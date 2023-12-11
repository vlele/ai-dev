bicep
param appName string = 'my-web-app' // Replace with your app name
param location string = resourceGroup().location

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${appName}-asp'
  location: location
  sku: {
    name: 'F1' // Free tier
  }
  kind: 'linux'
  properties: {
    reserved: true // This is required for Linux
  }
}

// App Service (Web App)
resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|7.0' // Specify the runtime stack
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
    }
    httpsOnly: true
  }
}

output appServiceUrl string = 'https://${appService.defaultHostName}'