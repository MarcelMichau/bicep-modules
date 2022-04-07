@description('Name of the Storage Account to create - Character limit: 3-24 - Valid characters: Lowercase letters and numbers.')
param storageAccountName string = 'sttest'

@description('Location in which to create the Storage Account')
param location string = 'location'

@description('Tags to apply to the Storage Account')
param tags object = {}

@description('Kind of the Storage Account')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param kind string = 'StorageV2'

@description('Sku of the Storage Account')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param sku string = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: kind
  sku: {
    name: sku
  }
}

output name string = storageAccount.name
