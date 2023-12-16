Import-Module -name AZFilesHybrid;
Connect-AzAccount;
Join-AzStorageAccountForAuth -ResourceGroupName "AZ104-StorageAccounts" -StorageAccountName "somefileshare16122023" -Domain "storagedemo.com" -OrganizationalUnitName "OU=AzureShares,OU=Az104_Resources,DC=domainname,DC=com"
