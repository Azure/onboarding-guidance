# Module:- Capture a Windows VM as an Image on Azure

# Abstract

During this module, you will learn how to Capture a windows VM as an Image on Azure.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Prepare the VM for image capture
* Capture the VM using PowerShell
* Generalize a virtual machine

# Prerequisite
* Completion of [Module on Storage](https://github.com/Azure/onboarding-guidance/tree/master/windows/Module%20I)

# Estimated time to complete this module:
30 min

# How do I create a VM image from an existing Azure VM
Using Azure PowerShell create a generalized image of an existing Azure VM. You can then use the image to create another VM. This image includes the OS disk and the data disks that are attached to the virtual machine. The image doesn't include the virtual network resources, so you need to set up those resources when you create a VM using the image.

# How to capture a Windows virtual machine in the Resource Manager deployment model

### Prepare the VM for image capture
* Sign in to your Windows virtual machine. In the Azure portal, navigate through Browse > Virtual machines > Your Windows virtual machine > Connect.

* Open a Command Prompt window as an administrator.

* Change the directory to %windir%\system32\sysprep, and then run sysprep.exe.

* In the System Preparation Tool dialog box, do the following:

   * ###### In System Cleanup Action, select Enter System Out-of-Box Experience (OOBE) and make sure that Generalize is checked.

  * ###### In Shutdown Options, select Shutdown.

* Click OK.

## Now you have to Capture the VM using PowerShell
