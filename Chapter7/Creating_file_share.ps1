# First connect your Azure account credentials
Connect-AzAccount

# Parameters
$ResourceGroup = "AZ104-StorageAccounts"
$StorageAccountName = "az104storageaccountdemo1"
$ShareName= "testfileshare"
$Context = (Get-AzStorageAccount -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName).Context;

# Create a file share
New-AzStorageShare -Name $ShareName -Context $Context