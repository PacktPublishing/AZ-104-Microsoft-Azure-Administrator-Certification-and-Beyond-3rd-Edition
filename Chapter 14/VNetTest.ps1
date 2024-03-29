# Parameters
$ResourceGroup = "AZ104-vnets"
$Location = "WestEurope"
$VnetName = "DemoVNet"
$AddressPrefix = "10.0.0.0/16"
$SubnetName = "Demo_Subnet"
 
# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId

# Setup Your VM Admin Credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminPassword = ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)
$adminCreds = New-Object PSCredential $adminUsername, $adminPassword

# Create a VM in DemoVNet
New-AzVM -VirtualNetworkName $VnetName -SubnetName $SubnetName `
-ResourceGroupName $ResourceGroup -Location $Location -Name 'DemoVM1' `
-Credential $adminCreds -PublicIpAddressName 'DemoVM1PublicIP'

# Create a VM in DemoVNet_2
New-AzVM -VirtualNetworkName 'DemoVNet_2' -SubnetName $SubnetName `
-ResourceGroupName $ResourceGroup -Location $Location -Name 'DemoVM2' `
-Credential $adminCreds -PublicIpAddressName 'DemoVM2PublicIP'
