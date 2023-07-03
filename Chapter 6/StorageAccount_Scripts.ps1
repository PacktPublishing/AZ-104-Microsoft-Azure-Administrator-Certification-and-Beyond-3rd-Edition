# First connect your Azure account credentials to perform 
Connect-AzAccount

# Parameters
$ResourceGroup = "AZ104-Storage"
$Location = "WestEurope"
$StorageAccountName = "az104storacc01072023"
$SkuName = "Standard_LRS"

# Create the Storage Account
New-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroup -Location $Location -SkuName $SkuName