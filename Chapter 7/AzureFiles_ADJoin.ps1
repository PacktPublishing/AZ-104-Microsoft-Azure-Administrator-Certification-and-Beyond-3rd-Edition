# Requirements
# Download AZFilesHybridModule from https://github.com/Azure-Samples/azure-files-samples/releases
Import-Module -name AZFilesHybrid;

Join-AzStorageAccountForAuth -ResourceGroupName "AZ104-Chapter7" -StorageAccountName "az104chap7acc220072021" -Domain "domain.com" -OrganizationalUnitName "OU=AzureShares,OU=Az104_Resources,DC=az104training,DC=com"

$connectTestResult = Test-NetConnection -ComputerName <storage-account-name>.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded)
{
  net use <desired-drive-letter>: \\<storage-account-name>.file.core.windows.net\<share-name> /user:Azure\<storage-account-name> <storage-account-key>
} 
else 
{
  Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN,   Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}