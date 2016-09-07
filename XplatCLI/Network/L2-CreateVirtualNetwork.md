# Need more info

#### To login to your Azure Subscription
azure login

#### List all the accounts that you have access .
azure account list

#### Set default account for the session
azure account set XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
azure account show

#### Change Mode to arm
azure config mode arm


#### To see Location that can be accessed in your current subscriptions

```shell
azure location list

or

azure location list  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX
```


#### Create the resource group:
azure group create -n TestRGVnet -l centralus

#### Verify the resource group
azure group show TestRGVnet

#### Create a VNet  
azure network vnet create -g TestRGVnet -n TestVNet -a 192.168.0.0/16 -l centralus

#### Create a Subnet
azure network vnet subnet create -g TestRGVnet -e TestVNet -n FrontEnd -a 192.168.1.0/24

#### (optional) Create an additional Subnet
azure network vnet subnet create -g TestRGVnet -e TestVNet -n BackEnd -a 192.168.2.0/24

#### To view the properties of the new vnet
azure network vnet show -g TestRGVnet -n TestVNet

