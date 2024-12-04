param location string = resourceGroup().location
param sqlServerName string 
param sqlAdminLogin string
param sqlDatabaseName array
@minLength(10)
@maxLength(20)
@secure()
param sqlAdminPassword string
param dtuMax int
param dtuMaxPerDb int
param startIpAddr string
param endIpAddr string
param sqlFirewallName string
param sqlElasticPoolName string


resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  location:location
  name: 'srv-${sqlServerName}'
  properties: { 
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
  }
}

resource elasticPool 'Microsoft.Sql/servers/elasticPools@2024-05-01-preview' = {
  location: location 
  name: 'pool-${sqlElasticPoolName}'
  parent: sqlServer
  sku:{
    name: 'BasicPool'
    capacity: dtuMax
  }
  properties:{ 
    perDatabaseSettings: {
      maxCapacity: dtuMaxPerDb
    } 
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = [for db in sqlDatabaseName : { 
  name: 'db-${db}-${uniqueString(db, resourceGroup().id)}'
  parent: sqlServer
  location: location
  properties: {
    elasticPoolId: elasticPool.id
  }
}]

resource sqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  name: sqlFirewallName
  parent: sqlServer
  properties:{
    startIpAddress: startIpAddr
    endIpAddress: endIpAddr
  }
}



