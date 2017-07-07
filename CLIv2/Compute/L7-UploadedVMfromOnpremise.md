Requirements :- [Image Format RequirmentHere](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-upload-vhd/#requirements)

[Prepare the image to be uploaded](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/upload-vhd#prepare-the-image-to-be-uploaded)


Step 2 : Capture the VM

#### To login to your Azure Subscription
az login

#### List all the accounts that you have access .
az account list

#### Set default account for the session
az account set -s XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
az account show

#### Create a resource group or use an existing ResourceGroup
azure group create TestRG --location "WestUS"

#### Create a storage account or use an existing storage account
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

#### List storage account keys
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

#### Create a storage container
az storage container create -n vm-images --account-name computeteststorecli2

#### Upload VHD
az storage blob upload --container-name vm-images --file C:\vms\myvmtoupload.vhd --name VMFromOnPrem.vhd --type page --account-name computeteststorecli2

Additional documentation: https://docs.microsoft.com/en-us/azure/storage/storage-azure-cli#azure-cli-20-sample-script