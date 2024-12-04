resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  kind: 'StorageV2'
  location: resourceGroup().location
  name: 'st${uniqueString(resourceGroup().id)}'
  sku: {
    name:'Standard_ZRS'
  }
  properties:{ 
    allowBlobPublicAccess: false
  }
}

resource blobAccount 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  name: 'default'
  parent: storageAccount
}

resource queueAccount 'Microsoft.Storage/storageAccounts/queueServices@2023-05-01' = {
  name: 'default'
  parent: storageAccount
}


resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = { 
  name: 'documents'
  parent: blobAccount
}

resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2023-05-01' = {
  name: 'queuedecouvert'
  parent: queueAccount
}
