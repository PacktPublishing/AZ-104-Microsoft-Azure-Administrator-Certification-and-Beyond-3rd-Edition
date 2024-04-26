# Parameters
$ResourceGroup = "AZ104-NetworkWatcher"
$Location = "WestEurope"
$SubscriptionId = "xxxxxxx"
$VirtualNetworkName = "NetworkWatcherVnet"
$SubnetName = "NetworkWatcherSubnet"
$NSGName = "NetworkWatcherSecurityGroup"

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

# Deploy 2 VMs
for ($vmNum=1; $vmNum -le 2; $vmNum++)
{
    New-AzVm `
    -ResourceGroupName "$ResourceGroup" `
    -Name "NetworkWatcher$vmNum" `
    -Location "$Location" `
    -VirtualNetworkName "$VirtualNetworkName" `
    -SubnetName "$SubnetName" `
    -SecurityGroupName "$NSGName" `
    -PublicIpAddressName "NetworkWatcher$vmNum" `
    -Size "Standard_D2s_v5" `
    -OpenPorts 3389 `
    -Credential $adminCreds
}