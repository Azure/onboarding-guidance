# Add a data disk to an existing virtual machine 

    PS C:\>$VirtualMachine = Get-AzureRmVM -ResourceGroupName "ResourceGroup11" -Name "VirtualMachine07"
    PS C:\> Add-AzureRmVMDataDisk -VM $VirtualMachine -Name "disk1" -VhdUri "https://contoso.blob.core.windows.net/vhds/diskstandard03.vhd" -LUN 0 -Caching ReadOnly 
    -DiskSizeinGB 1 -CreateOption Empty
    PS C:\> Update-AzureRmVM -ResourceGroupName "ResourceGroup11" -Name "VirtualMachine07" -VM $VirtualMachine
    
    The first command gets the virtual machine named VirtualMachine07 by using the Get-AzureRmVM cmdlet. The command stores the virtual machine in the $VirtualMachine 
    variable.