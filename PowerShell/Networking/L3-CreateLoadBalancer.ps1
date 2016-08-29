
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


## variable

$rgname = 'NRP-RG2'
$location = 'West US'

$VNetname = 'TestVNet'
$VNetPrefix  = "10.11.0.0/16"

$LBsubnetBEName = "LBsubnetBE"
$LBsubnetBEPrefix = "10.11.0.0/24"

$lbpublicIPName = 'lbpublicIP'
$DomainNameLabel = 'ftloadbalancernrp'

$lbfrontendIPName = 'lbfrontendip'
$lodbalancerName = 'NRP-LB'
$BackendAddressPoolName ='LB-backend-Address-pool'


# Create a new resource group (skip this step if using an existing resource group)

New-AzureRmResourceGroup -ResourceGroupName $rgname -Location $location

#### Create a new VNet name

$LBsubnetBE = New-AzureRmVirtualNetworkSubnetConfig -Name $LBsubnetBEName  -AddressPrefix $LBsubnetBEPrefix
New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $rgname -Location $location -AddressPrefix $VNetPrefix -Subnet $LBsubnetBE -Verbose


$lbpublicIP = New-AzureRmPublicIpAddress -Name $lbpublicIPName -ResourceGroupName $rgname -Location $location –AllocationMethod Static -DomainNameLabel $DomainNameLabel

$lbfrontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name $lbfrontendIPName -PublicIpAddress $lbpublicIP

$beaddresspool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name $BackendAddressPoolName

$healthProbe1 = New-AzureRmLoadBalancerProbeConfig -Name HealthProbe1 -Protocol Tcp -Port 80 -IntervalInSeconds 15 -ProbeCount 2

$LoadBalancingRule1 = New-AzureRmLoadBalancerRuleConfig -Name HTTP -FrontendIpConfiguration $lbfrontendIP -BackendAddressPool  $beAddressPool -Probe $healthProbe1 -Protocol Tcp -FrontendPort 80 -BackendPort 80

$NRPLB = New-AzureRmLoadBalancer -Name $lodbalancerName -ResourceGroupName  $rgname -Location $location -FrontendIpConfiguration $lbfrontendIP -LoadBalancingRule $LoadBalancingRule1 -BackendAddressPool $beaddresspool -Probe $healthProbe1

get-AzureRmLoadBalancer -Name $lodbalancerName -ResourceGroupName $rgname 

# Note : Now you can create VM in an Availbiity Set in above VNET/Subnet and assign the Availability Set to the  Banckend Pool.