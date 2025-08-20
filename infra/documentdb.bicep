@description('Name of the DocumentDB server')
param name string

@description('Location for the DocumentDB server')
param location string

@description('Tags for the DocumentDB server')
param tags object

@description('Authentication type for the DocumentDB server')
@allowed([
  'EntraOnly'
  'Password'
  'EntraAndPassword'
])
param authType string = 'EntraOnly'

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

@description('Database names to create')
param databaseNames array

@description('Storage configuration')
param storage object

@description('DocumentDB version')
param version string = 'latest'

@description('Allow all IPs in firewall')
param allowAllIPsFirewall bool = false

resource documentdbServer 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: name
  location: location
  tags: tags
  kind: 'MongoDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    capabilities: [
      {
        name: 'EnableMongo'
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxStalenessPrefix: 100000
      maxIntervalInSeconds: 300
    }
    ipRules: allowAllIPsFirewall ? [
      {
        ipAddressOrRange: '0.0.0.0/0'
      }
    ] : []
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    enableCassandraConnector: false
    disableKeyBasedMetadataWriteAccess: false
    keyVaultKeyUri: ''
    defaultIdentity: authType == 'EntraOnly' ? 'FirstPartyIdentity' : ''
    networkAclBypass: 'None'
    networkAclBypassResourceIds: []
    publicNetworkAccess: 'Enabled'
    enableFreeTier: false
    apiProperties: {
      serverVersion: '4.0'
    }
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    createMode: 'Default'
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Geo'
      }
    }
    cors: []
    capacity: {
      totalThroughputLimit: -1
    }
    virtualNetworkRules: []
    enableMaterializedViews: false
    keysMetadata: {
      primaryMasterKey: {
        generationTime: '2024-01-01T00:00:00Z'
      }
      primaryReadonlyMasterKey: {
        generationTime: '2024-01-01T00:00:00Z'
      }
      secondaryMasterKey: {
        generationTime: '2024-01-01T00:00:00Z'
      }
      secondaryReadonlyMasterKey: {
        generationTime: '2024-01-01T00:00:00Z'
      }
    }
  }
}

resource databases 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2023-04-15' = [for databaseName in databaseNames: {
  name: '${documentdbServer.name}/${databaseName}'
  location: location
  tags: tags
  properties: {
    resource: {
      id: databaseName
    }
    options: {
      throughput: 400
      autoscaleSettings: {
        maxThroughput: 4000
      }
    }
  }
}]

output DOCUMENTDB_DOMAIN_NAME string = documentdbServer.properties.documentEndpoint
output DOCUMENTDB_ACCOUNT_NAME string = documentdbServer.name
