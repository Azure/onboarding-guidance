
# Microsoft Official Documentation 
# https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-howto-point-to-site-rm-ps/
# Supported scenario in Point to Site connection :
# https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-vpn-faq/#point-to-site-connections

# Create Point to site Connection (On-premises to Azure)

#### Open Azure PowerShell and sign in to your Azure account.

Login-AzureRmAccount

###### This command will open a pop-up window for you to enter your Azure credentials.

#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.


Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"

#


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

# Create a new Resource Group

New-AzureRmResourceGroup -Name $RG -Location $Location

# Create the subnet configurations for the virtual network, naming them FrontEnd, BackEnd, and GatewaySubnet. Note that these prefixes must be part of the VNet address space declared above.

$fesub = New-AzureRmVirtualNetworkSubnetConfig -Name $FESubName -AddressPrefix $FESubPrefix
$besub = New-AzureRmVirtualNetworkSubnetConfig -Name $BESubName -AddressPrefix $BESubPrefix
$gwsub = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix


# Create the virtual network. Note that the DNS server specified should be a DNS server that can resolve the names for the resources you are connecting to.
# For this example, we used a public IP address, but you will want to put in your own values here.

New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG -Location $Location -AddressPrefix $VNetPrefix1,$VNetPrefix2 -Subnet $fesub, $besub, $gwsub -DnsServer $DNS

# Specify the variables for the virtual network you just created.

$vnet = Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet

# Request a dynamically assigned public IP address. This IP address is necessary for the gateway to work properly. You will later connect the gateway to the gateway IP configuration.

$pip = New-AzureRmPublicIpAddress -Name $GWIPName -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $subnet -PublicIpAddress $pip


# Windows Software Development Kit (SDK) for Windows 10

# https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk 

# Install with default setting 

# To create a self-signed root certificate


$MyP2SRootCertPubKeyBase64 = "MIIDETCCAf2gAwIBAgIQVi/tBDmaVJ5EiXtYGpZ24jAJBgUrDgMCHQUAMB4xHDAaBgNVBAMTE1Jvb3RDZXJ0aWZpY2F0ZU5hbWUwHhcNMTYwNzE5MjM1MzE2WhcNMzkxMjMxMjM1OTU5WjAeMRwwGgYDVQQDExNSb290Q2VydGlmaWNhdGVOYW1lMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqD7L5Y0vyY/Rc7T+Lr6H6NeKiCO3cu2Ww6nQWk8S/YDO+gZPGz98nGIS2FhWcJv/hqoao/f1YI9gzTplLT4FGvGFvZzuo66feBrQXrDIQLIiMxtbOOnXtrn0fvsI7SGrTpT4WZ3UIoWR2/uT8FnYAwkBUsP2c1ZRMZj0JSnfXMk5QPBVgNghqhYY2sm8xo8nYasqD72Hbgd3VnvAWh23qF1S8N5E24ydBPxWcHZOxnQCHq/6E5arB6NNSR+h0rXmCiJqEGliv9PH6evKFW1KxmDYOYf2mCPRlI9ly/7AQAK3VhqIBu4zK5g6i33UQy5nbuIbXMI+0A/GKDG7pYDNhwIDAQABo1MwUTBPBgNVHQEESDBGgBCzfPkWGZCex08bE0WfpKjeoSAwHjEcMBoGA1UEAxMTUm9vdENlcnRpZmljYXRlTmFtZYIQVi/tBDmaVJ5EiXtYGpZ24jAJBgUrDgMCHQUAA4IBAQATiRBEdaOgbRTsJ+HN/x1J0B+8scQC29OYW3Kc2M+29okyZazAskVlZdqgdMhlpzEY9Ze7smpbS/+TRWyTVQZNZfYuTPCmGwvNZIHtjijmqsEWwJzWUJ3ncjxtXcKsi0bQBefzxEVGNDWnDbgRgOrq2VPTpafYaG/dsebe6+ypnuIl+jnpDAa7XlaraRAHK2cRZZ751HinjVFSj9JUyMmkDZHGzzlZeP0QVAc6Zbpq5tLf6m4K4OMq5RmlDQ15AcStjUhVu1vA+dmZJZ3BBDswTh4naSyNmn/rtN/e7V5OK84cc4Q1yFEGWoZ4wUtJGDbHX8/qhCDcIStou3gyZVRM"
$p2srootcert = New-AzureRmVpnClientRootCertificate -Name $P2SRootCertName -PublicCertData $MyP2SRootCertPubKeyBase64

