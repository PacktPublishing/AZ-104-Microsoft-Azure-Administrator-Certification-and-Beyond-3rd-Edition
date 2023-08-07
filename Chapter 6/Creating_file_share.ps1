# First connect your Azure account credentials
Connect-AzAccount

# Parameters
$ResourceGroup = "AZ104-Chapter6"
$StorageAccountName = "az104chap6acc220072021"
$ShareName= "testfileshare"
$Context = (Get-AzStorageAccount -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName).Context;

# Create a file share
New-AzStorageShare -Name $ShareName -Context $Context