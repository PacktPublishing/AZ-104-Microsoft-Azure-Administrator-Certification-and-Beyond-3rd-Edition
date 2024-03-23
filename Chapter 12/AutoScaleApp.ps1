# Parameters
$ResourceGroup = "AZ104-AppServices"
$Location = "WestEurope"
$WebAppName = "mysecondwebapp10101"
$AppServicePlanName = "mylinuxappserviceplan10101"

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId

# Retrieve the App Service Plan for Linux
$AppServicePlan = Get-AzAppServicePlan -Name $AppServicePlanName `
-ResourceGroupName $ResourceGroup

# Create an Autoscale Rule
$AutoScaleRule = New-AzAutoscaleScaleRuleObject -MetricTriggerMetricName "CpuPercentage" `
                -MetricTriggerOperator "GreaterThan" -MetricTriggerStatistic "Average" `
                -MetricTriggerThreshold 70 -MetricTriggerTimeAggregation "Average" `
                -MetricTriggerTimeGrain "00:01:00" -MetricTriggerTimeWindow "00:10:00" `
                -MetricTriggerMetricResourceUri $AppServicePlan.Id `
                -ScaleActionCooldown 00:10:00 `
                -ScaleActionDirection Increase `
                -ScaleActionType ChangeCount `
                -ScaleActionValue 1

# Create an Autoscale Profile
$AutoScaleProfile = New-AzAutoscaleProfileObject -Name "Default" `
-CapacityDefault 1 -CapacityMaximum 2 -CapacityMinimum 1 `
-Rule $AutoScaleRule

# Assign the Autoscale Profile to the App
New-AzAutoscaleSetting -Location $Location -Name "default" `
-ResourceGroupName $ResourceGroup -TargetResourceUri $AppservicePlan.Id `
-Profile $AutoScaleProfile -PropertiesName "default" -Enabled
