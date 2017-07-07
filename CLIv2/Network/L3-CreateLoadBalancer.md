# Need more info

Prerequisite: (L2 - CreateVirtualNetwork)

1. VNET 
2. Subnet


#### Create a public IP address named LB-PIP to be used by a front end IP pool with DNS name loadbalancernrpft.eastus.cloudapp.azure.com.
az network public-ip create -n LB-PIP -g MyCLI-RG --allocation-method Static -l westus --dns-name loadbalancernrpft

#### Create a load balancer
az network lb create -n LB -g MyCLI-RG -l westus

### Create a front end IP pool and a backend address pool

#### Create a front end IP pool associating the public IP
az network lb frontend-ip create --lb-name LB -n FrontEndPool -g MyCLI-RG --public-ip-address LB-PIP

#### Set up a back end address pool used to receive incoming traffic from the front end IP pool.
az network lb address-pool create --lb-name LB -n BackEndPool -g MyCLI-RG