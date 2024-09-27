 # First connect your Azure account using your credentials
 Connect-AzAccount

 # Parameters
 $ResourceGroup = "AZ104-AppServices"
 $Location = "WestEurope"
 $WebAppName = "mysecondwebapp10101"
 $AppServicePlanName = "mylinuxappserviceplan10101"
 
 # If necessary, select the right subscription as follows
 $SubscriptionId = "xxxxxxx"
 Select-AzSubscription -SubscriptionId $SubscriptionId
 
 # Create a resource group for the Availability Set as follows
 New-AzResourceGroup -Name "$ResourceGroup" -Location "$Location"
 
 # Create an App Service Plan for Linux
 New-AzAppServicePlan -Name $AppServicePlanName -Tier Standard -Location $Location -Linux -NumberofWorkers 1 -WorkerSize Small -ResourceGroupName $ResourceGroup
 
 # Create a Web App
 New-AzWebApp -Name $WebAppName -ResourceGroupName $ResourceGroup -Location $Location -AppServicePlan $AppServicePlanName
 