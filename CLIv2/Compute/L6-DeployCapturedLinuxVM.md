Deploy a new VM from the captured image into exiting infrastructure
(Resource Group/VNET/Subnet/Availability Set/Storage Account)
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/capture-image#step-3-create-a-vm-from-the-captured-image

#### To login to your Azure Subscription
az login

#### List all the accounts that you have access .
az account list

#### Set default account for the session
az account set -s XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
az account show

#### Create a public IP:
az network public-ip create -n TestVM2-PIP -g MyCLI-RG --allocation-method Dynamic -l westus
```
{
  "publicIp": {
    "dnsSettings": null,
    "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"",
    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/publicIPAddresses/TestVM2-PIP",
    "idleTimeoutInMinutes": 4,
    "ipAddress": null,
    "ipConfiguration": null,
    "location": "westus",
    "name": "TestVM2-PIP",
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
az network nic create -n TestVM2-NIC1 -g MyCLI-RG --vnet-name TestCLI-VNET --subnet Servers-Subnet --public-ip-address TestVM2-PIP -l westus
```
{
  "NewNIC": {
    "dnsSettings": {
      "appliedDnsServers": [],
      "dnsServers": [],
      "internalDnsNameLabel": null,
      "internalDomainNameSuffix": "xxxxxxxxxxxxxxxxxxxxxxxxxx.dx.internal.cloudapp.net",
      "internalFqdn": null
    },
    "enableAcceleratedNetworking": false,
    "enableIpForwarding": false,
    "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"",
    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/networkInterfaces/TestVM2-NIC1",
    "ipConfigurations": [
      {
        "applicationGatewayBackendAddressPools": null,
        "etag": "W/\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"",
        "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/networkInterfaces/TestVM2-NIC1/ipConfigurations/ipconfig1",
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
          "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/publicIPAddresses/TestVM2-PIP",
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
          "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestCLI-VNET/subnets/Servers-Subnet",
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
    "name": "TestVM2-NIC1",
    "networkSecurityGroup": null,
    "primary": true,
    "provisioningState": "Succeeded",
    "resourceGroup": "MyCLI-RG",
    "resourceGuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "tags": null,
    "type": "Microsoft.Network/networkInterfaces",
    "virtualMachine": {
      "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/virtualMachines/TestVM2",
      "resourceGroup": "MyCLI-RG"
    }
  }
}
```

#### Verify the NIC
az network nic show -n TestVM2-NIC1 -g MyCLI-RG

#### Deploy VM from Image
az vm create -n TestVM2 -g MyCLI-RG --image "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyCLI-RG/providers/Microsoft.Compute/images/TestVMImage" -l westus --size Standard_DS1_v2 --admin-username corpadmin --admin-password MySuperSecretPassword123 --authentication-type password --nics TestVM2-NIC1