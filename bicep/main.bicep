param environmentName string = 'env-${resourceGroup().name}'
param storageAccountName string = toLower(replace(resourceGroup().name,'-','') ) 
param location string = resourceGroup().location
param containerAppName string = 'queue-reader-function'
param containerImageTag string = 'v1.5'
param containerImage string = 'kerokero1984/containerapps-sample:${containerImageTag}'

param revisionSuffix string = ''
@allowed([
  'multiple'
  'single'
])
param revisionMode string = 'single'


module environment 'environment.bicep' = {
  name: 'container-app-environment'
  params: {
    environmentName: environmentName
    location: location
  }
}

module storage 'storage.bicep' = {
  name: 'storage'
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}

module containerapp 'containerapp.bicep' = {
  name: 'container-app'
  params: {
    environmentId: environment.outputs.environmentId
    containerAppName: containerAppName
    containerImage: containerImage
    revisionSuffix: revisionSuffix
    revisionMode: revisionMode
    storageConnectionString: storage.outputs.storageConnectionString
    location: location
  }
}

