# Create a Windows VM using Resource Manager and PowerShell 

#[Microsoft Official Article]- https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-ps-create/ 


# Run Login-AzureRmAccount to login
# Login-AzureRmAccount


### Find Azure location that subscription has access too.
Get-AzureRmLocation | sort Location | Select Location

### Choose Desired Location
$locName = "centralus"

### Setup ResourceGroup
$rgName = "mygroup3"

New-AzureRmResourceGroup -Name $rgName -Location $locName

### Setup Storage Account
$stName = "mystorageaccountft3"

### To Check Availibilty of Storage Account Name
Get-AzureRmStorageAccountNameAvailability $stName 

$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -SkuName "Standard_LRS" -Kind "Storage" -Location $locName 

### Setup Networking

$subnetName = "mysubnet1"
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24 


$vnetName = "myvnet1"
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet 

$ipName = "myIPaddress1"
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic


$nicName = "mynic1"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id 


### Setup Availibity Set 

New-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name "AvailabilitySet01" -Location $locName
$AvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name "AvailabilitySet01"


### --------------------
### Setup Credentials

$user = "youaretheadmin"
$password = 'Pa$$word$1'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)

###### Using prompt

# $cred = Get-Credential -Message "Type the name and password of the local administrator account."

### --------------------


### To get VM Sizes Available in the region

# Get-AzureRmVMSize -Location $locName|FT



### setup VM Configutation 

$vmName = "myvm1"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_A1" -AvailabilitySetID $AvailabilitySet.Id


$compName = "myvm1"
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $compName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate 

### Make sure you have validated the availbility of the image 
### (https://github.com/abhishekanand/AzureLearning/blob/master/Module%20II/L2-FindAPublishedImage.
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest" 


$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id 

### Setting up of OS Disk Name 
$osdiskName = $vmname+'_osDisk'

# Defining Location of OS Disk to be palced

$osblobPath = "vhds/"+$vmname+"_os.vhd"
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $osblobPath
# https://mystorageaccountft1.blob.core.windows.net/vhds/myvm1_os.vhd



$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osdiskName -VhdUri $osDiskUri -CreateOption fromImage 

# To Add new empty data disk to the Virtual Machine 

### Setting up of Data Disk Name 
$dataDiskName1 = $vmname+'_DataDisk1'
$dataDiskName2 = $vmname+'_DataDisk2'
$dataDiskName3 = $vmname+'_DataDisk3'

# Defining Location of Data Disk to be palced - Please validate the allowed number of data disk for the chosen VM size. 

$datablobPath1 = "vhds/"+$vmname+"_data1.vhd"
$DataDiskVhdUri01 = $storageAcc.PrimaryEndpoints.Blob.ToString() + $datablobPath1

$datablobPath2 = "vhds/"+$vmname+"_data2.vhd"
$DataDiskVhdUri02 = $storageAcc.PrimaryEndpoints.Blob.ToString() + $datablobPath2

$datablobPath3 = "vhds/"+$vmname+"_data3.vhd"
$DataDiskVhdUri03 = $storageAcc.PrimaryEndpoints.Blob.ToString() + $datablobPath3


$vm = Add-AzureRmVMDataDisk -VM $vm -Name $dataDiskName1 -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 0 -VhdUri $DataDiskVhdUri01 -CreateOption Empty
$vm = Add-AzureRmVMDataDisk -VM $vm -Name $dataDiskName2 -Caching 'ReadOnly' -DiskSizeInGB 20 -Lun 1 -VhdUri $DataDiskVhdUri02 -CreateOption Empty
$vm = Add-AzureRmVMDataDisk -VM $vm -Name $dataDiskName3 -Caching 'ReadOnly' -DiskSizeInGB 30 -Lun 2 -VhdUri $DataDiskVhdUri03 -CreateOption Empty



# TO  check all the setting before deployment 
$vm

<#
StatusCode                 : 0
Name                       : myvm1
AvailabilitySetReference   : 
  Id                       : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/mygroup2/providers/Microsoft.Compute/availabilitySets/AvailabilitySet01
HardwareProfile            : 
  VmSize                   : Standard_A1
NetworkProfile             : 
  NetworkInterfaces[0]     : 
    Id                     : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/mygroup2/providers/Microsoft.Network/networkInterfaces/mynic1
OSProfile                  : 
  ComputerName             : myvm1
  AdminUsername            : youaretheadmin
  AdminPassword            : Pa$$word$1
  WindowsConfiguration     : 
    ProvisionVMAgent       : True
    EnableAutomaticUpdates : True
StorageProfile             : 
  ImageReference           : 
    Publisher              : MicrosoftWindowsServer
    Offer                  : WindowsServer
    Sku                    : 2012-R2-Datacenter
    Version                : latest
  OsDisk                   : 
    Name                   : myvm1_osDisk
    Vhd                    : 
      Uri                  : https://mystorageaccountft1.blob.core.windows.net/vhds/myvm1_os.vhd
    CreateOption           : FromImage
NetworkInterfaceIDs[0]     : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/mygroup2/providers/Microsoft.Network/networkInterfaces/mynic1

#>

### Deploy the VM 
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm -Verbose -Debug

