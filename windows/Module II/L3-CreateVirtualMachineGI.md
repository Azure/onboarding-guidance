
# Module:- Create a new VM from Gallery Image

# Abstract

During this module, you will learn to find available images on Azure and create a new virtual machine from it.

# Learning objectives
After completing the exercises in this module, you will be able to:
* List all locations that subscription has access too
* Choose Desired Location
* Setup Resource Group and Storage Account
* Setup Networking
* Setting up of OS Disk Name and Deploying the VM

# Prerequisite 
* [Module on Storage](https://#)

# Estimated time to complete this module:
30 min

# What are Marketplace Virtual Machine Images?
Virtual Machines Marketplace images are download certified pre-configured software images for your Linux or Windows Server VMs from Microsoft and industry-leading software providers.

# Create a Windows VM using Resource Manager and PowerShell

### Find Azure location that subscription has access too.
```PowerShell
Get-AzureRmLocation | sort Location | Select Location
```
### Choose Desired Location

```PowerShell
$locName = "centralus"
```
### Setup ResourceGroup
```PowerShell
$rgName = "mygroup2"

New-AzureRmResourceGroup -Name $rgName -Location $locName
```
### Setup Storage Account
```PowerShell
$stName = "mystorageaccountft"
````
##### To Check Availibilty of Storage Account Name
```PowerShell
Get-AzureRmStorageAccountNameAvailability $stName

$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -SkuName "Standard_LRS" -Kind "Storage" -Location $locName
```

### Setup Networking
```PowerShell
$subnetName = "mysubnet1"
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24


$vnetName = "myvnet1"
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet

$ipName = "myIPaddress1"
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic


$nicName = "mynic1"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
```

#### Setup Availibity Set
```PowerShell
New-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name "AvailabilitySet01" -Location $locName
$AvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name "AvailabilitySet01"
```
### --------------------
### Setup Credentials
```PowerShell
$user = "youaretheadmin"
$password = 'Pa$$word$1'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)
```
###### Using prompt
```PowerShell
# $cred = Get-Credential -Message "Type the name and password of the local administrator account."
```
### --------------------


### To get VM Sizes Available in the region
```PowerShell
# Get-AzureRmVMSize -Location $locName|FT
```

### setup VM Configutation
```PowerShell
$vmName = "myvm1"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_A1" -AvailabilitySetID $AvailabilitySet.Id


$compName = "myvm1"
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $compName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
```

### Make sure you have validated the availability of the image [More Details](https://github.com/abhishekanand/AzureLearning/blob/master/Module%20II/L2-FindAPublishedImage.md)
```PowerShell
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"


$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
```
### Setting up of OS Disk Name
```PowerShell
$blobPath = "vhds/"+$vmname+"_os.vhd"
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $blobPath

$osdiskName = $vmname+'_osDisk'
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osdiskName -VhdUri $osDiskUri -CreateOption fromImage
```
### Deploy the VM

```PowerShell
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm -Verbose -Debug
```
# See the following resources to learn more
* [Create a Windows VM using Resource Manager and PowerShell](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-ps-create/)
