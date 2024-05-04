# Parameters
$ResourceGroup = "AZ104-BCDR"
$Location = "EastUS"
$VaultName = "Az104RecoveryServicesVault"

# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
Select-AzSubscription -SubscriptionId $SubscriptionId

# Create a resource group for the Availability Set as follows
New-AzResourceGroup -Name "$ResourceGroup" -Location "$Location"

# Create a Recovery Services Vault
New-AzRecoveryServicesVault -Name $VaultName -ResourceGroupName $ResourceGroup -Location EastUS

# Set the Redundancy LEvel to Georedundant Storage
$vault1 = Get-AzRecoveryServicesVault -Name $VaultName
Set-AzRecoveryServicesBackupProperty -Vault $vault1 -BackupStorageRedundancy GeoRedundant
