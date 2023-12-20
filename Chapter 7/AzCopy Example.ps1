# Change all Variables Below
$SourceFilePath = "C:\AzCopy\MyFile.txt"
$StorageAccountName = "az104storageaccountdemo1"
$ContainerName = "azcopydestination"
$SASToken = "?sv=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx%3D"
# Run AzCopy Command
./azcopy.exe copy "$SourceFilePath" "https://$StorageAccountName.blob.core.windows.net/$($ContainerName)$SASToken"
