# Parameters
$ResourceGroup = "AZ104-BCDR"
$ResourceGroup2 = "AZ104-BCDR-Recovery"
$Location = "EastUs"
$Location2 = "WestUs2"
$SubscriptionId = "xxxxxxx"
$VirtualNetworkName = "BCDRVnet"
$SubnetName = "BCDRSubnet"
$NSGName = "BCDRSecurityGroup"

# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
Select-AzSubscription -SubscriptionId $SubscriptionId

# Create a resource group
New-AzResourceGroup -Name "$ResourceGroup2" -Location "$Location2"

# Setup Your VM Admin Credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

# Deploy the VMs
New-AzVm `
    -ResourceGroupName "$ResourceGroup" `
    -Name "BCDRVM1" `
    -Location "$Location" `
    -VirtualNetworkName "$VirtualNetworkName" `
    -SubnetName "$SubnetName" `
    -SecurityGroupName "$NSGName" `
    -PublicIpAddressName "BCDRVM1" `
    -Size "Standard_D2s_v5" `
    -OpenPorts 3389 `
    -Image "Win2019Datacenter" `
    -Credential $adminCreds

    New-AzVm `
    -ResourceGroupName "$ResourceGroup2" `
    -Name "BCDRVM2" `
    -Location "$Location2" `
    -VirtualNetworkName "$($VirtualNetworkName)2" `
    -SubnetName "$SubnetName" `
    -SecurityGroupName "$NSGName" `
    -PublicIpAddressName "BCDRVM2" `
    -Size "Standard_D2s_v5" `
    -OpenPorts 3389 `
    -Image "Win2019Datacenter" `
    -Credential $adminCreds

# Create a Storage Account
$date = Get-Date -Format "ddMMyyyyhhmm"
New-AzStorageAccount -Name "bcdr$date" -Location $Location -ResourceGroupName $ResourceGroup -SkuName Standard_GRS