# Parameters
$ResourceGroup = "AZ104-VirtualMachines"
$Location = "WestEurope"
$SubscriptionId = "xxxxxxx"
$AvailabilitySetName = "VMAvailabilitySet"
$VirtualNetworkName = "VMVnet"
$SubnetName = "VMSubnet"

# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
Select-AzSubscription -SubscriptionId $SubscriptionId

# Create a resource group for the Availability Set as follows
New-AzResourceGroup -Name "$ResourceGroup" -Location "$Location"

# Create an Availability Set for the VMs
New-AzAvailabilitySet `
-Location "$Location" `
-Name "$AvailabilitySetName" `
-ResourceGroupName "$ResourceGroup" `
-Sku aligned `
-PlatformFaultDomainCount 2 `
-PlatformUpdateDomainCount 2

# Setup Your VM Admin Credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

# Deploy 2 VMs Inside the Availability Set
for ($vmNum=1; $vmNum -le 2; $vmNum++)
{
    New-AzVm `
    -ResourceGroupName "$ResourceGroup" `
    -Name "ScaleSetVM$vmNum" `
    -Location "$Location" `
    -VirtualNetworkName "$VirtualNetworkName" `
    -SubnetName "$SubnetName" `
    -SecurityGroupName "ScaleSetNetworkSecurityGroup" `
    -PublicIpAddressName "ScaleSetPublicIpAddress$vmNum" `
    -AvailabilitySetName "$AvailabilitySetName" `
    -Credential $adminCreds
}