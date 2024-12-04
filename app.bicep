// parametre pour le module 1
param MiseAEchelle1 string
param webAppNameParams1 array
param spNameParam1 string


// paramètre pour le module 2
param MiseAEchelle2 string
param webAppNameParams2 array
param spNameParame2 string


module appService1 'modules/appServicePlan.bicep' = {
  name: spNameParam1
  params:{
    MiseAEchelle: MiseAEchelle1
    spNameParam:  spNameParam1
    webAppNameParams: webAppNameParams1
  }
}

module appService2 'modules/appServicePlan.bicep' = {
  name: spNameParame2
  params:{
    MiseAEchelle: MiseAEchelle2
    spNameParam: spNameParame2
    webAppNameParams: webAppNameParams2
  }
}
