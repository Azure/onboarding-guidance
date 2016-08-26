
#### Open Azure PowerShell and sign in to your Azure account.

Login-AzureRmAccount
Login-AzureRmAccount
###### This command will open a pop-up window for you to enter your Azure credentials.

Get-AzureRmSubscription



#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.


Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"


### Find Azure location that subscription has access too.
Get-AzureRmLocation | sort Location | Select Location

=======


========
# create Rule 

# Create a security rule allowing access from the Internet to port 3389.
$rule1 = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 3389

# Create a security rule allowing access from the Internet to port 80.
$rule2 = New-AzureRmNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 80

# Add the rules created above to a new NSG named NSG-FrontEnd.

$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName TestRG -Location westus -Name "NSG-FrontEnd" `
    -SecurityRules $rule1,$rule2

# Check the rules created in the NSG.
$nsg

# Get details for exiting VNET 
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name TestVNet

# Associate the NSG created above to the FrontEnd subnet.
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name FrontEnd `
    -AddressPrefix 192.168.1.0/24 -NetworkSecurityGroup $nsg
Note : The output for the command above shows the content for the virtual network configuration object, which only exists on the computer where you are running PowerShell. You need to run the Set-AzureRmVirtualNetwork cmdlet to save these settings to Azure.


# Save the new VNet settings to Azure.
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

# How to create NSGs in Resource Manager by using PowerShell https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-create-nsg-arm-ps/