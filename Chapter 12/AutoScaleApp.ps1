# Parameters
$ResourceGroup = "AZ104-AppServices"
$Location = "WestEurope"
$WebAppName = "mysecondwebapp10101"
$AppServicePlanName = "mylinuxappserviceplan10101"

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId

# Create an App Service Plan for Linux
$AppServicePlan = Get-AzAppServicePlan -Name $AppServicePlanName -ResourceGroupName $ResourceGroup

# Create an Autoscale Rule
$AutoScaleRule = New-AzAutoscaleRule -MetricName "CpuPercentage" -Operator "GreaterThan" -MetricStatistic "Average" `
                -Threshold 70 -TimeAggregationOperator "Average" -TimeGrain "00:01:00" -TimeWindow "00:10:00" `
                -MetricResourceId $AppServicePlan.Id -ScaleActionCooldown 00:10:00 -ScaleActionDirection Increase `
                -ScaleActionScaleType ChangeCount -ScaleActionValue 1

# Create an Autoscale Profile
$AutoScaleProfile = New-AzAutoscaleProfile -Name "Default" -DefaultCapacity 1 -MaximumCapacity 2 -MinimumCapacity 1 -Rule $AutoScaleRule

# Assign the Autoscale Profile to the App
Add-AzAutoscaleSetting -Location $Location -Name "Auto Scale Setting" -ResourceGroupName $ResourceGroup -TargetResourceId $AppservicePlan.Id -AutoscaleProfile $AutoScaleProfile
