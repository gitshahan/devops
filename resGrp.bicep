targetScope = 'resourceGroup'

@description('ACR Name')
param acrName string

@description('ACR SKU (Basic, Standard, Premium)')
param acrSKU string

@description('App Service Plan Name')
param aspName string

@description('Function App name')
param functionName string

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

resource asp 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: aspName
  location: resourceGroup().location
  sku: {
    name: 'Y1'
    capacity: 1
  }
  properties: {
    reserved: true
  }
}

resource function 'Microsoft.Web/sites@2020-12-01' = {
  name: functionName
  location: resourceGroup().location
  kind: 'functionapp'
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${acr.properties.loginServer}'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: acr.listCredentials().username
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: acr.listCredentials().passwords[0].value
        }
      ]
    }
  }
}
