# Change all Variables Below
$StorageAccountName = "az104storageaccountdemo1"
$SrcContainerName = "azcopysource"
$DestContainerName = "azcopydestination"
$SourceSASToken = "sp=rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx%3D"
$DestSASToken = "sp=rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx%3D"
# Run AzCopy Command
./azcopy.exe copy "https://$StorageAccountName.blob.core.windows.net/$($SrcContainerName)?$SourceSASToken" "https://$StorageAccountName.blob.core.windows.net/$($DestContainerName)?$DestSASToken" --overwrite=ifsourcenewer --recursive
