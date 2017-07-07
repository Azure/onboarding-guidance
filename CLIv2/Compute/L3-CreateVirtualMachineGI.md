#### To login to your Azure Subscription
az login

#### List all the accounts that you have access .
az account list

#### Set default account for the session
az account set -s XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
az account show

#### To see Locations that can be accessed in your current subscriptions
```shell
az account list-locations
```

### Prerequisite - Quick Create
1. ResourceGroup
2. SSH Client - for testing purpose


#### Verify available  virtual machine sizes available in the location
```shell
az vm list-sizes -l westus

[
  {
    "maxDataDiskCount": 2,
    "memoryInMb": 3584,
    "name": "Standard_DS1_v2",
    "numberOfCores": 1,
    "osDiskSizeInMb": 1047552,
    "resourceDiskSizeInMb": 7168
  },
  # ...
  # Many other VM sizes
  # ...
  {
    "maxDataDiskCount": 32,
    "memoryInMb": 229376,
    "name": "Standard_H16mr",
    "numberOfCores": 16,
    "osDiskSizeInMb": 1047552,
    "resourceDiskSizeInMb": 2048000
  }
]
```
# Detailed VM Creation :

#### Create the resource group:
az group create -l westus -n MyCLI-RG

#### Verify the resource group
az group show -n MyCLI-RG

#### Create two storage account: one for OS VHD and another one for BootDiagnostics

#### Check availability of the storage account:
az storage account check-name --name computeteststorecli2
```
{
  "message": null,
  "nameAvailable": true,
  "reason": null
}
```

#### Create the storage account:
az storage account create -n computeteststorecli2 -g MyCLI-RG --sku Standard_LRS -l westus
```
{- Finished ..
  "accessTier": null,
  "creationTime": "2017-06-09T20:32:59.754402+00:00",
  "customDomain": null,
  "encryption": null,
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/mycli-rg/providers/Microsoft.Storage/storageAccounts/computeteststorecli2",
  "kind": "Storage",
  "lastGeoFailoverTime": null,
  "location": "westus",
  "name": "computeteststorecli2",
  "primaryEndpoints": {
    "blob": "https://computeteststorecli2.blob.core.windows.net/",
    "file": "https://computeteststorecli2.file.core.windows.net/",
    "queue": "https://computeteststorecli2.queue.core.windows.net/",
    "table": "https://computeteststorecli2.table.core.windows.net/"
  },
  "primaryLocation": "westus",
  "provisioningState": "Succeeded",
  "resourceGroup": "mycli-rg",
  "secondaryEndpoints": null,
  "secondaryLocation": null,
  "sku": {
    "name": "Standard_LRS",
    "tier": "Standard"
  },
  "statusOfPrimary": "available",
  "statusOfSecondary": null,
  "tags": {},
  "type": "Microsoft.Storage/storageAccounts"
}
```


#### Verify the storage account
az storage account show -n computeteststorecli2 -g MyCLI-RG

#### (Optional) List storage account keys
az storage account keys list -n computeteststorecli2 -g MyCLI-RG
```
[
  {
    "keyName": "key1",
    "permissions": "Full",
    "value": "xxxxxxxxxxxxxxxxxQuI48tC8blupxFlz+pg1Tk/aOUM2lQlja3hSFNNMYScdLZKlh2VLUgUuzHFj1aRz2Pz0Q=="
  },
  {
    "keyName": "key2",
    "permissions": "Full",
    "value": "xxxxxxxxxxxxxxxxxe1BNVLQkt74wFNyc/AAPESMEVZ0e26F1j9axMXGwUb1W0qDaEUME8GxzmLV7Sx9UID1jw=="
  }
]
```

#### (Optional) Create a storage container
az storage container create -n vmdisks --account-name computeteststorecli2
```
{
  "created": true
}
```

