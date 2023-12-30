metadata description = 'Creates storage account'

@description('Enter a unique storage account name between 5 and 15 characters in length.')
@minLength(5)
@maxLength(15)
param storageAccountName string

@description('Select the storage account type.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param storageSKU string = 'Standard_LRS'

param location string = resourceGroup().location

resource storageaccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageSKU
  }
}

output name string = storageAccountName
output sku string = storageSKU
