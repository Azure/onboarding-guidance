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
```
[
  {
    "accessTier": null,
    "creationTime": "2016-01-27T11:58:40.547599+00:00",
    "customDomain": null,
    "encryption": null,
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/securitydata/providers/Microsoft.Storage/storageAccounts/demostorageaccount01",
    "kind": "Storage",
    "lastGeoFailoverTime": null,
    "location": "eastus",
    "name": "demostorageaccount01",
    "primaryEndpoints": {
      "blob": "https://demostorageaccount01.blob.core.windows.net/",
      "file": "https://demostorageaccount01.file.core.windows.net/",
      "queue": "https://demostorageaccount01.queue.core.windows.net/",
      "table": "https://demostorageaccount01.table.core.windows.net/"
    },
    "primaryLocation": "eastus",
    "provisioningState": "Succeeded",
    "resourceGroup": "securitydata",
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
]
```

First we need to create a ResourceGroup or select an existing ResourceGroup.
In this case we will use ResourceGroup created in previous lesson.

#### Check whether the account name is valid and is not in use
Important: The name of the storage account must be unique in Azure. It must be lowercase, too!

az storage account check-name --name teststorageft --verbose

az storage account check-name --name teststorageft -o table


### Create a Standard Storage Account
az storage account create -n teststorageft01 -g MyCLI-RG --sku Standard_LRS -l westus

### Create a Premium Storage Account
az storage account create -n teststorageft02 -g MyCLI-RG --sku Premium_LRS -l westus

### Delete the Standard Storage Account
az storage account delete -n teststorageft01 -g MyCLI-RG

### Delete the Premium Storage Account
az storage account delete -n teststorageft02 -g MyCLI-RG