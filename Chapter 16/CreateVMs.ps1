# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId

# Parameters
$ResourceGroup = "AZ104-InternalLoadBalancer"
$Location = "WestEurope"
$AvailabilitySetName = "LBAvailabilitySet"
$VirtualNetworkName = "LoadBalancerVNet"
$SubnetName = "BackendSubnet"

# Create an Availability Set for the VMs
New-AzAvailabilitySet -Location "$Location" -Name "$AvailabilitySetName" -ResourceGroupName "$ResourceGroup" -Sku Aligned -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 2

# Setup Your VM Admin Credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

# Deploy 2 VMs Inside the Availability Set and a Test VM
for ($vmNum=1; $vmNum -le 3; $vmNum++){
    if ($vmNum -eq 3){$vmName = "TestVM"} # Test VM
    else{$vmName = "BackendVM$vmNum"}
    New-AzVm -ResourceGroupName "$ResourceGroup" -Name "$vmName" -Location "$Location" -VirtualNetworkName "$VirtualNetworkName" -SubnetName "$SubnetName" -SecurityGroupName "PacktNetworkSecurityGroup" -PublicIpAddressName "$($vmName)PublicIpAddress" -AvailabilitySetName "$AvailabilitySetName" -Credential $adminCreds -OpenPorts 3389 -Size "Standard_DS1_v2" -PublicIpSku Standard
}
