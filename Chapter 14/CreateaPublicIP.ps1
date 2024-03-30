# First connect your Azure account using your credentials
Connect-AzAccount

# Create the public IP address
$ip = @{
    Name = 'myStandardPublicIP'
    ResourceGroupName = 'AZ104-vnets'
    Location = 'WestEurope'
    Sku = 'Standard'
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
    Zone = 1,2,3
}
New-AzPublicIpAddress @ip
