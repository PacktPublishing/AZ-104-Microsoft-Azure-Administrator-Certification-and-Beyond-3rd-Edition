# First connect your Azure account credentials
Connect-AzAccount

# Parameters
$ResourceGroup = "AZ104-StorageAccounts"
$StorageAccountName = "az104storageaccountdemo1"
$ContainerName = "testps"
$Context = (Get-AzStorageAccount -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName).Context;

# Create a blob container
New-AzStorageContainer -Name $ContainerName -Context $Context