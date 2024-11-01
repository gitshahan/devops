targetScope = 'subscription'

@description('Resource Group Name')
param rgName string

@description('Resource Group Location')
param rgLocation string

resource rg 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: rgName
  location: rgLocation
}
