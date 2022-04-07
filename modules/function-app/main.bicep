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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: storageAccountName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: appServicePlanName
}

var storageAccountKey = storageAccount.listKeys().keys[0].value

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      http20Enabled: true
      ftpsState: 'Disabled'
      appSettings: [
        {
          name: 'AzureWebJobsDashboard'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountKey}'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountKey}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountKey}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: '${functionAppName}-${uniqueString(functionAppName)}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}
