
Login-AzureRmAccount

# Get the desired VM 

$VMname = 'myvm1'
$rgname = 'mygroup2'
$stName = 'mystorageaccountft1'

$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName
$VirtualMachine = Get-AzureRmVM -ResourceGroupName $rgname -Name $VMname

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



Add-AzureRmVMDataDisk -VM $VirtualMachine -Name $dataDiskName1 -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 0 -VhdUri $DataDiskVhdUri01 -CreateOption Empty
# Add-AzureRmVMDataDisk -VM $VirtualMachine -Name "disk1" -VhdUri "https://contoso.blob.core.windows.net/vhds/diskstandard03.vhd" -LUN 0 -Caching ReadOnly -DiskSizeinGB 1 -CreateOption Empty
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name $dataDiskName2 -Caching 'ReadOnly' -DiskSizeInGB 20 -Lun 1 -VhdUri $DataDiskVhdUri02 -CreateOption Empty
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name $dataDiskName3 -Caching 'ReadOnly' -DiskSizeInGB 30 -Lun 2 -VhdUri $DataDiskVhdUri03 -CreateOption Empty

# Updates the state of an Azure virtual machine.
Update-AzureRmVM -ResourceGroupName $rgname -VM $VirtualMachine

# ==================== Add a existing Disk to an exitsing VM ====================

# Get the desired VM 

$VMname = 'myvm1'
$rgname = 'mygroup3'

$VirtualMachine = Get-AzureRmVM -ResourceGroupName $rgname -Name $VMname

# Location and Names alreay exist 
$DataDiskVhdUri01 = "https://mystorageaccountft1.blob.core.windows.net/vhds/myvm1_data1.vhd"
$DataDiskVhdUri02 = "https://mystorageaccountft1.blob.core.windows.net/vhds/myvm1_data2.vhd"

Add-AzureRmVMDataDisk -VM $VirtualMachine -Name $dataDiskName1 -Lun 0 -VhdUri $DataDiskVhdUri01 -DiskSizeInGB $null -CreateOption Attach
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name $dataDiskName2 -Lun 1 -VhdUri $DataDiskVhdUri02 -DiskSizeInGB $null -CreateOption Attach


# Updates the state of an Azure virtual machine.
Update-AzureRmVM -ResourceGroupName $rgname -VM $VirtualMachine

    