# Create the virtual network gateway for your VNet. The GatewayType must be Vpn and the VpnType must be RouteBased.

# (Takes Very Long)

New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $ipconf -GatewayType Vpn -VpnType RouteBased -EnableBgp $false -GatewaySku Standard -VpnClientAddressPool $VPNClientAddressPool -VpnClientRootCertificates $p2srootcert


<#

 

PS C:\Users\user1> Login-AzureRmAccount

PS C:\Users\user1> 
Login-AzureRmAccount



Environment           : AzureCloud
Account               : user1@microsoft.com
TenantId              : 72f988bf-86f1-41af-91ab-2d7cd011db47
SubscriptionId        : XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
SubscriptionName      : Microsoft Azure Internal Consumption
CurrentStorageAccount : 




PS C:\Users\user1> $VNetName  = "TestVNet"
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


PS C:\Users\user1> New-AzureRmResourceGroup -Name $RG -Location $Location

WARNING: The usability of Tag parameter in this cmdlet will be modified in a future release. Th
is will impact creating, updating and appending tags for Azure resources. For more details abou
t the change, please visit https://github.com/Azure/azure-powershell/issues/726#issuecomment-21
3545494


ResourceGroupName : TestRG
Location          : eastus
ProvisioningState : Succeeded
Tags              : 
ResourceId        : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/TestRG




PS C:\Users\user1> # Create the subnet configurations for the virtual network, naming them FrontEnd, BackEnd, and GatewaySubnet. Note that these prefixes must be part of the VNet address space declared above.

$fesub = New-AzureRmVirtualNetworkSubnetConfig -Name $FESubName -AddressPrefix $FESubPrefix
$besub = New-AzureRmVirtualNetworkSubnetConfig -Name $BESubName -AddressPrefix $BESubPrefix
$gwsub = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix


# Create the virtual network. Note that the DNS server specified should be a DNS server that can resolve the names for the resources you are connecting to.
# For this example, we used a public IP address, but you will want to put in your own values here.

New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG -Location $Location -AddressPrefix $VNetPrefix1,$VNetPrefix2 -Subnet $fesub, $besub, $gwsub -DnsServer $DNS

# Specify the variables for the virtual network you just created.

$vnet = Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet

# Request a dynamically assigned public IP address. This IP address is necessary for the gateway to work properly. You will later connect the gateway to the gateway IP configuration.

$pip = New-AzureRmPublicIpAddress -Name $GWIPName -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $subnet -PublicIpAddress $pip

WARNING: The output object type of this cmdlet will be modified in a future release. Also, the 
usability of Tag parameter in this cmdlet will be modified in a future release. This will impac
t creating, updating and appending tags for Azure resources. For more details about the change,
 please visit https://github.com/Azure/azure-powershell/issues/726#issuecomment-213545494


Name              : TestVNet
ResourceGroupName : TestRG
Location          : eastus
Id                : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/TestRG/
                    providers/Microsoft.Network/virtualNetworks/TestVNet
Etag              : W/"f0452e27-3780-481e-80cc-1facd19d9a94"
ResourceGuid      : eb7b9c86-ed1f-4c10-9561-bfe8be5d1ff7
ProvisioningState : Succeeded
Tags              : 
AddressSpace      : {
                      "AddressPrefixes": [
                        "192.168.0.0/16",
                        "10.254.0.0/16"
                      ]
                    }
DhcpOptions       : {
                      "DnsServers": [
                        "8.8.8.8"
                      ]
                    }
