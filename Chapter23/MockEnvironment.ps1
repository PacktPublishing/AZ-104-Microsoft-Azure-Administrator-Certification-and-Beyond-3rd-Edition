# Global Paramaters
$SubscriptionId = "xxxxxxx"

# Parameters - West Europe (Site1)
$Site1ResourceGroup = "AZ104-NetworkWatcherWE"
$Site1Location = "WestEurope"
$Site1AvailabilitySetName = "VMAvailabilitySet"
$Site1VirtualNetworkName = "WEVMVnet"
$Site1AddressPrefix = "40.0.0.0/16"
$Site1SubnetName = "WEVMSubnet"

# Parameters - South Africa (Site2)
$Site2ResourceGroup = "AZ104-NetworkWatcherSA"
$Site2Location = "SouthAfricaNorth"
$Site2AvailabilitySetName = "VMAvailabilitySet"
$Site2VirtualNetworkName = "SAVnet"
$Site2AddressPrefix = "10.0.0.0/16"
$Site2SubnetName = "SAVMSubnet"

# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
Select-AzSubscription -SubscriptionId $SubscriptionId

# Create the Resource Groups for each Region
New-AzResourceGroup -Name "$Site1ResourceGroup" -Location "$Site1Location"
New-AzResourceGroup -Name "$Site2ResourceGroup" -Location "$Site2Location"

# Setup the VNETs for Site 1
$Site1virtualNetwork = New-AzVirtualNetwork -Name $Site1VirtualNetworkName -ResourceGroupName $Site1ResourceGroup -Location $Site1Location -AddressPrefix $Site1AddressPrefix
$Site1SubnetConfig = Add-AzVirtualNetworkSubnetConfig -Name $Site1SubnetName -VirtualNetwork $Site1virtualNetwork -AddressPrefix $Site1AddressPrefix
Set-AzVirtualNetwork -VirtualNetwork $Site1virtualNetwork

# Setup the VNETs for Site 2
$Site2virtualNetwork = New-AzVirtualNetwork -Name $Site2VirtualNetworkName -ResourceGroupName $Site2ResourceGroup -Location $Site2Location -AddressPrefix $Site2AddressPrefix
$Site2SubnetConfig = Add-AzVirtualNetworkSubnetConfig -Name $Site2SubnetName -VirtualNetwork $Site2virtualNetwork -AddressPrefix $Site2AddressPrefix
Set-AzVirtualNetwork -VirtualNetwork $Site2virtualNetwork

# Create VNet PEering
# Peer VNet1 to VNet2.
Add-AzVirtualNetworkPeering -Name 'Site1toSite2' -VirtualNetwork $Site1virtualNetwork -RemoteVirtualNetworkId $Site2virtualNetwork.Id

# Peer VNet2 to VNet1.
Add-AzVirtualNetworkPeering -Name 'Site2toSite1' -VirtualNetwork $Site2virtualNetwork -RemoteVirtualNetworkId $Site1virtualNetwork.Id

# Setup Your VM Admin Credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

# Deploy 1 VM in each region
New-AzVM -ResourceGroupName $Site1ResourceGroup -Name "Site1VM" -Location $Site1Location -VirtualNetworkName $Site1VirtualNetworkName -SubnetName $Site1SubnetName -Credential $adminCreds
New-AzVM -ResourceGroupName $Site2ResourceGroup -Name "Site2VM" -Location $Site2Location -VirtualNetworkName $Site2VirtualNetworkName -SubnetName $Site2SubnetName -Credential $adminCreds

