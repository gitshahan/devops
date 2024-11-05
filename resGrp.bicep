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
    name: 'B1'
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
      linuxFxVersion: 'Python|3.11'
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
      ]
    }
  }
}

resource azureFunction 'Microsoft.Web/sites@2020-12-01' = {
  name: 'name'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: 'serverfarms.id'
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsDashboard'
          value: 'DefaultEndpointsProtocol=https;AccountName=storageAccountName1;AccountKey=${listKeys('storageAccountID1', '2019-06-01').key1}'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=storageAccountName2;AccountKey=${listKeys('storageAccountID2', '2019-06-01').key1}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=storageAccountName3;AccountKey=${listKeys('storageAccountID3', '2019-06-01').key1}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('name')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference('insightsComponents.id', '2015-05-01').InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}

