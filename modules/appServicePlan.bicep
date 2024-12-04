// paramètres
param location string = resourceGroup().location
param MiseAEchelle string
param spNameParam string 
param webAppNameParams array

// Variables
var spName = 'sp-${spNameParam}'
var plan  = toLower(MiseAEchelle) == 'non' ? 'F1' : toLower(MiseAEchelle) == 'manuel' ? 'B1' : toLower(MiseAEchelle) == 'auto' ? 'S1' : ''


// creation app service plan
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: spName
  location: location
  sku:{
    name: plan
    capacity: length(webAppNameParams)
  }
  tags:{
    Application: 'application'
  }
}

// creation app service
resource webApp 'Microsoft.Web/sites@2024-04-01' = [ for appIndex in range(0,length(webAppNameParams)): {
  location: location
  name: 'wepapp-${webAppNameParams[appIndex]}-${uniqueString('${appIndex}-${webAppNameParams[appIndex]}',resourceGroup().id)}'
  properties:{
    serverFarmId: appServicePlan.id
  }
  tags:{
    Application: 'wepapp-${webAppNameParams[appIndex]}-${uniqueString('${appIndex}-${webAppNameParams[appIndex]}',resourceGroup().id)}'
  }
}]

// creation slot lorsque le plan est S1
resource slots 'Microsoft.Web/sites/slots@2024-04-01' = [for index in range(0, length(webAppNameParams)):  if (plan == 'S1')  {
  location: location
  name: 'staging'
  parent: webApp[index]
  properties:{
    serverFarmId: webApp[index].properties.serverFarmId
  }
}]

// création d'une règle de mise à l'echelle lorsque le plan est S1
resource autoscaleSettings 'Microsoft.Insights/autoscalesettings@2022-10-01' = if (plan == 'S1') {
  name: '${appServicePlan.name}-autoscale'
  location: location
  properties: {
    name: '${appServicePlan.name}-autoscale'
    enabled: true
    targetResourceUri: appServicePlan.id
    profiles: [
        {
          name: 'CPUMiseAEchelle'
          capacity: { 
            minimum: '1'
            default: '1'
            maximum: '5'
          }
          rules: [
            // Augmentation instance de 1 quand CPU > 70%
            {
              metricTrigger: { 
                metricName: 'CpuPercentage'
                metricNamespace: 'Microsoft.Web/serverfarms'
                metricResourceUri: appServicePlan.id
                operator: 'GreaterThanOrEqual'
                threshold: 70
                statistic: 'Average'
                timeAggregation: 'Average'
                timeGrain: 'PT1M'
                timeWindow: 'PT5M'
              }
              scaleAction:{
                direction: 'Increase'
                type: 'ChangeCount'
                value: '1'
                cooldown: 'PT5M'
              }
            }
            // Reduction instance de 1 quand CPU < 70%
            {
              metricTrigger: { 
                metricName: 'CpuPercentage'
                metricResourceUri: appServicePlan.id
                metricNamespace: 'Microsoft.Web/serverfarms'
                operator: 'LessThan'
                threshold: 70
                statistic: 'Average'
                timeAggregation: 'Average'
                timeGrain: 'PT1M'
                timeWindow: 'PT5M'
              }
              scaleAction:{
                direction: 'Decrease'
                type: 'ChangeCount'
                value: '1'
                cooldown: 'PT5M'
              }
            }
          ]
        }
    ]
  }
}
