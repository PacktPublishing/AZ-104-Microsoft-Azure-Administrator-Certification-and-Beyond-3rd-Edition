########################################################################################################
# Creating the Public Load Balancer
########################################################################################################

# Create a Resource Group
az group create --name AZ104-PublicLoadBalancer --location westeurope

# Create a Public IP Address
az network public-ip create --resource-group AZ104-PublicLoadBalancer --name PLBPublicIP --sku standard

# Create the Load Balancer
az network lb create `
  --resource-group AZ104-PublicLoadBalancer `
  --name PublicLoadBalancer `
  --sku standard `
  --public-ip-address PLBPublicIP `
  --frontend-ip-name PLBFrontEnd `
  --backend-pool-name PLBBackEndPool

# Create the Health Probe
az network lb probe create `
  --resource-group AZ104-PublicLoadBalancer `
  --lb-name PublicLoadBalancer `
  --name PLBHealthProbe `
  --protocol http `
  --port 80 `
  --path /

# Create the Load Balancer Rule
az network lb rule create `
--resource-group AZ104-PublicLoadBalancer `
--lb-name PublicLoadBalancer `
--name PLBHTTPRule `
--protocol tcp `
--frontend-port 80 `
--backend-port 80 `
--frontend-ip-name PLBFrontEnd `
--backend-pool-name PLBBackEndPool `
--probe-name PLBHealthProbe

########################################################################################################
# Creating the VNet and NSG
########################################################################################################

# Create a Virtual Network
az network vnet create `
  --resource-group AZ104-PublicLoadBalancer `
  --location westeurope `
  --name PLBVnet `
  --subnet-name PLBSubnet

# Create an NSG
az network nsg create `
  --resource-group AZ104-PublicLoadBalancer `
  --name PLBNetworkSecurityGroup

# Create a Network Security Group Rule
az network nsg rule create `
  --resource-group AZ104-PublicLoadBalancer `
  --nsg-name PLBNetworkSecurityGroup `
  --name PLBNetworkSecurityGroupRuleHTTP `
  --protocol tcp `
  --direction inbound `
  --source-address-prefix '*' `
  --source-port-range '*' `
  --destination-address-prefix '*' `
  --destination-port-range 80 `
  --access allow `
  --priority 200

# Create NICs
for ($i = 1; $i -le 2; $i++){
    az network nic create `
      --resource-group AZ104-PublicLoadBalancer `
      --name PLBVMNic$i `
      --vnet-name PLBVnet `
      --subnet PLBSubnet `
      --network-security-group PLBNetworkSecurityGroup `
      --lb-name PublicLoadBalancer `
      --lb-address-pools PLBBackEndPool
}
  
########################################################################################################
# Creating the Backend Servers
########################################################################################################

nano cloud-init.txt

# Create 2 Virtual Machines
for ($i = 1; $i -le 2; $i++){
  az vm create `
    --resource-group AZ104-PublicLoadBalancer `
    --name PLBVM$i `
    --nics PLBVMNic$i `
    --image Ubuntu2204 `
    --admin-username azureuser `
    --generate-ssh-keys `
    --custom-data cloud-init.txt `
    --no-wait
}

########################################################################################################
# Testing the Load Balancer
########################################################################################################

#Obtain public IP address
az network public-ip show `
  --resource-group AZ104-PublicLoadBalancer `
  --name PLBPublicIP `
  --query [ipAddress] `
  --output tsv
