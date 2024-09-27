# Parameters
$ResourceGroup = "AZ104-vnets"
$Location = "WestEurope"
$SQLServerName = "az104sqlserver300320241"
$DBName = "az104db"

# First connect your Azure account using your credentials
Connect-AzAccount

# Setup Your SQL Admin Credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminPassword = ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)
$adminCreds = New-Object PSCredential $adminUsername, $adminPassword

# Create the SQL Server resource
New-AzSqlServer -ServerName $SQLServerName -Location $Location `
-ResourceGroupName $ResourceGroup -SqlAdministratorCredentials $adminCreds

# Create the SQL Database resource
New-AzSqlDatabase -DatabaseName $DBName -ResourceGroupName $ResourceGroup `
-ServerName $SQLServerName