#### Create the virtual network:
az network vnet create -n TestCLI-VNET -g MyCLI-RG --address-prefixes 192.168.0.0/16 -l westus
```
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [
        "192.168.0.0/16"
      ]
    },
    "dhcpOptions": {
      "dnsServers": []
    },
    "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"",
    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestCLI-VNET",
    "location": "westus",
    "name": "TestCLI-VNET",
    "provisioningState": "Succeeded",
    "resourceGroup": "MyCLI-RG",
    "resourceGuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "subnets": [],
    "tags": {},
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}
```

#### Create the subnet:
az network vnet subnet create --address-prefix 192.168.0.0/24 -n Servers-Subnet -g MyCLI-RG --vnet-name TestCLI-VNET
```
{- Finished ..
  "addressPrefix": "192.168.0.0/24",
  "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"",
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestCLI-VNET/subnets/Servers-Subnet",
  "ipConfigurations": null,
  "name": "Servers-Subnet",
  "networkSecurityGroup": null,
  "provisioningState": "Succeeded",
  "resourceGroup": "MyCLI-RG",
  "resourceNavigationLinks": null,
  "routeTable": null
}
```

#### Verify the virtual network and subnet
az network vnet show -n TestCLI-VNET -g MyCLI-RG
```
{
  "addressSpace": {
    "addressPrefixes": [
      "192.168.0.0/16"
    ]
  },
  "dhcpOptions": {
    "dnsServers": []
  },
  "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"",
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestCLI-VNET",
  "location": "westus",
  "name": "TestCLI-VNET",
  "provisioningState": "Succeeded",
  "resourceGroup": "MyCLI-RG",
  "resourceGuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "subnets": [
    {
      "addressPrefix": "192.168.0.0/24",
      "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"",
      "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestCLI-VNET/subnets/Servers-Subnet",
      "ipConfigurations": null,
      "name": "Servers-Subnet",
      "networkSecurityGroup": null,
      "provisioningState": "Succeeded",
      "resourceGroup": "MyCLI-RG",
      "resourceNavigationLinks": null,
      "routeTable": null
    }
  ],
  "tags": {},
  "type": "Microsoft.Network/virtualNetworks",
  "virtualNetworkPeerings": []
}
```

#### Create a public IP:
az network public-ip create -n TestVM1-PIP -g MyCLI-RG --allocation-method Dynamic -l westus
```
{
  "publicIp": {
    "dnsSettings": null,
    "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"",
    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/publicIPAddresses/TestVM1-PIP",
    "idleTimeoutInMinutes": 4,
    "ipAddress": null,
    "ipConfiguration": null,
    "location": "westus",
    "name": "TestVM1-PIP",
    "provisioningState": "Succeeded",
    "publicIpAddressVersion": "IPv4",
    "publicIpAllocationMethod": "Dynamic",
    "resourceGroup": "MyCLI-RG",
    "resourceGuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "tags": null,
    "type": "Microsoft.Network/publicIPAddresses"
  }
}
```

