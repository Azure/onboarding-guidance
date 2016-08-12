# Module:- Create Site to Site Connection (On-premise to Azure)

# Abstract

During this module, you will learn how Microsoft Azure networking provides the infrastructure necessary to securely connect Virtual Machines (VMs) to one another, and be the bridge between the cloud and on-premises datacenter.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Create a Site to Site Connection (On-premise to Azure).

# Prerequisite 
* Completion of [Module on Compute](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20II/L1-ComputeIntro.md)

# Estimated time to complete this module:
Self-guided

# What is a Virtual Network?
An Azure virtual network (VNet) is a representation of your own network in the cloud. It is a logical isolation of the Azure cloud dedicated to your subscription. You can fully control the IP address blocks, DNS settings, security policies, and route tables within this network. You can also further segment your VNet into subnets and launch Azure IaaS virtual machines (VMs) and/or Cloud services (PaaS role instances). Additionally, you can connect the virtual network to your on-premises network using one of the connectivity options available in Azure. In essence, you can expand your network to Azure, with complete control on IP address blocks with the benefit of enterprise scale Azure provides.

# Create a virtual network with a Site-to-Site VPN connection using PowerShell and Azure Resource Manager

#### Open Azure PowerShell and sign in to your Azure account.
```
Login-AzureRmAccount
```
#### :memo: Note: This command will open a pop-up window for you to enter your Azure credentials.

#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.

```
Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
```


#### ===Variable Value for Azure
```
$RG = "Site2SiteRG"
$Location = "West US"

$FirstSubnet = "Subnet1"
$GWSubPrefix = "10.0.0.0/28"
$FirstSubnetPrefix = "10.0.1.0/28"
$VNetPrefix1 = "10.0.0.0/16"
$VNetName  = "Site2SiteVNet"

$GWSubName = "GatewaySubnet"
$GWIPName = "GWIP"
$GWIPconfName = "gwipconf"
$GWName = "S2SGW"
```
#### ================== variable Value from on premise  ==================

#### The GatewayIPAddress is the IP address of your on-premises VPN device. Your VPN device cannot be located behind a NAT.
#### The AddressPrefix is your on-premises address space.
```
$VPNDevGatewayIPAddress =""
$ONPAddressPrefix = ""
$LocalSiteName ="LocalSite"
```
#### ================================================================================


#### 1. To create a virtual network and a gateway subnet
```
New-AzureRmResourceGroup -Name $RG -Location $Location
```

#### 2. create your virtual network. Verify that the address spaces you specify don't overlap any of the address spaces that you have on your on-premises network

##### The sample below creates a virtual network named Site2SiteVNet and two subnets, one called GatewaySubnet and the other called Subnet1.
##### It's important to create one subnet named specifically GatewaySubnet. If you name it something else, your connection configuration will fail.
```
$gwsub = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix
$firstsub = New-AzureRmVirtualNetworkSubnetConfig -Name $FirstSubnet -AddressPrefix $FirstSubnetPrefix
New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG -Location $Location -AddressPrefix $VNetPrefix1 -Subnet $gwsub, $firstsub
```

#### 3. To add a local network gateway with a single address prefix:
```
New-AzureRmLocalNetworkGateway -Name $LocalSiteName -ResourceGroupName $RG -Location $Location -GatewayIpAddress $VPNDevGatewayIPAddress -AddressPrefix $ONPAddressPrefix
```
##### To add a local network gateway with multiple address prefixes:
 New-AzureRmLocalNetworkGateway -Name LocalSite -ResourceGroupName $RG -Location $Location -GatewayIpAddress $VPNDevGatewayIPAddress -AddressPrefix @('10.0.0.0/24','20.0.0.0/24')

#### 4. Request a public IP address for the VPN gateway
```
$gwpip= New-AzureRmPublicIpAddress -Name $GWIPName -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic
```

#### 5. Create the gateway IP addressing configuration
```
$vnet = Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName -VirtualNetwork $vnet
$gwipconfig = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id
```
#### 6. Create the virtual network gateway

Note that that creating a gateway can take a long time to complete. Often 20 minutes or more.

Use the following values:

The -GatewayType for a Site-to-Site configuration is Vpn. The gateway type is always specific to the configuration that you are implementing.

The -VpnType can be RouteBased (referred to as a Dynamic Gateway in some documentation), or PolicyBased (referred to as a Static Gateway in some documentation). For more information about VPN gateway types, see About VPN Gateways.

The -GatewaySku can be Basic, Standard, or HighPerformance.

```
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $gwipconfig -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard
```

#### 7. Configure your VPN device
##### About VPN devices for Site-to-Site VPN Gateway connections - https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-about-vpn-devices/
```
Get-AzureRmPublicIpAddress -Name $GWIPName -ResourceGroupName $RG
```
#### 8. Create the VPN connection
##### you'll create the Site-to-Site VPN connection between your virtual network gateway and your VPN device.
##### Be sure to replace the values with your own. The shared key must match the value you used for your VPN device configuration. Note that the -ConnectionType for Site-to-Site is IPsec.
```
$gateway1 = Get-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG
$local = Get-AzureRmLocalNetworkGateway -Name $LocalSiteName -ResourceGroupName $RG

New-AzureRmVirtualNetworkGatewayConnection -Name localtovon -ResourceGroupName $RG -Location $Location -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local -ConnectionType IPsec -RoutingWeight 10 -SharedKey 'abc123'
```

#### 9. Verify a VPN connection
##### You can verify a VPN connection in the Azure portal by navigating to Virtual network gateways > click your gateway name > Settings > Connections
```
Get-AzureRmVirtualNetworkGatewayConnection -Name localtovon -ResourceGroupName $RG -Debug
```
# See the following resources to learn more
* [Configure a Site-to-Site connection to a virtual network using PowerShell](https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-create-site-to-site-rm-powershell/)
