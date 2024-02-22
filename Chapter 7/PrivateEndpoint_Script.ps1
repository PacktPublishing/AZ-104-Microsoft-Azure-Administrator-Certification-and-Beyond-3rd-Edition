# Update the variables below according to your deployment
$storageAccountName = "az104chap7acc220072021"
$ResourceGroup = "AZ104-Chapter7"
$VNETName = "StorageVNET"
$PrivateEndpointName = "myPrivateEndpoint"
$Location = "westeurope"

$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $storageAccountName

## Create private endpoint connection. ##
$parameters1 = @{
    Name = 'myConnection'
    PrivateLinkServiceId = $storageAccount.ID
    GroupID = 'file'
    # GroupID is classified by the Subresources in this URL: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource 
}
$privateEndpointConnection = New-AzPrivateLinkServiceConnection @parameters1

## Place virtual network into variable. ##
$vnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup -Name $VNETName

## Disable private endpoint network policy ##
$vnet.Subnets[0].PrivateEndpointNetworkPolicies = "Disabled"
$vnet | Set-AzVirtualNetwork

## Create private endpoint
$parameters2 = @{
    ResourceGroupName = $ResourceGroup
    Name = $PrivateEndpointName
    Location = $Location
    Subnet = $vnet.Subnets[0]
    PrivateLinkServiceConnection = $privateEndpointConnection
}
New-AzPrivateEndpoint @parameters2