### Creating your First Azure Storage Account


# Run Login-AzureRmAccount to login
Login-AzureRmAccount

# Variables needed to create storage account 

$rgName = "mygroup2"  # Resource Group Name
$locName = "West US"  # Location
$stName = "mystorageaccountft2" # storage Account Name



#To create a new resource group, provide a name and location for your resource group.
New-AzureRmResourceGroup -Name $rgName -Location $locName

# Verify Existence of ResourceGruop 
Get-AzureRmResourceGroup -Name $rgName

# Note : Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.

#To Check Availibilty of Storage Account Name 
Get-AzureRmStorageAccountNameAvailability $stName


# To Create New Storage account  

<# SkuName Options

Standard_LRS (Standard Locally-redundant storage)
Standard_ZRS (Standard Zone-redundant storage)
Standard_GRS (Standard Geo-redundant storage)
Standard_RAGRS (Standard Read access geo-redundant storage)
Premium_LRS (Premium Locally-redundant storage)

kind :Indicates the type of storage account. For now, this must be set to 'Storage' (which supports Blob, Table, Queue, and File data) or 'BlobStorage' (which supports Blob data only).
#>

# Premium_LRS (Premium Locally-redundant storage)
New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Location $locName -SkuName "Premium_LRS" -Kind "Storage" -Verbose

# Standard_LRS (Standard Locally-redundant storage) 
New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Location $locName -SkuName "Standard_LRS" -Kind "Storage" -Verbose

# Verify creation of StorageAccount
Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName


### Use following commands if needed. 


# Set the Current Azure Storage Account.
Set-AzureRmCurrentStorageAccount -ResourceGroupName $rgName -Name $stName

# Delete StorageAccount
Remove-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Verbose

# Remove a resource group  
Remove-AzureRmResourceGroup -Name $rgName -verbose

