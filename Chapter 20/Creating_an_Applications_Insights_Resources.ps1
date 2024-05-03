# Parameters
$ResourceGroup = "AZ104-Monitor"
$Location = "WestEurope"
$AppServicePlanName = "mylinuxappserviceplan10101"
$gitrepo="https://github.com/ColorlibHQ/AdminLTE.git"
$webappname="mywebapp$(Get-Random)"

# Create an App Service Plan for Linux
New-AzAppServicePlan -Name $AppServicePlanName -Tier Free -Location $Location -Linux -ResourceGroupName $ResourceGroup

# Create a Web App
New-AzWebApp -Name $WebAppName -ResourceGroupName $ResourceGroup -Location $Location -AppServicePlan $AppServicePlanName
Publish-AzWebApp -Name $WebAppName -ResourceGroupName $ResourceGroup -ArchivePath ""

# Modify the Web App to Dotnet
Set-AzWebApp -Name $WebAppName -ResourceGroupName $ResourceGroup -AppServicePlan $AppServicePlanName -NetFrameworkVersion 6

# Configure GitHub deployment from your GitHub repo and deploy once.
$PropertiesObject = @{
    repoUrl = "$gitrepo";
    branch = "master";
    isManualIntegration = "true";
}
Set-AzResource -Properties $PropertiesObject -ResourceGroupName $ResourceGroup -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $WebAppName/web -ApiVersion 2015-08-01 -Force
