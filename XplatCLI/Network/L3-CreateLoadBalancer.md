# Need more info

Prerequisite: (L2 - CreateVirtualNetwork)

1. VNET 
2. Subnet


#### Create a public IP address named NRPPublicIP to be used by a front end IP pool with DNS name loadbalancernrpft.eastus.cloudapp.azure.com.
azure network public-ip create -g TestRGVnet -n NRPPublicIP -l centralus -d loadbalancernrpft -a static -i 4


#### Create a load balancer

azure network lb create TestRGVnet NRPlb centralus

### Create a front end IP pool and a backend address pool

#### Create a front end IP pool associating the public IP
azure network lb frontend-ip create TestRGVnet NRPlb NRPfrontendpool -i nrppublicip

#### Set up a back end address pool used to receive incoming traffic from the front end IP pool.
azure network lb address-pool create TestRGVnet NRPlb NRPbackendpool
