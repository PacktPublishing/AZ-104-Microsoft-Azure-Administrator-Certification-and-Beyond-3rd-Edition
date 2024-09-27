$role = Get-AZRoleDefinition "Virtual Machine Contributor"
$role.Id = $null
$role.Name = "VM Custom"
$role.Description = "Can monitor and restart virtual machines."
$role.Actions.Clear()
$role.Actions.Add("Microsoft.Storage/*/read")
$role.Actions.Add("Microsoft.Network/*/read")
$role.Actions.Add("Microsoft.Compute/*/read")
$role.Actions.Add("Microsoft.Compute/virtualMachines/start/action" )
$role.Actions.Add("Microsoft.Compute/virtualMachines/restart/action" )
$role.Actions.Add("Microsoft.Authorization/*/read")
$role.Actions.Add("Microsoft.ResourceHealth/availabilityStatuses/read" )
$role.Actions.Add("Microsoft.Resources/subscriptions/resourceGroups/read")
$role.Actions.Add("Microsoft.Insights/alertRules/*")
$role.Actions.Add("Microsoft.support/*")
$role.Assignablescopes.Clear()
$role.Assignablescopes.Add("subscription/production/resourcegroups/EU")
New-AZRoleDefinition -Role $role