Subnets           : [
                      {
                        "Name": "FrontEnd",
                        "Etag": "W/\"f0452e27-3780-481e-80cc-1facd19d9a94\"",
                        "Id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGro
                    ups/TestRG/providers/Microsoft.Network/virtualNetworks/TestVNet/subnets/Fr
                    ontEnd",
                        "AddressPrefix": "192.168.1.0/24",
                        "IpConfigurations": [],
                        "ProvisioningState": "Succeeded"
                      },
                      {
                        "Name": "Backend",
                        "Etag": "W/\"f0452e27-3780-481e-80cc-1facd19d9a94\"",
                        "Id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGro
                    ups/TestRG/providers/Microsoft.Network/virtualNetworks/TestVNet/subnets/Ba
                    ckend",
                        "AddressPrefix": "10.254.1.0/24",
                        "IpConfigurations": [],
                        "ProvisioningState": "Succeeded"
                      },
                      {
                        "Name": "GatewaySubnet",
                        "Etag": "W/\"f0452e27-3780-481e-80cc-1facd19d9a94\"",
                        "Id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGro
                    ups/TestRG/providers/Microsoft.Network/virtualNetworks/TestVNet/subnets/Ga
                    tewaySubnet",
                        "AddressPrefix": "192.168.200.0/26",
                        "IpConfigurations": [],
                        "ProvisioningState": "Succeeded"
                      }
                    ]

WARNING: The output object type of this cmdlet will be modified in a future release. Also, the 
usability of Tag parameter in this cmdlet will be modified in a future release. This will impac
t creating, updating and appending tags for Azure resources. For more details about the change,
 please visit https://github.com/Azure/azure-powershell/issues/726#issuecomment-213545494



PS C:\Users\user1> 

$MyP2SRootCertPubKeyBase64 = "MIIDETCCAf2gAwIBAgIQVi/tBDmaVJ5EiXtYGpZ24jAJBgUrDgMCHQUAMB4xHDAaBgNVBAMTE1Jvb3RDZXJ0aWZpY2F0ZU5hbWUwHhcNMTYwNzE5MjM1MzE2WhcNMzkxMjMxMjM1OTU5WjAeMRwwGgYDVQQDExNSb290Q2VydGlmaWNhdGVOYW1lMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqD7L5Y0vyY/Rc7T+Lr6H6NeKiCO3cu2Ww6nQWk8S/YDO+gZPGz98nGIS2FhWcJv/hqoao/f1YI9gzTplLT4FGvGFvZzuo66feBrQXrDIQLIiMxtbOOnXtrn0fvsI7SGrTpT4WZ3UIoWR2/uT8FnYAwkBUsP2c1ZRMZj0JSnfXMk5QPBVgNghqhYY2sm8xo8nYasqD72Hbgd3VnvAWh23qF1S8N5E24ydBPxWcHZOxnQCHq/6E5arB6NNSR+h0rXmCiJqEGliv9PH6evKFW1KxmDYOYf2mCPRlI9ly/7AQAK3VhqIBu4zK5g6i33UQy5nbuIbXMI+0A/GKDG7pYDNhwIDAQABo1MwUTBPBgNVHQEESDBGgBCzfPkWGZCex08bE0WfpKjeoSAwHjEcMBoGA1UEAxMTUm9vdENlcnRpZmljYXRlTmFtZYIQVi/tBDmaVJ5EiXtYGpZ24jAJBgUrDgMCHQUAA4IBAQATiRBEdaOgbRTsJ+HN/x1J0B+8scQC29OYW3Kc2M+29okyZazAskVlZdqgdMhlpzEY9Ze7smpbS/+TRWyTVQZNZfYuTPCmGwvNZIHtjijmqsEWwJzWUJ3ncjxtXcKsi0bQBefzxEVGNDWnDbgRgOrq2VPTpafYaG/dsebe6+ypnuIl+jnpDAa7XlaraRAHK2cRZZ751HinjVFSj9JUyMmkDZHGzzlZeP0QVAc6Zbpq5tLf6m4K4OMq5RmlDQ15AcStjUhVu1vA+dmZJZ3BBDswTh4naSyNmn/rtN/e7V5OK84cc4Q1yFEGWoZ4wUtJGDbHX8/qhCDcIStou3gyZVRM"
$p2srootcert = New-AzureRmVpnClientRootCertificate -Name $P2SRootCertName -PublicCertData $MyP2SRootCertPubKeyBase64

