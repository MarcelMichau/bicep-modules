targetScope = 'subscription'

@description('Name of the Resource Group to create')
param resourceGroupName string

@description('Location in which to create the Resource Group')
param location string

@description('Tags to apply to the Resource Group')
param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
  properties: {}
}

output name string = resourceGroup.name
