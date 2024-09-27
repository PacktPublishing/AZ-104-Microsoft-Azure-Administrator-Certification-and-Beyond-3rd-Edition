# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId

# Parameters
$ResourceGroup = "AZ104-InternalLoadBalancer"
$Location = "WestEurope"
$VirtualNetworkName = "LoadBalancerVNet"
$SubnetName = "BackendSubnet"

# Create a Virtual Network
New-AzVirtualNetwork -Name "$VirtualNetworkName" -ResourceGroupName "$ResourceGroup" `
-Location "$Location" -AddressPrefix "172.16.0.0/16" -Subnet $SubnetName `
-SubnetPrefix "172.16.0.0/24"