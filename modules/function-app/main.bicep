@description('Name of the Function App to create')
param functionAppName string = 'func-test'

@description('Location in which to create the App Service Plan')
param location string = 'location'

@description('Tags to apply to the App Service Plan')
param tags object = {}

@description('Name of the App Service Plan used by the Function App')
param appServicePlanName string

@description('Name of the Storage Account used by the Function App')
param storageAccountName string

@description('Runtime stack version for the Function App on Linux - Required when not using Consumption Plan')
param linuxFxVersion string = ''

@description('.NET version for the Function App on Windows')
param netFrameworkVersion string = ''

@description('Runtime for the Function App')
param functionRuntime string = 'dotnet'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: storageAccountName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: appServicePlanName
}

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: empty(linuxFxVersion) ? null : linuxFxVersion
      netFrameworkVersion: empty(netFrameworkVersion) ? null : netFrameworkVersion
      http20Enabled: true
      ftpsState: 'Disabled'
      appSettings: [
        {
          name: 'AzureWebJobsStorage__accountName'
          value: storageAccountName
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
      ]
    }
  }
}

var storageBlobDataOwnerRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b')

resource storageBlobDataOwnerRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(storageAccountName, storageBlobDataOwnerRoleDefinitionId, functionApp.name)
  scope: storageAccount
  properties: {
    principalId: functionApp.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: storageBlobDataOwnerRoleDefinitionId
  }
}

output name string = functionApp.name
