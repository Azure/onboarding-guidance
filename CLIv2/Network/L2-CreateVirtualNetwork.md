#### To login to your Azure Subscription
az login

#### List all the accounts that you have access .
az account list

#### Set default account for the session
az account set -s XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
az account show

#### List all the account that exists in the Subscription (if any)
az storage account list

#### To see Locations that can be accessed in your current subscriptions
```shell
az account list-locations
```

#### Create the resource group:
az group create -l westus -n MyCLI-RG

#### Verify the resource group
az group show -n MyCLI-RG

#### Create a VNet  
az network vnet create -n TestVNET -g MyCLI-RG -l westus --address-prefixes 192.168.0.0/16
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
    "etag": "W/\"631897ba-0480-44ef-84b1-d1453eb9ea6e\"",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestVNET",
    "location": "westus",
    "name": "TestVNET",
    "provisioningState": "Succeeded",
    "resourceGroup": "MyCLI-RG",
    "resourceGuid": "8948a17e-1bf6-4895-98b8-1a22fdd35f24",
    "subnets": [],
    "tags": {},
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}
```

#### Create a Subnet
az network vnet subnet create -n FrontEnd --vnet-name TestVNET -g MyCLI-RG --address-prefix 192.168.0.0/24
```
{\ Finished ..
  "addressPrefix": "192.168.0.0/24",
  "etag": "W/\"b803e5a2-9902-4ec4-8c2b-0e4954890b96\"",
  "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestVNET/subnets/FrontEnd",
  "ipConfigurations": null,
  "name": "FrontEnd",
  "networkSecurityGroup": null,
  "provisioningState": "Succeeded",
  "resourceGroup": "MyCLI-RG",
  "resourceNavigationLinks": null,
  "routeTable": null
}
```

#### (optional) Create an additional Subnet
az network vnet subnet create -n BackEnd --vnet-name TestVNET -g MyCLI-RG --address-prefix 192.168.1.0/24

#### To view the properties of the new vnet
az network vnet show -n TestVNet -g MyCLI-RG
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
  "etag": "W/\"6576cf45-26e9-4aa9-979a-de5105d6ff90\"",
  "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestVNET",
  "location": "westus",
  "name": "TestVNET",
  "provisioningState": "Succeeded",
  "resourceGroup": "MyCLI-RG",
  "resourceGuid": "8948a17e-1bf6-4895-98b8-1a22fdd35f24",
  "subnets": [
    {
      "addressPrefix": "192.168.0.0/24",
      "etag": "W/\"6576cf45-26e9-4aa9-979a-de5105d6ff90\"",
      "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestVNET/subnets/FrontEnd",
      "ipConfigurations": null,
      "name": "FrontEnd",
      "networkSecurityGroup": null,
      "provisioningState": "Succeeded",
      "resourceGroup": "MyCLI-RG",
      "resourceNavigationLinks": null,
      "routeTable": null
    },
    {
      "addressPrefix": "192.168.1.0/24",
      "etag": "W/\"6576cf45-26e9-4aa9-979a-de5105d6ff90\"",
      "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/MyCLI-RG/providers/Microsoft.Network/virtualNetworks/TestVNET/subnets/BackEnd",
      "ipConfigurations": null,
      "name": "BackEnd",
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