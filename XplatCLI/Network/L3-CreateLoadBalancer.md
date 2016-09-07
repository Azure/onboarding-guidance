# Need more info

Prerequisite: (L2 - CreateVirtualNetwork)

1. VNET 
2. Subnet


#### Create a public IP address named NRPPublicIP to be used by a front end IP pool with DNS name loadbalancernrpft.eastus.cloudapp.azure.com.
azure network public-ip create -g TestRGVnet -n NRPPublicIP -l centralus -d loadbalancernrpft -a static -i 4


#### Create a load balancer

azure network lb create TestRGVnet NRPlb centralus

Test1