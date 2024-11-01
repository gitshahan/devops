targetScope = 'resourceGroup'

@description('ACR Name')
param acrName string

@description('SKU (Basic, Standard, Premium)')
param sku string

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: resourceGroup().location
  sku: {
    name: sku
  }
}

