# Parameters
$ResourceGroup = "AZ104-Monitor"
$Location = "WestEurope"
$SubscriptionId = "xxxxxxx"
$VMName = "MonitorServer"
$VirtualNetworkName = "MonitorVnet"
$SubnetName = "MonitorSubnet"
$NSGName = "MonitorSecurityGroup"
$AddressPrefix = "40.0.0.0/16"

# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
Select-AzSubscription -SubscriptionId $SubscriptionId

# Create a resource group for the Availability Set as follows
New-AzResourceGroup -Name "$ResourceGroup" -Location "$Location"

# Setup Your VM Admin Credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

# Setup the VNet
$VirtualNetwork = New-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroup -Location $Location -AddressPrefix $AddressPrefix
$SubnetConfig = Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VirtualNetwork -AddressPrefix $AddressPrefix
Set-AzVirtualNetwork -VirtualNetwork $VirtualNetwork

# Deploy a VM
New-AzVm `
    -ResourceGroupName "$ResourceGroup" `
    -Name "$VMName" `
    -Location "$Location" `
    -VirtualNetworkName "$VirtualNetworkName" `
    -SubnetName "$SubnetName" `
    -SecurityGroupName "$NSGName" `
    -PublicIpAddressName "$VMName-pip" `
    -Size "Standard_D2s_v5" `
    -OpenPorts 3389 `
    -Credential $adminCreds
