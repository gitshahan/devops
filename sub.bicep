targetScope = 'subscription'

@description('Resource Group Name')
param rgName string

@description('Resource Group Location')
param rgLocation string

resource resourceGrp 'Microsoft.Resources/resourceGroups@2024-08-01' = {
  name: rgName
  location: rgLocation
}
