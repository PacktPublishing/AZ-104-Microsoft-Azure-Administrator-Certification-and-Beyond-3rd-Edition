#^ ///////////////////////////////////////////////////////////////////////////////
#^ Modules
#^ ///////////////////////////////////////////////////////////////////////////////

# confirm the required modules are installed
try{Import-Module Az;} 
catch{Write-Host "Installing AZ Module..." -NoNewline; Install-Module AZ -Force -AllowClobber; Write-Host "done" -ForegroundColor Green;}
try{Import-Module Az.Functions;} 
catch{Write-Host "Installing AZ.Functions Module..." -NoNewline; Install-Module AZ.Functions -Force -AllowClobber; Write-Host "done" -ForegroundColor Green;}

#? ////////////////////////////////////////////////////////
#? Variables that apply to the whole script
#? ////////////////////////////////////////////////////////

$Location = "Westeurope";

#? ////////////////////////////////////////////////////////
#? Authenticate to Azure
#? ////////////////////////////////////////////////////////

# First connect your Azure account using your credentials
Connect-AzAccount
$SubscriptionId = "xxxxxxx";
Select-AzSubscription -SubscriptionId $SubscriptionId

#? ////////////////////////////////////////////////////////
#? TASK 1 - Provision the resource groups for the lab
#? ////////////////////////////////////////////////////////

# Resource Group 1
$resourceGroup1 = "Az104-storagelab-rg0";
New-AzResourceGroup -Name $resourceGroup1 -Location $Location;
# Resource Group 2
$resourceGroup2 = "Az104-storagelab-rg1";
New-AzResourceGroup -Name $resourceGroup2 -Location $Location;

#? ////////////////////////////////////////////////////////
#? TASK 2 - Create and configure the lab storage accounts
#? ////////////////////////////////////////////////////////

# Common Parameters / Variables
$date = Get-date -Format "yyMMddhhmm";
$SkuName = "Standard_LRS";

# Storage Account 1
$storageAccountName1 = "$($resourceGroup1.ToLower() -replace("-"))$date";
New-AzStorageAccount -Name $storageAccountName1 -ResourceGroupName $resourceGroup1 -Location $Location -SkuName $SkuName;

#? ////////////////////////////////////////////////////////
#? TASK 3 - Create and configure the Azure Files shares
#? ////////////////////////////////////////////////////////

# Common Parameters / Variables
$ShareName= "az104-storagelab-share";

# Storage Account 1
$Context1 = (Get-AzStorageAccount -ResourceGroupName $ResourceGroup1 -AccountName $StorageAccountName1).Context;
New-AzStorageShare -Name $ShareName -Context $Context1

#? ////////////////////////////////////////////////////////
#? TASK 4 - Provision a vNET
#? ////////////////////////////////////////////////////////

## Create backend subnet config. ##
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name myBackendSubnet -AddressPrefix 10.0.0.0/24

## Create the virtual network. ##
$parameters1 = @{
    Name = 'MyVNet'
    ResourceGroupName = "$ResourceGroup1"
    Location = "$Location"
    AddressPrefix = '10.0.0.0/16'
    Subnet = $subnetConfig
}
$vnet = New-AzVirtualNetwork @parameters1

#? ////////////////////////////////////////////////////////
#? TASK 5 - Provision a VM
#? ////////////////////////////////////////////////////////

## Set credentials for server admin and password. ##
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

$OperatingSystemParameters = @{
    PublisherName = 'MicrosoftWindowsServer'
    Offer = 'WindowsServer'
    Skus = '2019-Datacenter'
    Version = 'latest'
}

$vmName = "myVM"
$vmSize = "Standard_DS1_v2"
$NSGName = "$vmName-nsg"
$subnetid = (Get-AzVirtualNetworkSubnetConfig -Name 'myBackendSubnet' -VirtualNetwork $vnet).Id
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName "$ResourceGroup1" -Location "$Location" -Name "$NSGName"
$nsgParams = @{
    'Name'                     = 'allowRDP'
    'NetworkSecurityGroup'     = $NSG
    'Protocol'                 = 'TCP'
    'Direction'                = 'Inbound'
    'Priority'                 = 200
    'SourceAddressPrefix'      = '*'
    'SourcePortRange'          = '*'
    'DestinationAddressPrefix' = '*'
    'DestinationPortRange'     = 3389
    'Access'                   = 'Allow'
}
Add-AzNetworkSecurityRuleConfig @nsgParams | Set-AzNetworkSecurityGroup
$pip = New-AzPublicIpAddress -Name "$vmName-ip" -ResourceGroupName "$ResourceGroup1" -Location "$Location" -AllocationMethod Dynamic
$nic = New-AzNetworkInterface -Name "$($vmName)$(Get-Random)" -ResourceGroupName "$ResourceGroup1" -Location "$Location" -SubnetId $subnetid -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $adminCreds
Set-AzVMSourceImage -VM $vmConfig @OperatingSystemParameters
Set-AzVMOSDisk -VM $vmConfig -Name "$($vmName)_OsDisk_1_$(Get-Random)" -CreateOption fromImage
Set-AzVMBootDiagnostic -VM $vmConfig -Disable

## Create the virtual machine ##
New-AzVM -ResourceGroupName "$ResourceGroup1" -Location "$Location" -VM $vmConfig

#? ////////////////////////////////////////////////////////
#? TASK 6 - Deploy a private endpoint to the storage account
#? ////////////////////////////////////////////////////////

$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroup1 -Name $storageAccountName1

$privateEndpointConnection = New-AzPrivateLinkServiceConnection -Name 'myConnection' -PrivateLinkServiceId ($storageAccount.Id) -GroupId 'file';
## Disable private endpoint network policy ##
$vnet.Subnets[0].PrivateEndpointNetworkPolicies="Disabled"
$vnet | Set-AzVirtualNetwork
## Create private endpoint
New-AzPrivateEndpoint -ResourceGroupName "$resourceGroup1" -Name "myPrivateEndpoint" -Location "$Location" -Subnet ($vnet.Subnets[0]) -PrivateLinkServiceConnection $privateEndpointConnection

#? ////////////////////////////////////////////////////////
#? TASK 7 - Test connectivity from the server to the file share over the local IP
#? ////////////////////////////////////////////////////////