#### Create the first network interface card (NIC):
az network nic create -n TestVM1-NIC1 -g MyCLI-RG --vnet-name TestCLI-VNET --subnet Servers-Subnet --public-ip-address TestVM1-PIP -l westus
```
{
  "NewNIC": {
    "dnsSettings": {
      "appliedDnsServers": [],
      "dnsServers": [],
      "internalDnsNameLabel": null,
      "internalDomainNameSuffix": "xxxxxxxxxxxx5jniujye210f4a.dx.internal.cloudapp.net",
      "internalFqdn": null
    },
    "enableAcceleratedNetworking": false,
    "enableIpForwarding": false,
    "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx\"",
    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/networkInterfaces/TestVM1-NIC1",
    "ipConfigurations": [
      {
        "applicationGatewayBackendAddressPools": null,
        "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx\"",
        "id": "/subscriptions/7xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/networkInterfaces/TestVM1-NIC1/ipConfigurations/ipconfig1",
        "loadBalancerBackendAddressPools": null,
        "loadBalancerInboundNatRules": null,
        "name": "ipconfig1",
        "primary": true,
        "privateIpAddress": "192.168.0.4",
        "privateIpAddressVersion": "IPv4",
        "privateIpAllocationMethod": "Dynamic",
        "provisioningState": "Succeeded",
        "publicIpAddress": {
          "dnsSettings": null,
          "etag": null,
          "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/publicIPAddresses/TestVM1-PIP",
          "idleTimeoutInMinutes": null,
          "ipAddress": null,
          "ipConfiguration": null,
          "location": null,
          "name": null,
          "provisioningState": null,
          "publicIpAddressVersion": null,
          "publicIpAllocationMethod": null,
          "resourceGroup": "MyCLI-RG",
          "resourceGuid": null,
          "tags": null,
          "type": null
        },
        "resourceGroup": "MyCLI-RG",
        "subnet": {
          "addressPrefix": null,
          "etag": null,
          "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestCLI-VNET/subnets/Servers-Subnet",
          "ipConfigurations": null,
          "name": null,
          "networkSecurityGroup": null,
          "provisioningState": null,
          "resourceGroup": "MyCLI-RG",
          "resourceNavigationLinks": null,
          "routeTable": null
        }
      }
    ],
    "location": "westus",
    "macAddress": null,
    "name": "TestVM1-NIC1",
    "networkSecurityGroup": null,
    "primary": null,
    "provisioningState": "Succeeded",
    "resourceGroup": "MyCLI-RG",
    "resourceGuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx",
    "tags": null,
    "type": "Microsoft.Network/networkInterfaces",
    "virtualMachine": null
  }
}
```

#### Verify the NIC
az network nic show -n TestVM1-NIC1 -g MyCLI-RG

#### Create the availability set:
az vm availability-set create -n TestCLI-AS -g MyCLI-RG -l westus --unmanaged
```
{/ Finished ..
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/availabilitySets/TestCLI-AS",
  "location": "westus",
  "managed": null,
  "name": "TestCLI-AS",
  "platformFaultDomainCount": 2,
  "platformUpdateDomainCount": 5,
  "resourceGroup": "MyCLI-RG",
  "sku": {
    "capacity": null,
    "managed": false,
    "tier": null
  },
  "statuses": null,
  "tags": {},
  "type": "Microsoft.Compute/availabilitySets",
  "virtualMachines": []
}
```

#### Create a Windows VM:
az vm create -n TestVM1 -g MyCLI-RG --availability-set TestCLI-AS --image MicrosoftWindowsServer:WindowsServer:2016-Datacenter:latest -l westus --size Standard_A0 --admin-username corpadmin --admin-password MySuperSecretPassword123 --nics TestVM1-NIC1 --storage-account computeteststorecli2 --use-unmanaged-disk
```
{- Finished ..
  "fqdns": "",
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/virtualMachines/TestVM1",
  "location": "westus",
  "macAddress": "00-0D-3A-36-1E-A9",
  "powerState": "VM running",
  "privateIpAddress": "192.168.0.4",
  "publicIpAddress": "XXX.XXX.XXX.XXX",
  "resourceGroup": "MyCLI-RG"
}
```

#### Create a Linux VM:
az vm create -n TestVM1 -g MyCLI-RG --availability-set TestCLI-AS --image Canonical:UbuntuServer:17.04:latest -l westus --size Standard_A0 --admin-username corpadmin --admin-password MySuperSecretPassword123 --authentication-type password --nics TestVM1-NIC1 --storage-account computeteststorecli2 --use-unmanaged-disk
```
{- Finished ..
  "fqdns": "",
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/virtualMachines/TestVM1",
  "location": "westus",
  "macAddress": "00-0D-3A-36-1E-A9",
  "powerState": "VM running",
  "privateIpAddress": "192.168.0.4",
  "publicIpAddress": "XXX.XXX.XXX.XXX",
  "resourceGroup": "MyCLI-RG"
}
```