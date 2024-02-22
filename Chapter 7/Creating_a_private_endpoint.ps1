# Variables
$storageAccountName = "az104storageaccountdemo1"
$privateEndpointName = "az104privateendpoint"
$region = "westeurope"
$resourceGroup = "AZ104-StorageAccounts"
# Main Program
$storageAccount = Get-AzStorageAccount -ResourceGroupName "$resourceGroup" -Name "$storageAccountName"
$privateEndpointConnection = New-AzPrivateLinkServiceConnection -Name 'myPrivateConnection' -PrivateLinkServiceId ($storageAccount.Id) -GroupId 'file';
$vnet = Get-AzVirtualNetwork -ResourceGroupName "$resourceGroup" -Name "StorageVNET"
## Disable private endpoint network policy ##
$vnet.Subnets[0].PrivateEndpointNetworkPolicies="Disabled"
$vnet | Set-AzVirtualNetwork
## Create private endpoint
New-AzPrivateEndpoint -ResourceGroupName "$resourceGroup" -Name "$privateEndpointName" -Location "$region" -Subnet ($vnet.Subnets[0]) -PrivateLinkServiceConnection $privateEndpointConnection
