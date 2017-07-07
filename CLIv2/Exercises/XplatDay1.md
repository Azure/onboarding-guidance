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

#### Create the resource group:
az group create -l westus -n MyCLI-RG

#### Verify the resource group
az group show -n MyCLI-RG

First we need to create a ResourceGroup or select an existing ResourceGroup.
In this case we will use ResourceGroup created in previous lesson.

### Check whether the account name is valid and is not in use
Important: The name of the storage account must be unique in Azure. It must be lowercase, too!

#### Check availability of the storage account:
```shell
az storage account check-name --name teststorageft2

az storage account check-name --name teststorageft --verbose

az storage account check-name --name teststorageft -o table
```
Tips : The --verbose parameter provides verbose output. The -o option will output the result in json, jsonc (colored), table, or csv formats

###Create a Storage Account
* SKU name (LRS/ZRS/GRS/RAGRS/PLRS)
* the account kind (Storage/BlobStorage)

### Create a Standard Storage Account
az storage account create -n teststorageft2 -g MyCLI-RG --sku Standard_LRS -l westus

### Create a Premium Storage Account
az storage account create -n teststorageft3 -g MyCLI-RG --sku Premium_LRS -l westus

### Delete a Storage Account
az storage account delete -n teststorageft3 -g MyCLI-RG

### Delete a resource group
az group delete --name MyCLI-RG
