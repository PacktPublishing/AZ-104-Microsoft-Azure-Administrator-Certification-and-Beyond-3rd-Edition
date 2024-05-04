# Parameters
$ResourceGroup = "AZ104-NetworkWatcher"
$Location = "WestEurope"
$SubscriptionId = "xxxxxxx"
$VirtualNetworkName = "NetworkWatcherVPNVnet"
$VMName = "NetworkWatcher1"
$VnetAddressPrefix = "40.0.0.0/16"
$SubnetAddressPrefix = "40.0.1.0/24"
$GatewayAddressPrefix = "40.0.0.0/27"

# First connect your Azure account using your credentials
Connect-AzAccount

# If necessary, select the right subscription as follows
Select-AzSubscription -SubscriptionId $SubscriptionId

# Create the a New VNet for the VPN Gateway
$VpnVnet = New-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroup -Location $Location -AddressPrefix $VnetAddressPrefix
$DefaultSubnet = Add-AzVirtualNetworkSubnetConfig -Name "default" -VirtualNetwork $VpnVnet -AddressPrefix $SubnetAddressPrefix
$GWSubnet = Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix $GatewayAddressPrefix -VirtualNetwork $VpnVnet
Set-AzVirtualNetwork -VirtualNetwork $VpnVnet

# Create the Local Network Gateway
$PublicIP = Get-AzPublicIpAddress -Name $VMName # Get the public IP for NetworkWatcher1
$LocalGW = New-AzLocalNetworkGateway -Name $VMName -ResourceGroupName $ResourceGroup -Location $Location -GatewayIpAddress $PublicIP.IpAddress -AddressPrefix '192.168.0.0/16'

# Create the VPN Gateway
$gwpip= New-AzPublicIpAddress -Name VNet1GWPIP -ResourceGroupName $ResourceGroup -Location $Location -AllocationMethod Static -Sku Standard
$VpnVnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup -Name $VirtualNetworkName
$GWSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VpnVnet -Name 'GatewaySubnet'
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig1 -SubnetId $GWSubnet.Id -PublicIpAddressId $gwpip.Id
$VpnGW = New-AzVirtualNetworkGateway -Name NetworkWatcherVPN -ResourceGroupName $ResourceGroup -Location $Location -IpConfigurations $gwipconfig -GatewayType Vpn -VpnType RouteBased -GatewaySku VpnGw2

# Create the S2S VPN Connection
New-AzVirtualNetworkGatewayConnection -Name "$($VirtualNetworkName)to$($VMName)" -ResourceGroupName $ResourceGroup -Location $Location -VirtualNetworkGateway1 $VpnGW -LocalNetworkGateway2 $LocalGW -ConnectionType IPsec -SharedKey 'Pa55w.rd1234'
