# Parameters
$ResourceGroup = "AZ104-vnets"
$Location = "WestEurope"
$WebAppName = "myPrivateWebApp300324"
$AppServicePlanName = "mylinuxappserviceplan10101"

# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId
 
# Create an App Service Plan for Linux
New-AzAppServicePlan -Name $AppServicePlanName -Tier Standard `
-Location $Location -Linux -NumberofWorkers 1 -WorkerSize Small `
-ResourceGroupName $ResourceGroup

# Create a Web App
New-AzWebApp -Name $WebAppName -ResourceGroupName $ResourceGroup `
-Location $Location -AppServicePlan $AppServicePlanName
