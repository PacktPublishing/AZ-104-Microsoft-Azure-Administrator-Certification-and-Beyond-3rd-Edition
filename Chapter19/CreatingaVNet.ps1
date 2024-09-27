# Parameters
$ResourceGroup = "AZ104-vnets"
$Location = "WestEurope"
$VnetName = "DemoVNet"
$AddressPrefix = "10.0.0.0/16"
 
# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId

# Create a resource group for the Availability Set as follows
New-AzResourceGroup -Name "$ResourceGroup" -Location "$Location"

# Setup the VNET object
$virtualNetwork = New-AzVirtualNetwork -Name $VnetName `
-ResourceGroupName $ResourceGroup `
-Location $Location -AddressPrefix $AddressPrefix

# Create a Subnet
$subnet = @{
    Name = 'Demo_Subnet'
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '10.0.0.0/24'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet
Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork