# Parameters
$ResourceGroup = "AZ104-Monitor"
$Location = "WestEurope"
$StorageAccountName = "monitorserverdiagnostics"

New-AzStorageAccount -ResourceGroupName $ResourceGroup -Location $Location -Name $StorageAccountName -SkuName Standard_LRS