# Create a virtual network by using PowerShell

[Microsoft Official Article] - [Click Here](https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-create-vnet-arm-ps/)


#### Open Azure PowerShell and sign in to your Azure account.

Login-AzureRmAccount

###### This command will open a pop-up window for you to enter your Azure credentials.

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
