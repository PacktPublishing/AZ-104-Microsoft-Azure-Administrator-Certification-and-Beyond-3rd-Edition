# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
$SubscriptionId = "xxxxxxx"
Select-AzSubscription -SubscriptionId $SubscriptionId

# Parameters
$ResourceGroup = "AZ104-vnetsecurity"
$Location = "WestEurope"
$VnetName = "DemoVNet"
$SubnetName = "default"

# Get VNet Resource
$VirtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup `
-Name $VnetName

# Create 2 Subnets for this exercise in DemoVNet
Add-AzVirtualNetworkSubnetConfig -Name 'AzureBastionSubnet' `
-AddressPrefix '10.0.1.0/27' -VirtualNetwork $VirtualNetwork
Add-AzVirtualNetworkSubnetConfig -Name 'AzureFirewallSubnet' `
-AddressPrefix '10.0.1.64/26' -VirtualNetwork $VirtualNetwork
Set-AzVirtualNetwork -VirtualNetwork $VirtualNetwork

# Create a Public IP for Bastion
$PublicIp = New-AzPublicIpAddress -ResourceGroupName $ResourceGroup `
-Location $Location -Name 'Bastion-pip' -AllocationMethod static -Sku standard

# Create the Bastion Host
$VirtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup -Name $VnetName
New-AzBastion -ResourceGroupName $ResourceGroup -Name 'Bastion-01' `
-PublicIpAddress $PublicIp -VirtualNetwork $VirtualNetwork

# Create a Public IP for the Azure Firewall
$FWpip = New-AzPublicIpAddress -ResourceGroupName $ResourceGroup `
-Location $Location -Name 'Firewall-pip' -AllocationMethod static `
-Sku standard

# Create the Azure Firewall
$Firewall = New-AzFirewall -ResourceGroupName $ResourceGroup `
-Location $Location -Name 'Firewall-01' -VirtualNetwork $VirtualNetwork `
-PublicIpAddress $FWpip

# Create a Route Table
$RouteTable = New-AzRouteTable `
  -Name Firewall-RT `
  -ResourceGroupName $ResourceGroup `
  -Location $Location `
  -DisableBgpRoutePropagation

# Get the Firewall Private IP Address
$FWPrivateIP = $Firewall.IpConfigurations.privateipaddress

# Create a Route
Add-AzRouteConfig `
  -Name "DemoRoute" `
  -RouteTable $RouteTable `
  -AddressPrefix 0.0.0.0/0 `
  -NextHopType "VirtualAppliance" `
  -NextHopIpAddress $FWPrivateIP `
| Set-AzRouteTable

# Associate the Route to the Default Subnet (VMs)
Set-AzVirtualNetworkSubnetConfig `
  -VirtualNetwork $VirtualNetwork `
  -Name default `
  -AddressPrefix 10.0.0.0/24 `
  -RouteTable $RouteTable | Set-AzVirtualNetwork

# Create an Application Rule on the Firewall
$AppRule1 = New-AzFirewallApplicationRule -Name Allow-Google `
-SourceAddress 10.0.0.0/24 -Protocol http, https -TargetFqdn www.google.com
$AppRuleCollection = New-AzFirewallApplicationRuleCollection `
-Name App-Coll01 -Priority 200 -ActionType Allow -Rule $AppRule1
$Firewall.ApplicationRuleCollections.Add($AppRuleCollection)
Set-AzFirewall -AzureFirewall $Firewall

# DNS Resolution Network Rule
$DNSRule1 = New-AzFirewallNetworkRule -Name "Allow-GoogleDNS" -Protocol UDP `
-SourceAddress 10.0.0.0/24 -DestinationAddress 8.8.8.8 -DestinationPort 53
$NetRuleCollection = New-AzFirewallNetworkRuleCollection -Name GoogleDNS `
-Priority 201 -Rule $DNSRule1 -ActionType "Allow"
$Firewall.NetworkRuleCollections.Add($NetRuleCollection)
Set-AzFirewall -AzureFirewall $Firewall

# Set the DNS Target on DemoVM1 Nic to 8.8.8.8
$NIC = Get-AzNetworkInterface -Name DemoVM1 -ResourceGroupName $ResourceGroup
$NIC.DnsSettings.DnsServers.Add("8.8.8.8")
$NIC | Set-AzNetworkInterface
