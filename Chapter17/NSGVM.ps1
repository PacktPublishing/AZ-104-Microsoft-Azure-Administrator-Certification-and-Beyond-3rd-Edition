# Parameters
$ResourceGroup = "AZ104-vnetsecurity"
$Location = "WestEurope"
$VnetName = "DemoVNet"
$SubnetName = "default"

# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId

# Setup Your VM Admin Credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

# Create a VM in DemoVNet
New-AzVM -VirtualNetworkName $VnetName -SubnetName $SubnetName -ResourceGroupName $ResourceGroup -Location $Location -Name 'DemoVM1' -Credential $adminCreds -PublicIpAddressName 'DemoVM1PublicIP' -SecurityGroupName 'DemoNSG'
