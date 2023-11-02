#^ ///////////////////////////////////////////////////////////////////////////////
#^ Modules
#^ ///////////////////////////////////////////////////////////////////////////////

# confirm the required modules are installed
try{Import-Module Az;} 
catch{Write-Host "Installing AZ Module..." -NoNewline; Install-Module AZ -Force -AllowClobber; Write-Host "done" -ForegroundColor Green;}
try{Import-Module Az.Functions;} 
catch{Write-Host "Installing AZ.Functions Module..." -NoNewline; Install-Module AZ.Functions -Force -AllowClobber; Write-Host "done" -ForegroundColor Green;}

#? ///////////////////////////////////////////////////////////////////////////////
#? Variables that apply to the whole script
#? ///////////////////////////////////////////////////////////////////////////////

$Location = "Westeurope";

#? ///////////////////////////////////////////////////////////////////////////////
#? TASK 1 - Provision the resource groups for the lab
#? ///////////////////////////////////////////////////////////////////////////////

# Resource Group 1
$resourceGroup1 = "Az104-storagelab-rg0";
New-AzResourceGroup -Name $resourceGroup1 -Location $Location;
# Resource Group 2
$resourceGroup2 = "Az104-storagelab-rg1";
New-AzResourceGroup -Name $resourceGroup2 -Location $Location;

#? ///////////////////////////////////////////////////////////////////////////////
#? TASK 2 - Create and configure the lab storage accounts
#? ///////////////////////////////////////////////////////////////////////////////

# Common Paramters / Variables
$date = Get-date -Format "yyMMddhhmm";
$SkuName = "Standard_LRS";

# Storage Account 1
$storageAccountName1 = "$($resourceGroup1.ToLower() -replace("Az104") -replace("-"))$date"
New-AzStorageAccount -Name $storageAccountName1 -ResourceGroupName $resourceGroup1 -Location $Location -SkuName $SkuName;

# Storage Account 2
$storageAccountName2 = "$($resourceGroup2.ToLower() -replace("Az104") -replace("-"))$date";
New-AzStorageAccount -Name $storageAccountName2 -ResourceGroupName $resourceGroup2 -Location $Location -SkuName $SkuName;

#? ///////////////////////////////////////////////////////////////////////////////
#? TASK 3 - Create and configure the Azure Files shares
#? ///////////////////////////////////////////////////////////////////////////////

# Common Paramters / Variables
$ShareName= "az104-storagelab-share";

# Storage Account 1
$Context1 = (Get-AzStorageAccount -ResourceGroupName $ResourceGroup1 -AccountName $StorageAccountName1).Context;
New-AzStorageShare -Name $ShareName -Context $Context1

# Storage Account 2
$Context2= (Get-AzStorageAccount -ResourceGroupName $ResourceGroup2 -AccountName $StorageAccountName2).Context;
New-AzStorageShare -Name $ShareName -Context $Context2

#? ///////////////////////////////////////////////////////////////////////////////
#? TASK 4 - Create the blob containers
#? ///////////////////////////////////////////////////////////////////////////////

# Common Parameters / Variables
$ContainerName = "az104-storagelab-container"

# Storage Account 1
New-AzStorageContainer -Name $ContainerName -Context $Context1 -Permission Blob

# Storage Account 2
New-AzStorageContainer -Name $ContainerName -Context $Context2 -Permission Blob

#? ///////////////////////////////////////////////////////////////////////////////
#? TASK 5 - Create and configure an Azure function
#? ///////////////////////////////////////////////////////////////////////////////

# Define variables (same as previous steps)
$resourceGroup1 = "Az104-storagelab-rg0";
$resourceGroup2 = "Az104-storagelab-rg1";
$Location = "Westeurope";
$storageAccountName1 = "$($resourceGroup1.ToLower() -replace("Az104") -replace("-"))$date";
$storageAccountName2 = "$($resourceGroup2.ToLower() -replace("Az104") -replace("-"))$date";

# Create an app service plan, then a function app then 
$appServicePlanName = "az104-storagelab-appsp-$date";
$azureFunctionApp = "az104copyfunction-$date";

New-AzAppServicePlan -ResourceGroupName $resourceGroup1 -Name $appServicePlanName -Location $Location -Tier "Basic" -NumberofWorkers 1 -WorkerSize "Small"
New-AzFunctionApp -Name "$azureFunctionApp" -ResourceGroupName "$resourceGroup1" -PlanName $appServicePlanName -StorageAccountName $storageAccountName1 -Runtime PowerShell

#? ///////////////////////////////////////////////////////////////////////////////
#? TASK 5 - Azure Function Code
#? ///////////////////////////////////////////////////////////////////////////////

# Input bindings are passed in via param block.
param([byte[]] $InputBlob, $TriggerMetadata)

# Define variables
$SourceStorageAccount = "StorageAccountName1"
$DestinationStorageAccount = "StorageAccountName2"

$SrcStgAccURI = "https://$SourceStorageAccount.blob.core.windows.net/"
$SrcBlobContainer = "az104-storagelab-container"
$SrcSASToken = "YourSASToken"
$SrcFullPath = "$($SrcStgAccURI)$($SrcBlobContainer)/$($SrcSASToken)"

$DstStgAccURI = "https://$DestinationStorageAccount.blob.core.windows.net/"
$DstBlobContainer = "az104-storagelab-container"
$DstSASToken = "YourSASToken"
$DstFullPath = "$($DstStgAccURI)$($DstBlobContainer)/$($DstSASToken)"

# Test if AzCopy.exe exists in current folder
$WantFile = "azcopy.exe"
$AzCopyExists = Test-Path $WantFile

# Download AzCopy if it doesn't exist
If ($AzCopyExists -eq $False) {
    Write-Host "AzCopy not found. Downloading...";
    Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile AzCopy.zip -UseBasicParsing
    Expand-Archive ./AzCopy.zip ./AzCopy -Force
    # Copy AzCopy to current dir
    Get-ChildItem ./AzCopy/*/azcopy.exe | Copy-Item -Destination "./AzCopy.exe"
}
else { Write-Host "AzCopy found, skipping download." }

# Run AzCopy from source blob to destination file share
Write-Host "Backing up storage account..."
$env:AZCOPY_JOB_PLAN_LOCATION = $env:temp+'\.azcopy'
$env:AZCOPY_LOG_LOCATION=$env:temp+'\.azcopy'
./azcopy.exe copy $SrcFullPath $DstFullPath --overwrite=ifsourcenewer --recursive

#? ///////////////////////////////////////////////////////////////////////////////
#? TASK 6 - Upload some data to the source blob container
#? ///////////////////////////////////////////////////////////////////////////////



#? ///////////////////////////////////////////////////////////////////////////////
#? TASK 7 - Confirm replication has occurred
#? ///////////////////////////////////////////////////////////////////////////////
