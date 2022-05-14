@description('Name of the Resource Group to create')
param appServicePlanName string = 'plan-test'

@description('Location in which to create the App Service Plan')
param location string = resourceGroup().location

@description('Tags to apply to the App Service Plan')
param tags object = {}

@description('Sku of the App Service Plan - https://docs.microsoft.com/en-us/azure/templates/microsoft.web/serverfarms?tabs=bicep#skudescription')
param sku object = {
  name: 'F1'
  capacity: 1
}

@description('Kind of the OS to use for the App Service Plan')
@allowed([
  'windows'
  'linux'
])
param kind string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  tags: tags
  location: location
  sku: sku
  kind: kind
  properties: {
    elasticScaleEnabled: false
    targetWorkerCount: 1
    zoneRedundant: false
    reserved: kind == 'linux'
  }
}

output name string = appServicePlan.name
