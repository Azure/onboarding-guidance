# Module:- Create a Storage Account

# Abstract

During this module, you will Learn about Azure Storage, and how to create applications using Azure blobs, tables, queues, and files.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Create a storage account using PowerShell
* Create a Resource Group
* Verify creation of StorageAccount
* List all of the blobs in all of your containers
* Delete Storage Account

# Prerequisite 
* [Basic Setup Introduction](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%200/L2-SetupIntro.md)

# Estimated time to complete this module:
Self-guided

### Creating your first storage account using PowerShell
For this example  :
* Region : West US
* SkuName : Premium_LRS

#### Login To your Azure Account
```PowerShell
# Run Login-AzureRmAccount to login
Login-AzureRmAccount
```

#### Variables needed to create storage account
```PowerShell
$rgName = "mygroup2"  # Resource Group Name
$locName = "West US"  # Location
$stName = "mystorageaccountft2" # storage Account Name
```

#### Create a Resource Group in the desired region
```PowerShell
# To create a new resource group, provide a name and location for your resource group.
New-AzureRmResourceGroup -Name $rgName -Location $locName

```
#### Verify existence of ResourceGruop
```PowerShell
# Verify Existence of ResourceGruop
Get-AzureRmResourceGroup -Name $rgName

```
#### To Check Availibilty of Storage Account Name
```PowerShell
#To Check Availibilty of Storage Account Name
Get-AzureRmStorageAccountNameAvailability $stName

```
#### Create a New StorageAccount
Note : Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.

SkuName Details : [click Here](https://msdn.microsoft.com/en-us/library/azure/mt712701.aspx)

Kind : Indicates the type of storage account. For now, this must be set to 'Storage' (which supports Blob, Table, Queue, and File data) or 'BlobStorage' (which supports Blob data only).

```PowerShell
# Create a new storage Account
# Premium_LRS (Premium Locally-redundant storage)
New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Location $locName -SkuName "Premium_LRS" -Kind "Storage" -Verbose

# Standard_LRS (Standard Locally-redundant storage)
New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Location $locName -SkuName "Standard_LRS" -Kind "Storage" -Verbose

```
#### Verify creation of StorageAccount
```PowerShell
# Verify creation of StorageAccount
Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName
```
# To select the default storage context for your current session
```PowerShell
# To select the default storage context for your current session
PS C:\> Set-AzureRmCurrentStorageAccount -ResourceGroupName $rgName –StorageAccountName $stName

# View your current Azure PowerShell session context
# Note: the CurrentStorageAccount is now set in your session context
Get-AzureRmContext
```

#### To list all of the blobs in all of your containers in all of your accounts
```PowerShell
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
```

#### Delete Storage Account
```PowerShell
# Delete Storage Account
Remove-AzureRmStorageAccount -ResourceGroupName $rgName –StorageAccountName $stName -Verbose

```
Note :

1. Based on IOPs requirement and stability of the Virtual Machine its recommended to use Premium_LRS.(Standard IOPs)(Premium IOPs).
2. In case you decide to use Standard storage, recommended sku is Standard_LRS.

# See the following resources to learn more
* [Storage documentation](https://azure.microsoft.com/en-us/documentation/services/storage/)
