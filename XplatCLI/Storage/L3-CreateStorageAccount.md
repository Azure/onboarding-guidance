# Creating your first storage account using CLI

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

##  Prerequisite
1. ResourceGroup

For this example :

Region : West US
SkuName : Premium_LRS


#### List all the account that exists in the Subscription (if any)
azure storage account list
```
info:    Executing command storage account list
+ Getting storage accounts
data:    Name                 SKU Name      SKU Tier  Access Tier  Kind     Encrypted Service  Location   Resource Group
data:    -------------------  ------------  --------  -----------  -------  -----------------  ---------  --------------
data:    6b1987centralus      Standard_LRS  Standard               Storage                     centralus  securitydata
data:    mystorageaccountft1  Standard_LRS  Standard               Storage                     centralus  mygroup2
info:    storage account list command OK
```

First we need to create a ResourceGroup or select an existing ResourceGroup.
In this case we will use ResourceGroup created in previous lesson.

#### Check whether the account name is valid and is not in use
Important: The name of the storage account must be unique in Azure. It must be lowercase, too!

azure storage account check teststorageft

azure storage account check teststorageft -v

azure storage account check teststorageft -vv

azure storage account check teststorageft --json

####Create a Storage Account
* SKU name (LRS/ZRS/GRS/RAGRS/PLRS)
* the account kind (Storage/BlobStorage)

azure storage account create <> --sku-name <> --kind <kind> --tags <tags> --location <location> --resource-group <resourceGroup> --subscription <id>   


#### List storage account keys
azure storage account keys list testuploadedstorage --resource-group TestRGcli
#### Create a storage container
azure storage container create --account-name testuploadedstorage --account-key <key1> --container vm-images

Tips : The -v parameter provides verbose output, and the -vv parameter provides even more detailed verbose output. The --json option will output the result in raw json format.

### See the following resources to learn more
* [Storage documentation](https://azure.microsoft.com/en-us/documentation/articles/storage-azure-cli/)
