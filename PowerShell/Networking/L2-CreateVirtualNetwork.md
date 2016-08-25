# Module:- Create a virtual network by using PowerShell

# Abstract

During this module, you will learn how Microsoft Azure networking provides the infrastructure necessary to securely connect Virtual Machines (VMs) to one another, and be the bridge between the cloud and on-premises datacenter.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Create a virtual network by using PowerShell.
* Learn how to assign names and subnets to VNETs.

# Prerequisite 
* Completion of [Module on Compute](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20II/L1-ComputeIntro.md)

# Estimated time to complete this module:
Self-guided

# What is a Virtual Network?
An Azure virtual network (VNet) is a representation of your own network in the cloud. It is a logical isolation of the Azure cloud dedicated to your subscription. You can fully control the IP address blocks, DNS settings, security policies, and route tables within this network. You can also further segment your VNet into subnets and launch Azure IaaS virtual machines (VMs) and/or Cloud services (PaaS role instances). Additionally, you can connect the virtual network to your on-premises network using one of the connectivity options available in Azure. In essence, you can expand your network to Azure, with complete control on IP address blocks with the benefit of enterprise scale Azure provides.

# Create a virtual network by using PowerShell

#### Open Azure PowerShell and sign in to your Azure account.

Login-AzureRmAccount

#### :memo: Note: This command will open a pop-up window for you to enter your Azure credentials.

#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.

```
Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
```

####  Create a resource group named TestRG
```
New-AzureRmResourceGroup -Name TestRG -Location centralus
```
#### Create a new VNet name
```
New-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name TestVNet -AddressPrefix 192.168.0.0/16 -Location centralus
```
#### Verify details of the Virtual Network
```
Get-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name TestVNet
```
#### Store the virtual network object in a variable
```
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name TestVNet
```
#### Add a subnet to the new VNet variable
```
Add-AzureRmVirtualNetworkSubnetConfig -Name FrontEnd -VirtualNetwork $vnet -AddressPrefix 192.168.1.0/24
```
#### Add another subnet to the new VNet variable (optional)
```
Add-AzureRmVirtualNetworkSubnetConfig -Name BackEnd  -VirtualNetwork $vnet -AddressPrefix 192.168.2.0/24
```
#### Although you create subnets, they currently only exist in the local variable used to retrieve the VNet. To verify
```
Get-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name TestVNet
```
#### To save the changes to Azure, run the Set-AzureRmVirtualNetwork cmdlet
```
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
 ```
#### Now Verify configuration of completed VNET
```
Get-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name TestVNet
```
####  How to delete the VNET
```
Remove-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name TestVNet -Verbose -Debug
```
# See the following resources to learn more
* [Create a virtual network by using PowerShell](https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-create-vnet-arm-ps/)
