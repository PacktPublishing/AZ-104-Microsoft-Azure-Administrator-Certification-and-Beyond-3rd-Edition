# First connect your Azure account using your credentials
Connect-AzAccount

# Create a Private DNS Zone
New-AzPrivateDnsZone -Name demo.com -ResourceGroupName 'AZ104-vnets'

# Link the Private DNS Zone to the DemoVNet
$VNet = Get-AzVirtualNetwork -ResourceGroupName 'AZ104-vnets' `
-Name 'DemoVNet'
New-AzPrivateDnsVirtualNetworkLink -ZoneName demo.com `
-ResourceGroupName 'AZ104-vnets' -Name "DemoVNet" `
-VirtualNetwork $VNet -EnableRegistration

# Link the Private DNS Zone to DemoVNet_2
$VNet = Get-AzVirtualNetwork -ResourceGroupName 'AZ104-vnets' `
-Name 'DemoVNet_2'
New-AzPrivateDnsVirtualNetworkLink -ZoneName demo.com `
-ResourceGroupName 'AZ104-vnets' -Name "DemoVNet_2" `
-VirtualNetwork $VNet -EnableRegistration