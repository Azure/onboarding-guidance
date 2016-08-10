# How to capture a Windows virtual machine in the Resource Manager deployment model

[Microsoft Official Article] - [Click Here](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-capture-image/)

### Prepare the VM for image capture
* Sign in to your Windows virtual machine. In the Azure portal, navigate through Browse > Virtual machines > Your Windows virtual machine > Connect.

* Open a Command Prompt window as an administrator.

* Change the directory to %windir%\system32\sysprep, and then run sysprep.exe.

* In the System Preparation Tool dialog box, do the following:

   * ###### In System Cleanup Action, select Enter System Out-of-Box Experience (OOBE) and make sure that Generalize is checked.

  * ###### In Shutdown Options, select Shutdown.

* Click OK.

## Capture the VM using PowerShell


Login-AzureRmAccount

#### Verify Machine exists
```PowerShell
Get-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1
```
#### Verify status of the machine where
```PowerShell
## Code: PowerState/stopped
## DisplayStatus : VM Stopped

$vm = Get-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1 -status
$vm.Statuses
```

#### Now you will need to deallocate the resources that are used by this virtual machine
```PowerShell
Stop-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1 -Verbose
```
#### Again Verify status of the machine where
```PowerShell
## Code : PowerState/deallocated
## DisplayStatus : VM deallocated

$vm = Get-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1 -status
$vm.Statuses
```
#### Set the status of the virtual machine to Generalized.
* Note that you will need to do this because the generalization step above (sysprep) does not do it in a way that Azure can understand.
```PowerShell
Set-AzureRmVm -ResourceGroupName MYGROUP2 -Name myvm1 -Generalized
```
* Note: The generalized state as set above will not be shown on the portal. However, you can verify it by using the Get-AzureRmVM command.

#### Again Verify status of the machine showing
```PowerShell
## Code : OSState/generalized
## DisplayStatus : VM generalized

$vm = Get-AzureRmVM -ResourceGroupName MYGROUP2 -Name myvm1 -status
$vm.Statuses

<# Output
Code          : OSState/generalized
Level         : Info
DisplayStatus : VM generalized
Message       :
Time          :
#>
```
#### Capture the virtual machine image to a destination storage container
```PowerShell
Save-AzureRmVMImage -ResourceGroupName MYGROUP2 -Name myvm1 -DestinationContainerName myimage -VHDNamePrefix customimage -Path C:\Users\user1\Documents\temp\customimage.json -Verbose

```
Location of VHD of the image :
https://mystorageaccountft.blob.core.windows.net/system/Microsoft.Compute/Images/image/customimage-osDisk.7e5505ce-57c5-4cbb-a881-258a60b5c2df.vhd


#### Verify Creation of Image
```PowerShell
Get-AzureRmStorageAccount | Get-AzureStorageContainer| Get-AzureStorageBlob |select Name

<# output
Microsoft.Compute/Images/image/customimage-osDisk.7e5505ce-57c5-4cbb-a881-258a60b5c2df.vhd
Microsoft.Compute/Images/image/customimage-vmTemplate.7e5505ce-57c5-4cbb-a881-258a60b5c2df.json
myvm1.7e5505ce-57c5-4cbb-a881-258a60b5c2df.status
myvm1_os.vhd
#>
```
