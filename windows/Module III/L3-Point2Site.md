# Module:- Create Point to Site Connection (On-premise to Azure)

# Abstract

During this module, you will learn how Microsoft Azure networking provides the infrastructure necessary to securely connect Virtual Machines (VMs) to one another, and be the bridge between the cloud and on-premises datacenter.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Create a Point to Site Connection (On-premise to Azure).

# Prerequisite 
* Completion of [Module on Compute](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20II/L1-ComputeIntro.md)

# Estimated time to complete this module:
4-6 hours

# What is a Virtual Network?
An Azure virtual network (VNet) is a representation of your own network in the cloud. It is a logical isolation of the Azure cloud dedicated to your subscription. You can fully control the IP address blocks, DNS settings, security policies, and route tables within this network. You can also further segment your VNet into subnets and launch Azure IaaS virtual machines (VMs) and/or Cloud services (PaaS role instances). Additionally, you can connect the virtual network to your on-premises network using one of the connectivity options available in Azure. In essence, you can expand your network to Azure, with complete control on IP address blocks with the benefit of enterprise scale Azure provides.

# Create Point to Site Connection (On-premise to Azure)

#### Open Azure PowerShell and sign in to your Azure account.
```PowerShell
Login-AzureRmAccount
```
#### :memo: Note: This command will open a pop-up window for you to enter your Azure credentials.

#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.

```PowerShell
Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
```
#

```
$VNetName  = "TestVNet"
$FESubName = "FrontEnd"
$BESubName = "Backend"
$GWSubName = "GatewaySubnet"
$VNetPrefix1 = "192.168.0.0/16"
$VNetPrefix2 = "10.254.0.0/16"
$FESubPrefix = "192.168.1.0/24"
$BESubPrefix = "10.254.1.0/24"
$GWSubPrefix = "192.168.200.0/26"
$VPNClientAddressPool = "172.16.201.0/24"
$RG = "TestRG"
$Location = "East US"
$DNS = "8.8.8.8"
$GWName = "GW"
$GWIPName = "GWIP"
$GWIPconfName = "gwipconf"
$P2SRootCertName = "ARMP2SRootCert.cer"
```
#### Create a new Resource Group
```
New-AzureRmResourceGroup -Name $RG -Location $Location
```
#### Create the subnet configurations for the virtual network, naming them FrontEnd, BackEnd, and GatewaySubnet. Note that these prefixes must be part of the VNet address space declared above.
```
$fesub = New-AzureRmVirtualNetworkSubnetConfig -Name $FESubName -AddressPrefix $FESubPrefix
$besub = New-AzureRmVirtualNetworkSubnetConfig -Name $BESubName -AddressPrefix $BESubPrefix
$gwsub = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix
```

#### Create the virtual network. Note that the DNS server specified should be a DNS server that can resolve the names for the resources you are connecting to.
##### For this example, we used a public IP address, but you will want to put in your own values here.
```
New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG -Location $Location -AddressPrefix $VNetPrefix1,$VNetPrefix2 -Subnet $fesub, $besub, $gwsub -DnsServer $DNS
```
#### Specify the variables for the virtual network you just created.
```
$vnet = Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet
```
#### Request a dynamically assigned public IP address. This IP address is necessary for the gateway to work properly. You will later connect the gateway to the gateway IP configuration.
```
$pip = New-AzureRmPublicIpAddress -Name $GWIPName -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $subnet -PublicIpAddress $pip
```

#### Windows Software Development Kit (SDK) for Windows 10

#### https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk

#### Install with default setting

#### To create a self-signed root certificate

```
$MyP2SRootCertPubKeyBase64 = "<Insert >"
$p2srootcert = New-AzureRmVpnClientRootCertificate -Name $P2SRootCertName -PublicCertData $MyP2SRootCertPubKeyBase64
```
#### Create the virtual network gateway for your VNet. The GatewayType must be Vpn and the VpnType must be RouteBased.


```
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $ipconf -GatewayType Vpn -VpnType RouteBased -EnableBgp $false -GatewaySku Standard -VpnClientAddressPool $VPNClientAddressPool -VpnClientRootCertificates $p2srootcert
```



```
#<------------------------------------------------------------------------->

# Client Side Configuration

# Each client that connects to Azure by using Point-to-Site must have two things:
## 1. The VPN client must be configured to connect
## 2. The client must have a client certificate installed.
# VPN client configuration packages are available for Windows clients. P

# To generate a client certificate from a self-signed root certificate.

Get-AzureRmVpnClientPackage -ResourceGroupName $RG -VirtualNetworkGatewayName $GWName -ProcessorArchitecture Amd64

# This command will generate a link similar to
<#
"https://mdsbrketwprodsn1prod.blob.core.windows.net/cmakexe/ac802c0a-7d64-4d10-92b1-2ed970
a2beaa/amd64/ac802c0a-7d64-4d10-92b1-2ed970a2beaa.exe?sv=2014-02-14&sr=b&sig=VJA2ik6MILecy
O%2F5faW9uj7khXCUHYii5Z0P%2Fd0MyL8%3D&st=2016-07-20T17%3A53%3A51Z&se=2016-07-20T18%3A53%3A
51Z&sp=r&fileExtension=.exe"

#>

# Now you have both requirment fulfilled .

# Install VPN for the VNET by installing the downloaded file .
# Verify Connection - Point to Site .
# https://resources.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/TestRG/providers/Microsoft.Network/virtualNetworkGateways/GW

<#

   "vpnClientRevokedCertificates": [],
      "vpnClientConnectionHealth": {
        "vpnClientConnectionsCount": 0,
        "allocatedIpAddresses": [],
        "totalIngressBytesTransferred": 9004,
        "totalEgressBytesTransferred": 6238


Create Conncetion :

PPP adapter TestVNet:

   Connection-specific DNS Suffix  . :
   Description . . . . . . . . . . . : TestVNet
   Physical Address. . . . . . . . . :
   DHCP Enabled. . . . . . . . . . . : No
   Autoconfiguration Enabled . . . . : Yes
   IPv4 Address. . . . . . . . . . . : 172.16.201.2(Preferred)
   Subnet Mask . . . . . . . . . . . : 255.255.255.255
   Default Gateway . . . . . . . . . :
   DNS Servers . . . . . . . . . . . : 8.8.8.8
   NetBIOS over Tcpip. . . . . . . . : Enabled



"vpnClientRevokedCertificates": [],
      "vpnClientConnectionHealth": {
        "vpnClientConnectionsCount": 1,
        "allocatedIpAddresses": [
          "172.16.201.2"
        ],
        "totalIngressBytesTransferred": 124428,
        "totalEgressBytesTransferred": 160793

 ```
# See the following resources to learn more
* [Configure a Point-to-Site connection to a virtual network using PowerShell](https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-howto-point-to-site-rm-ps/)
* [Supported scenario in Point to Site connection](https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-vpn-faq/#point-to-site-connections)
