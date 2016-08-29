
### To login to your Azure Subscription
azure login

### List all the accounts that you have access .
azure account list

###  Set default account for the session
azure account set XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

###  Verify Is Default options is true
azure account show

###  Change Mode to arm
azure config mode arm

###  Find desired location for your use
azure location list

or

azure location list  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

###  group            Commands to manage your resource groups

### Creation of an Empty Resource group in a Region
azure group create --name "testRG3" --location "West US" -v
or
azure group create -n "testR3" -l "West US" -vv


### List the resource groups for your subscription
azure group list

### List all the account that exists in the Subscription (if any)
azure storage account list

First we need to create a ResourceGroup or select an existing ResourceGroup.
In this case we will use ResourceGroup created in previous lesson.

### Check whether the account name is valid and is not in use
Important: The name of the storage account must be unique in Azure. It must be lowercase, too!

azure storage account check teststorageft2

azure storage account check teststorageft -v

azure storage account check teststorageft -vv

azure storage account check teststorageft --json

###Create a Storage Account
* SKU name (LRS/ZRS/GRS/RAGRS/PLRS)
* the account kind (Storage/BlobStorage)

### Create a standard Standard Storage Account
azure storage account create teststorageft2 --sku-name LRS --kind Storage --location westus --resource-group testRG3 --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX   

### Create a standard Standard Storage Account
azure storage account create teststorageft3 --sku-name PLRS --kind Storage --location westus --resource-group testRG3 --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX  

Tips : The -v parameter provides verbose output, and the -vv parameter provides even more detailed verbose output. The --json option will output the result in raw json format.

### Delete a Storage Account
azure storage account delete teststorageft3 --resource-group testRG3

### Delete a resource group
azure group delete --name testRG3