PS C:\Users\user1> 
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $ipconf -GatewayType Vpn -VpnType RouteBased -EnableBgp $false -GatewaySku Standard -VpnClientAddressPool $VPNClientAddressPool -VpnClientRootCertificates $p2srootcert

WARNING: The output object type of this cmdlet will be modified in a future release. Also, the 
usability of Tag parameter in this cmdlet will be modified in a future release. This will impac
t creating, updating and appending tags for Azure resources. For more details about the change,
 please visit https://github.com/Azure/azure-powershell/issues/726#issuecomment-213545494


IpConfigurations           : {gwipconf}
GatewayType                : Vpn
VpnType                    : RouteBased
EnableBgp                  : False
GatewayDefaultSite         : 
ProvisioningState          : Succeeded
Sku                        : Microsoft.Azure.Commands.Network.Models.PSVirtualNetworkGatewaySku
VpnClientConfiguration     : Microsoft.Azure.Commands.Network.Models.PSVpnClientConfiguration
BgpSettings                : Microsoft.Azure.Commands.Network.Models.PSBgpSettings
IpConfigurationsText       : [
                               {
                                 "PrivateIpAllocationMethod": "Dynamic",
                                 "Subnet": {
                                   "Id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/TestRG/provid
                             ers/Microsoft.Network/virtualNetworks/TestVNet/subnets/GatewaySubnet"
                                 },
                                 "PublicIpAddress": {
                                   "Id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/TestRG/provid
                             ers/Microsoft.Network/publicIPAddresses/GWIP"
                                 },
                                 "Name": "gwipconf",
                                 "Etag": "W/\"efa9621b-746a-4d1a-a72b-b306279edf29\"",
                                 "Id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/TestRG/provider
                             s/Microsoft.Network/virtualNetworkGateways/GW/ipConfigurations/gwipconf"
                               }
                             ]
GatewayDefaultSiteText     : null
SkuText                    : {
                               "Capacity": 2,
                               "Name": "Standard",
                               "Tier": "Standard"
                             }
