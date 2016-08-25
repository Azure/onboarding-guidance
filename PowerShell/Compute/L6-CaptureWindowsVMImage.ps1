# How to capture a Windows virtual machine in the Resource Manager deployment model

# https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-capture-image/



Login-AzureRmAccount

# Verify Machine exists

Get-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1

# Verify status of the machine where 
    ## Code: PowerState/stopped 
    ## DisplayStatus : VM Stopped 
$vm = Get-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1 -status
$vm.Statuses



#Now you will need to deallocate the resources that are used by this virtual machine 
Stop-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1 -Verbose

#Again Verify status of the machine where
    ## Code : PowerState/deallocated 
    ## DisplayStatus : VM deallocated

$vm = Get-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1 -status
$vm.Statuses

#set the status of the virtual machine to Generalized. 
# Note that you will need to do this because the generalization step above (sysprep) does not do it in a way that Azure can understand.

Set-AzureRmVm -ResourceGroupName MYGROUP2 -Name myvm1 -Generalized

# Note: The generalized state as set above will not be shown on the portal. However, you can verify it by using the Get-AzureRmVM command.


#Again Verify status of the machine showing 
    ## Code : OSState/generalized 
    ## DisplayStatus : VM generalized

$vm = Get-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1 -status
$vm.Statuses

<#
Code          : OSState/generalized
Level         : Info
DisplayStatus : VM generalized
Message       : 
Time          : 
#>


#### Capture the virtual machine image to a destination storage container


Save-AzureRmVMImage -ResourceGroupName MYGROUP2 -Name myvm1 -DestinationContainerName image -VHDNamePrefix customimage -Path C:\Users\abhanand\Documents\temp\customimage.json -Verbose


#### Verify Creation of Image 

Get-AzureRmStorageAccount |Get-AzureStorageContainer|Get-AzureStorageBlob |select Name

<#
Name
----
Microsoft.Compute/Images/image/customimage-osDisk.7e5505ce-57c5-4cbb-a881-258a60b5c2df.vhd
Microsoft.Compute/Images/image/customimage-vmTemplate.7e5505ce-57c5-4cbb-a881-258a60b5c2df.json
myvm1.7e5505ce-57c5-4cbb-a881-258a60b5c2df.status
myvm1_os.vhd
#>
