﻿

### How to connect VNets that are in the same subscription 
# https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-vnet-vnet-rm-ps/#samesub


#### Open Azure PowerShell and sign in to your Azure account.

Login-AzureRmAccount

###### This command will open a pop-up window for you to enter your Azure credentials.

#### Check the subscriptions for the account.

Get-AzureRmSubscription 

#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.


Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"


# First VNET in Subscription 1

$Sub1          = "Replace_With_Your_Subcription_Name"

$RG1           = "SiteRG1"
$Location1     = "East US"
$VNetName1     = "SiteVNet1"
$FESubName1    = "FrontEnd"
$BESubName1    = "Backend"
$GWSubName1    = "GatewaySubnet"
$VNetPrefix11  = "10.11.0.0/16"
$VNetPrefix12  = "10.12.0.0/16"

$FESubPrefix1  = "10.11.0.0/24"
$BESubPrefix1  = "10.12.0.0/24"
$GWSubPrefix1  = "10.12.255.0/27"

$DNS1          = "8.8.8.8"
$GWName1       = "VNet1GW"
$GWIPName1     = "VNet1GWIP"
$GWIPconfName1 = "gwipconf1"


$Connection12  = "VNet1toVNet2"

$Connection13  = "VNet1toVNet3" # (Third VNET in Subscription 2) 


# Second VNET Subscription 1

$RG2           = "SiteRG2"
$Location2     = "West US"
$VnetName2     = "SiteVNet2"
$FESubName2    = "FrontEnd"
$BESubName2    = "Backend"
$GWSubName2    = "GatewaySubnet"
$VnetPrefix21  = "10.41.0.0/16"
$VnetPrefix22  = "10.42.0.0/16"

$FESubPrefix2  = "10.41.0.0/24"
$BESubPrefix2  = "10.42.0.0/24"
$GWSubPrefix2  = "10.42.255.0/27"

$DNS2          = "8.8.8.8"
$GWName2       = "VNet2GW"
$GWIPName2     = "VNet2GWIP"
$GWIPconfName2 = "gwipconf2"
$Connection21  = "VNet2toVNet1"
####################################################################################################

# Creation of First VNET 


#### Create a new resource group
New-AzureRmResourceGroup -Name $RG1 -Location $Location1 

#### Create the subnet configurations for SiteVNet1

$fesub1 = New-AzureRmVirtualNetworkSubnetConfig -Name $FESubName1 -AddressPrefix $FESubPrefix1
$besub1 = New-AzureRmVirtualNetworkSubnetConfig -Name $BESubName1 -AddressPrefix $BESubPrefix1
$gwsub1 = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName1 -AddressPrefix $GWSubPrefix1

#### Create SiteVNet1

New-AzureRmVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1 -Location $Location1 -AddressPrefix $VNetPrefix11,$VNetPrefix12 -Subnet $fesub1,$besub1,$gwsub1

#### Request a public IP address
$gwpip1    = New-AzureRmPublicIpAddress -Name $GWIPName1 -ResourceGroupName $RG1 -Location $Location1 -AllocationMethod Dynamic

#### Create the gateway configuration

$vnet1     = Get-AzureRmVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1
$subnet1   = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet1
$gwipconf1 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 -Subnet $subnet1 -PublicIpAddress $gwpip1


#### Create the gateway for SiteVNet1
New-AzureRmVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1 -Location $Location1 -IpConfigurations $gwipconf1 -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard

####################################################################################################
# Creation of Second VNET 

#### Create a new resource group
New-AzureRmResourceGroup -Name $RG2 -Location $Location2

#### Create the subnet configurations for SiteVNet2
$fesub2 = New-AzureRmVirtualNetworkSubnetConfig -Name $FESubName2 -AddressPrefix $FESubPrefix2
$besub2 = New-AzureRmVirtualNetworkSubnetConfig -Name $BESubName2 -AddressPrefix $BESubPrefix2
$gwsub2 = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName2 -AddressPrefix $GWSubPrefix2
#### Create SiteVNet2
New-AzureRmVirtualNetwork -Name $VnetName2 -ResourceGroupName $RG2 -Location $Location2 -AddressPrefix $VnetPrefix21,$VnetPrefix22 -Subnet $fesub2,$besub2,$gwsub2

#### Request a public IP address

$gwpip2    = New-AzureRmPublicIpAddress -Name $GWIPName2 -ResourceGroupName $RG2 -Location $Location2 -AllocationMethod Dynamic

#### Create the gateway configuration
$vnet2     = Get-AzureRmVirtualNetwork -Name $VnetName2 -ResourceGroupName $RG2
$subnet2   = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet2
$gwipconf2 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName2 -Subnet $subnet2 -PublicIpAddress $gwpip2 


#### Create the gateway for SiteVNet2
New-AzureRmVirtualNetworkGateway -Name $GWName2 -ResourceGroupName $RG2 -Location $Location2 -IpConfigurations $gwipconf2 -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard

####################################################################################################

#### Now Step 4 - Connecting the gateways

$vnet1gw = Get-AzureRmVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1
$vnet2gw = Get-AzureRmVirtualNetworkGateway -Name $GWName2 -ResourceGroupName $RG2



#### Create the SiteVNet1 to SiteVNet2 connection

$sharedKey = 'AzureA1b2C3'

New-AzureRmVirtualNetworkGatewayConnection -Name $Connection12 -ResourceGroupName $RG1 -VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet2gw -Location $Location1 -ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3'

#### Create the SiteVNet2 to SiteVNet1 connection
New-AzureRmVirtualNetworkGatewayConnection -Name $Connection21 -ResourceGroupName $RG2 -VirtualNetworkGateway1 $vnet2gw -VirtualNetworkGateway2 $vnet1gw -Location $Location2 -ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3'


####################################################################################################
### How to verify a VNet-to-VNet connection

#### You can verify a VPN connection in the Azure Portal by navigating to Virtual network gateways -> click your gateway name -> Settings -> Connections. By selecting the name of the connection, you can view more information in the Connection blade. 

####To verify your connection using PowerShell

Get-AzureRmVirtualNetworkGatewayConnection -Name $Connection12 -ResourceGroupName $RG1 -Debug


Get-AzureRmVirtualNetworkGatewayConnection -Name $Connection21 -ResourceGroupName $RG2 -Debug

<#

ConnectionStatus           : Connected
EgressBytesTransferred     : 3504
IngressBytesTransferred    : 3856

#>
