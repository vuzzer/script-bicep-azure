param sqlServerName string 
param sqlAdminLogin string
param sqlDatabaseName array
@secure()
param sqlAdminPassword string
param dtuMax int = 200
param dtuMaxPerDb int = 5
param startIpAddr string = '100.0.0.1'
param endIpAddr string = '100.10.255.255'
param sqlFirewallName string =  'AllowAllIps'
param sqlElasticPoolName string = 'elasticPool'

module database 'modules/serverDatabase.bicep' = { 
  name: 'databaseService123'
  params: {
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
    sqlDatabaseName: sqlDatabaseName
    sqlServerName: sqlServerName
    dtuMax:dtuMax
    dtuMaxPerDb:dtuMaxPerDb
    startIpAddr: startIpAddr
    endIpAddr: endIpAddr
    sqlElasticPoolName:sqlElasticPoolName
    sqlFirewallName: sqlFirewallName
  }
}
