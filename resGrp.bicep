targetScope = 'resourceGroup'

@description('ACR Name')
param acrName string

@description('ACR SKU (Basic, Standard, Premium)')
param acrSKU string

@description('KeyVault Name')
param kvName string

@description('KeyVault SKU (Standard, Premium)')
param kvSKU string

@description('Logged in user\'s object id')
param currUser string

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: resourceGroup().location
  sku: {
    name: acrSKU
  }
  properties: {
    adminUserEnabled: true
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: kvName
  location: resourceGroup().location
  properties: {
    sku: {
      name: kvSKU
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      { objectId: currUser, permissions: { secrets: ['all'] }, tenantId: subscription().tenantId }
    ]
  }
}
