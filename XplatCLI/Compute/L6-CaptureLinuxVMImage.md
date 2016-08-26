

Prerequisite:

1. A Linux Virtual machine on Azure Infrastructure


Below steps have been tested on Canonical:UbuntuServer:16.04.0-LTS:latest

##### Step 1:  We will generalize Linux image
1. When you are ready to capture the VM, connect to it using your SSH client.

2. In the SSH window, type the following command.

This command attempts to clean the system and make it suitable for reprovisioning. This operation performs the following tasks:

* Removes SSH host keys (if Provisioning.RegenerateSshHostKeyPair is 'y' in the configuration file)
* Clears nameserver configuration in /etc/resolvconf
* Removes the root user's password from /etc/shadow (if Provisioning.DeleteRootPassword is 'y' in the configuration file)
* Removes cached DHCP client leases
* Resets host name to localhost.localdomain
* Deletes the last provisioned user account (obtained from /var/lib/waagent) and associated data.
Note:
Deprovisioning deletes files and data to generalize the image. Only run this command on a VM that you intend to capture as an image. It does not guarantee that the image is cleared of all sensitive information or is suitable for redistribution to third parties.

The output from waagent may vary slightly depending on the version of this utility:
```
sudo waagent -deprovision+user

user1@TestVM1:~$ sudo waagent -deprovision+user
WARNING! The waagent service will be stopped.
WARNING! Cached DHCP leases will be deleted.
WARNING! root password will be disabled. You will not be able to login as root.
WARNING! user1 account and entire home directory will be deleted.
WARNING! Nameserver configuration in /etc/resolvconf/resolv.conf.d/{tail,originial} will be deleted.
Do you want to proceed (y/n)y
2016/08/22 01:34:17.719118 INFO resolvconf is enabled; leaving /etc/resolv.conf intact

```


3. Type y to continue. You can add the -force parameter to avoid this confirmation step.

4. Type exit to close the SSH client.



Step 2 : Capture the VM

#### To login to your Azure Subscription
azure login

#### List all the accounts that you have access .
azure account list

#### Set default account for the session
azure account set XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
azure account show

#### Change Mode to arm
azure config mode arm

For this example  :

ResourceGroup Name :TestRGcli
VM Name  :TestVM1

# Deallocate the VM
azure vm deallocate -g TestRGcli -n TestVM1 -v

# Verify Status of VM
azure vm list -g TestRGcli
info:    Executing command vm list
+ Getting virtual machines
data:    ResourceGroupName  Name     ProvisioningState  PowerState      Location    Size
data:    -----------------  -------  -----------------  --------------  ----------  -----------
data:    TestRGcli          TestVM1  Succeeded          VM deallocated  westeurope  Standard_A0
info:    vm list command OK

#Generalize the VM
azure vm generalize -g TestRGcli -n TestVM1 -v

# capture the image and a local file template
azure vm capture -g TestRGcli -n TestVM1 -p customubuntuimage -t C:\Users\user1\Documents\temp\customimage.json -vv

Tip:
To find the location of an image, open the JSON file template. In the storageProfile, find the uri of the image located in the system container. For example, the uri of the OS disk image is similar to

"https://computeteststorecli.blob.core.windows.net/system/Microsoft.Compute/Images/vhds/customubuntuimage-osDisk.af3a619a-d9de-4f3b-bacb-3f8a87bb6d80.vhd"


https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-capture-image/
