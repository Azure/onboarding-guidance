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
az login

#### List all the accounts that you have access .
az account list

#### Set default account for the session
az account set -s XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
az account show

For this example:
ResourceGroup Name: MyCLI-RG
VM Name: TestVM1

# Deallocate the VM
az vm deallocate -n TestVM1 -g MyCLI-RG

# Verify Status of VM
az vm list -g MyCLI-RG -d
```
[
  {
    "availabilitySet": {
      "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/availabilitySets/TESTCLI-AS",
      "resourceGroup": "MyCLI-RG"
    },
    "diagnosticsProfile": null,
    "fqdns": "",
    "hardwareProfile": {
      "vmSize": "Standard_A0"
    },
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/virtualMachines/TestVM1",
    "licenseType": null,
    "location": "westus",
    "macAddresses": "",
    "name": "TestVM1",
    "networkProfile": {
      "networkInterfaces": [
        {
          "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Network/networkInterfaces/TestVM1-NIC1",
          "primary": true,
          "resourceGroup": "MyCLI-RG"
        }
      ]
    },
    "osProfile": {
      "adminPassword": null,
      "adminUsername": "corpadmin",
      "computerName": "TestVM1",
      "customData": null,
      "linuxConfiguration": {
        "disablePasswordAuthentication": false,
        "ssh": null
      },
      "secrets": [],
      "windowsConfiguration": null
    },
    "plan": null,
    "powerState": "VM deallocated",
    "privateIps": "192.168.0.4",
    "provisioningState": "Succeeded",
    "publicIps": "",
    "resourceGroup": "MyCLI-RG",
    "resources": null,
    "storageProfile": {
      "dataDisks": [],
      "imageReference": {
        "id": null,
        "offer": "UbuntuServer",
        "publisher": "Canonical",
        "sku": "17.04",
        "version": "latest"
      },
      "osDisk": {
        "caching": "ReadWrite",
        "createOption": "fromImage",
        "diskSizeGb": null,
        "encryptionSettings": null,
        "image": null,
        "managedDisk": null,
        "name": "osdisk_Vo9rrPt5cP",
        "osType": "Linux",
        "vhd": {
          "uri": "https://computeteststorecli2.blob.core.windows.net/vhds/osdisk_Vo9rrPt5cP.vhd"
        }
      }
    },
    "tags": {},
    "type": "Microsoft.Compute/virtualMachines",
    "vmId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX"
  }
]
```

#Generalize the VM
az vm generalize -n TestVM1 -g MyCLI-RG

# capture the image and a local file template
az image create -n TestVMImage -g MyCLI-RG --source TestVM1
```
{| Finished ..
  "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/images/TestVMImage",
  "location": "westus",
  "name": "TestVMImage",
  "provisioningState": "Succeeded",
  "resourceGroup": "MyCLI-RG",
  "sourceVirtualMachine": {
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/virtualMachines/TestVM1",
    "resourceGroup": "MyCLI-RG"
  },
  "storageProfile": {
    "dataDisks": [],
    "osDisk": {
      "blobUri": "https://computeteststorecli2.blob.core.windows.net/vhds/osdisk_Vo9rrPt5cP.vhd",
      "caching": "ReadWrite",
      "diskSizeGb": null,
      "managedDisk": null,
      "osState": "Generalized",
      "osType": "Linux",
      "snapshot": null
    }
  },
  "tags": null,
  "type": "Microsoft.Compute/images"
}
```

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/capture-image