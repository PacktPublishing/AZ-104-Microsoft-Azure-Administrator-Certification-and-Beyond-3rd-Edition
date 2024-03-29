# First connect your Azure account using your credentials
Connect-AzAccount

# Setup the VNET object
$vnet = @{
    Name = 'DemoVNet_2'
    ResourceGroupName = 'AZ104-vnets'
    Location = 'WestEurope'
    AddressPrefix = '192.168.0.0/24'   
}
$virtualNetwork = New-AzVirtualNetwork @vnet

# Create a Subnet
$subnet = @{
    Name = 'Demo_Subnet'
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '192.168.0.0/24'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet

# Apply VNet Configurations
Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork