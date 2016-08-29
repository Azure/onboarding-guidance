

# Run Login-AzureRmAccount to login
# Login-AzureRmAccount
# Get-AzureRmSubscription

# View your current Azure PowerShell session context
# This session state is only applicable to the current session and will not affect other sessions
Get-AzureRmContext

# To see Location that can be under your subscriptions
Get-AzureRmLocation | select Location, DisplayName

$rgName = "mygroup2"  # Resource Group Name
$locName = "West US"  # Location

# Storage Account Name - Should be unique across Azure Infrastructure
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.

$StandardStName = "mystorageaccountft2" #  https://mystorageaccountft2.blob.core.windows.net/

$PremiumStName = "mystorageaccountft3"  #  https://mystorageaccountft3.blob.core.windows.net/

# To create a new resource group, provide a name and location for your resource group.
New-AzureRmResourceGroup -Name $rgName -Location $locName -Verbose

# List All resource Group 

Get-AzureRmResourceGroup

#To Check Availibilty of Storage Account Name
Get-AzureRmStorageAccountNameAvailability $StandardStName 

#To Check Availibilty of Storage Account Name
Get-AzureRmStorageAccountNameAvailability $PremiumStName -Debug

# Premium_LRS (Premium Locally-redundant storage)
New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $PremiumStName -Location $locName -SkuName "Premium_LRS" -Kind "Storage" -Verbose

# Standard_LRS (Standard Locally-redundant storage)
New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $StandardStName -Location $locName -SkuName "Standard_LRS" -Kind "Storage" -Verbose


# Delete Storage Account
# Remove-AzureRmStorageAccount -ResourceGroupName $rgName –StorageAccountName $StandardStName 

# Delete a Resource Group - This will delelte all the resoeuces in the group 
# Remove-AzureRmResourceGroup -Name $rgName -verbose