# Update the variables below according to your deployment
$storageAccountName = "az104storageaccountdemo1"
$privateEndpointName = "az104privateendpoint"
$resourceGroup = "AZ104-StorageAccounts"
$region = "westeurope"
$vNetName = "StorageVNET"

# Create the Storage Account
$storageAccount = Get-AzStorageAccount -ResourceGroupName "$resourceGroup" -Name "$storageAccountName"

## Disable private endpoint network policy ##
$vnet = Get-AzVirtualNetwork -ResourceGroupName "$resourceGroup" -Name "$vNetName"
$vnet.Subnets[0].PrivateEndpointNetworkPolicies="Disabled"
$vnet | Set-AzVirtualNetwork

## Create private endpoint
$privateEndpointConnection = New-AzPrivateLinkServiceConnection -Name 'myPrivateConnection' -PrivateLinkServiceId ($storageAccount.Id) -GroupId 'file';
New-AzPrivateEndpoint -ResourceGroupName "$resourceGroup" -Name "$privateEndpointName" -Location "$region" -Subnet ($vnet.Subnets[0]) -PrivateLinkServiceConnection $privateEndpointConnection
