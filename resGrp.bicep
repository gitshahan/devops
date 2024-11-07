targetScope = 'resourceGroup'

@description('App Service Plan Name')
param aspName string

@description('Function App name')
param functionName string

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
  kind: 'functionapp, linux'
  properties: {
    serverFarmId: asp.id
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
      ]
    }
  }
}
