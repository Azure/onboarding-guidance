# DeployCapturedVM
## Deploy a new VM from the captured image into exiting infrastructure 

[Microsoft Official Article] - [Click Here]()
# (Resource Group/ VNET/Subnet/Avilibity Set/Storage Account)
Using Exiting VNET :

Verify Existing details :
```
Find-AzureRmResource -ResourceGroupNameContains "myGroup"
```
# DeployCapturedVM
### Deploy a new VM from the captured image into exiting infrastructure (Resource Group/ VNET/Subnet/AvailabilitySet/Storage Account)

Original Article :[Click Here](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-capture-image/#deploy-a-new-vm-from-the-captured-image)

#### ====================== Details of Existing Resource ============
```
$subnetName = "mysubnet1"
$vnetName = "myvnet1"
$rgName = "mygroup2"
$locName = "centralus"
$stName = "mystorageaccountft"
```
#### =====================================

#### Get information regarding Storage Account
```
$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName
```
#### Get information regarding Virtual Network
```
$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName
```
#### Need to create a new IP Address
```
$ipName = "myIPaddress2"
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
```
#### Need to create a new Network Interface
```
$nicName = "mynic2"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
```
#### Get existing Availibity Set details
```
$AvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name "AvailabilitySet01"
```

#### location of captured image
```
$urlOfCapturedImageVhd= "https://mystorageaccountft.blob.core.windows.net/system/Microsoft.Compute/Images/image/customimage-osDisk.7e5505ce-57c5-4cbb-a881-258a60b5c2df.vhd"
```

#### --------------------
#### Setup Credentials
```
$user = "youaretheadmin"
$password = 'Pa$$word$1'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)
```


#### Basic VM configuration
```
$vmName = "myvm2"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_A1" -AvailabilitySetID $AvailabilitySet.Id
```
#### OS and access configuration
```
$compName = "myvm2"
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $compName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
```

```
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
```
#### OS Disk setting
```
$blobPath = "vhds/"+$vmname+"_os.vhd"
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $blobPath

$osdiskName = $vmname+'_osDisk'
```

```
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osdiskName -VhdUri $osDiskUri -CreateOption fromImage -SourceImageUri $urlOfCapturedImageVhd -Windows
```
#### Create the new VM
```
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm -Verbose -Debug

```
