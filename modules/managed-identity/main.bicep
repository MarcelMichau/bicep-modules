@description('Name of the Managed Identity to create')
param managedIdentityName string = 'mi-test'

@description('Location in which to create the Managed Identity')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

output name string = managedIdentity.name
