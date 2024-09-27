# Import the required modules for working with Azure Files
Import-Module -name AZFilesHybrid;

# Variables
$ResourceGroupName = "AZ104-StorageAccounts"
$StorageAccountName = "somefileshare16122023"
$Domain = "storagedemo.com"

# Connect your Azure account to the script (# out the 1 you dont need)
Connect-AzAccount;
#Connect-AzAccount -tenantId "[tenantID]" # Use this if you are connected to multiple Azure / Microsoft Entra ID tenants

# Select your desired subscription if required
# Select-AzSubscription -subscriptionId "[subscriptionId]"

# Join your storage account to your AD for authentication
Join-AzStorageAccountForAuth -ResourceGroupName "$ResourceGroupName" -StorageAccountName "$StorageAccountName" -Domain "$Domain"

# Test your File Share connections
Debug-AzStorageAccountAuth -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName -Verbose