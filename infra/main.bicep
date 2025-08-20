targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param resourceGroupName string = ''

@description('The Object ID of the Azure AD admin.')
param aadAdminObjectid string

@description('Azure AD admin name.')
param aadAdminName string

@description('Azure AD admin Type')
@allowed([
  'User'
  'Group'
  'ServicePrincipal'
])
param aadAdminType string = 'User'
param databaseName string = 'healthcare'

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

var tags = { 'azd-env-name': environmentName }
var prefix = '${environmentName}-${resourceToken}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : 'rg-${environmentName}'
  location: location
}

module documentdb 'documentdb.bicep' = {
  name: 'documentdb'
  scope: resourceGroup
  params: {
    name: '${prefix}-documentdb'
    location: location
    tags: tags
    authType: 'EntraOnly'
    aadAdminObjectid: aadAdminObjectid
    aadAdminName: aadAdminName
    aadAdminType: aadAdminType
    databaseNames: [ databaseName ]
    storage: {
      storageSizeGB: 32
    }
    version: 'latest'
    allowAllIPsFirewall: true
  }
}

output DOCUMENTDB_USERNAME string = aadAdminName
output DOCUMENTDB_DATABASE string = databaseName
output DOCUMENTDB_HOST string = documentdb.outputs.DOCUMENTDB_DOMAIN_NAME
output DOCUMENTDB_SSL string = 'require'
