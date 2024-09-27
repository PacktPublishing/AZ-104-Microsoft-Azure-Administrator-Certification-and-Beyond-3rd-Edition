# Parameters
$ResourceGroup = "AZ104-Monitor"
$Location = "WestEurope"
$AppServicePlanName = "mylinuxappserviceplan10101"
$webappname="mywebapp$(Get-Random)"

# Create an App Service Plan for Linux
New-AzAppServicePlan -Name $AppServicePlanName -Tier Free -Location $Location -Linux -ResourceGroupName $ResourceGroup

# Create a Web App
New-AzWebApp -Name $WebAppName -ResourceGroupName $ResourceGroup -Location $Location -AppServicePlan $AppServicePlanName

# Publish the Web Files to the Website
Publish-AzWebApp -Name $WebAppName -ResourceGroupName $ResourceGroup -ArchivePath "C:\webfiles\testwebsite.zip"
