# First connect your Azure account credentials to perform 
Connect-AzAccount

# Parameters
$ResourceGroup = "AZ104-StorageAccounts"
$Location = "WestEurope"
$StorageAccountName = "az104storageaccountdemo1"
$SkuName = "Standard_LRS"

# Create the Storage Account
New-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroup `
-Location $Location -SkuName $SkuName -AllowBlobPublicAccess $False