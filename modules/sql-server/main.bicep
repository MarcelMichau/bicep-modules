@description('The name of the SQL logical server')
param serverName string = uniqueString('sql', resourceGroup().id)

@description('Location for all resources')
param location string = resourceGroup().location

@description('The Azure AD administrator username of the SQL logical server')
param azureAdAdministratorLogin string

@description('The Azure AD administrator Azure AD Object ID')
param azureAdAdministratorObjectId string

@description('The Azure AD administrator Azure AD Tenant ID')
param azureAdAdministratorTenantId string = subscription().tenantId

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: 'administrator'
    administratorLoginPassword: '${uniqueString(serverName)}(!)123'
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: azureAdAdministratorLogin
      principalType: 'Group'
      sid: azureAdAdministratorObjectId
      tenantId: azureAdAdministratorTenantId
    }
  }
}

resource allowAllAzureIps 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  parent: sqlServer
  name: 'AllowAllAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource enableActiveDirectoryAuth 'Microsoft.Sql/servers/administrators@2021-11-01-preview' = {
  parent: sqlServer
  name: 'ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: azureAdAdministratorLogin
    sid: azureAdAdministratorObjectId
    tenantId: azureAdAdministratorTenantId
  }
}

output name string = sqlServer.name