VpnClientConfigurationText : {
                               "VpnClientAddressPool": {
                                 "AddressPrefixes": [
                                   "172.16.201.0/24"
                                 ]
                               },
                               "VpnClientRevokedCertificates": [],
                               "VpnClientRootCertificates": [
                                 {
                                   "ProvisioningState": "Succeeded",
                                   "PublicCertData": "MIIDETCCAf2gAwIBAgIQVi/tBDmaVJ5EiXtYGpZ24jAJBgUrDgMCHQUAMB4xHDAaBgNV
                             BAMTE1Jvb3RDZXJ0aWZpY2F0ZU5hbWUwHhcNMTYwNzE5MjM1MzE2WhcNMzkxMjMxMjM1OTU5WjAeMRwwGgYDVQQDExNSb
                             290Q2VydGlmaWNhdGVOYW1lMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqD7L5Y0vyY/Rc7T+Lr6H6NeKiC
                             O3cu2Ww6nQWk8S/YDO+gZPGz98nGIS2FhWcJv/hqoao/f1YI9gzTplLT4FGvGFvZzuo66feBrQXrDIQLIiMxtbOOnXtrn
                             0fvsI7SGrTpT4WZ3UIoWR2/uT8FnYAwkBUsP2c1ZRMZj0JSnfXMk5QPBVgNghqhYY2sm8xo8nYasqD72Hbgd3VnvAWh23
                             qF1S8N5E24ydBPxWcHZOxnQCHq/6E5arB6NNSR+h0rXmCiJqEGliv9PH6evKFW1KxmDYOYf2mCPRlI9ly/7AQAK3VhqIB
                             u4zK5g6i33UQy5nbuIbXMI+0A/GKDG7pYDNhwIDAQABo1MwUTBPBgNVHQEESDBGgBCzfPkWGZCex08bE0WfpKjeoSAwHj
                             EcMBoGA1UEAxMTUm9vdENlcnRpZmljYXRlTmFtZYIQVi/tBDmaVJ5EiXtYGpZ24jAJBgUrDgMCHQUAA4IBAQATiRBEdaO
                             gbRTsJ+HN/x1J0B+8scQC29OYW3Kc2M+29okyZazAskVlZdqgdMhlpzEY9Ze7smpbS/+TRWyTVQZNZfYuTPCmGwvNZIHt
                             jijmqsEWwJzWUJ3ncjxtXcKsi0bQBefzxEVGNDWnDbgRgOrq2VPTpafYaG/dsebe6+ypnuIl+jnpDAa7XlaraRAHK2cRZ
                             Z751HinjVFSj9JUyMmkDZHGzzlZeP0QVAc6Zbpq5tLf6m4K4OMq5RmlDQ15AcStjUhVu1vA+dmZJZ3BBDswTh4naSyNmn
                             /rtN/e7V5OK84cc4Q1yFEGWoZ4wUtJGDbHX8/qhCDcIStou3gyZVRM",
                                   "Name": "ARMP2SRootCert.cer",
                                   "Etag": "W/\"efa9621b-746a-4d1a-a72b-b306279edf29\"",
                                   "Id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/TestRG/provid
                             ers/Microsoft.Network/virtualNetworkGateways/GW/vpnClientRootCertificates/ARMP2SRootCert.cer"
                                 }
                               ]
                             }
BgpSettingsText            : {
                               "Asn": 65515,
                               "BgpPeeringAddress": "192.168.200.62",
                               "PeerWeight": 0
                             }
ResourceGroupName          : TestRG
Location                   : eastus
ResourceGuid               : b5adcd30-2aca-4564-94a9-6fd680fd3f8b
Tag                        : {}
TagsTable                  : 
Name                       : GW
Etag                       : W/"efa9621b-746a-4d1a-a72b-b306279edf29"
Id                         : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/TestRG/providers/Microsoft
                             .Network/virtualNetworkGateways/GW




PS C:\Users\user1> 

#>


#<------------------------------------------------------------------------->

# Client Side Configuration 

# Each client that connects to Azure by using Point-to-Site must have two things: 
## 1. the VPN client must be configured to connect, 
## 2. the client must have a client certificate installed. 
# VPN client configuration packages are available for Windows clients. P

# To generate a client certificate from a self-signed root certificate.

Get-AzureRmVpnClientPackage -ResourceGroupName $RG -VirtualNetworkGatewayName $GWName -ProcessorArchitecture Amd64

# THis command will generate a link similar to 
<#
"https://mdsbrketwprodsn1prod.blob.core.windows.net/cmakexe/ac802c0a-7d64-4d10-92b1-2ed970
a2beaa/amd64/ac802c0a-7d64-4d10-92b1-2ed970a2beaa.exe?sv=2014-02-14&sr=b&sig=VJA2ik6MILecy
O%2F5faW9uj7khXCUHYii5Z0P%2Fd0MyL8%3D&st=2016-07-20T17%3A53%3A51Z&se=2016-07-20T18%3A53%3A
51Z&sp=r&fileExtension=.exe"

#>



# Now you have both requirmeent 


# Install VPN for the VNET by installing the downloaded file . 




# https://resources.azure.com/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/TestRG/providers/Microsoft.Network/virtualNetworkGateways/GW 
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
      
 #> 

 #Open Question : 

 # Can I create Point to site connection using ARM portal. 
 # Can I Download the VPN client configuration package from Portal. 
 # How do we verify if conncetion is UP or not. 
 # How many devices are connceted using VPN and who are they.cls 



 