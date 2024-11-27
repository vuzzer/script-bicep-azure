// parametre pour le module 1
param MiseAEchelle1 string
param webAppNameParams1 array

// paramètre pour le module 2
param MiseAEchelle2 string
param webAppNameParams2 array


module appService1 'modules/appServicePlan.bicep' = {
  name: 'appService1'
  params:{
    MiseAEchelle: MiseAEchelle1
    spNameParam: 'appService1'
    webAppNameParams: webAppNameParams1
  }
}

module appService2 'modules/appServicePlan.bicep' = {
  name: 'appService2'
  params:{
    MiseAEchelle: MiseAEchelle2
    spNameParam: 'appService2'
    webAppNameParams: webAppNameParams2
  }
}
