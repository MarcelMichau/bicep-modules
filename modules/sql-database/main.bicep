@description('The name of the SQL Server')
param sqlServerName string

@description('The name of the SQL Database')
param databaseName string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Sku of the SQL Database - https://docs.microsoft.com/en-us/azure/templates/microsoft.sql/servers/databases?tabs=bicep#sku')
param sku object = {
  name: 'Basic'
  tier: 'Basic'
}

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' existing = {
  name: sqlServerName
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  parent: sqlServer
  name: databaseName
  sku: sku
  location: location
}
