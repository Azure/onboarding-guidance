
# Run Login-AzureRmAccount to login
Login-AzureRmAccount


#To create a new resource group, provide a name and location for your resource group.
New-AzureRmResourceGroup -Name FTResourceGroup -Location "West US"


#To create a new resource group, provide a name and location for your resource group with Tag .
New-AzureRmResourceGroup -Location "West US" -Name FTResourceGroupTagged -Tag @{Empty=$null; Department="Marketing"} -Verbose -Debug


# Tags exist directly on resources and resource groups,

# This command creates a new empty resource group. This command  assigns tags to the resource group. The first tag, named "Empty," could be used to identify resource groups that have no resources.
# The second tag is named "Department" and has a value of "IT". You can use a tag like this one to categorize resource groups for administration or budgeting.


#Get all tags of a resource group
(Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags


# This command deletes all tags from the resource group. It uses the Tag parameter with an empty hash table value.
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{}



# Apply a tag to a resource group
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{Department="IT";Environment="Test"}




# Add tags to a resource group
$tags = (Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags
$tags += @{Status="Approved"}
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag $tags



# Add tags to a resource that has no existing tags by using the Set-AzureRmResource command

Set-AzureRmResource -ResourceName $stName -ResourceGroupName $rgName -ResourceType "Microsoft.Storage/storageAccounts" -Tag $tags


# Enter your subscription and Resource Name (This example is for storage resource)
Set-AzureRmResource -ResourceId /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/rgdemo/providers/Microsoft.Storage/storageAccounts/mystorageaccountft2  -Tag $tags


# ============

# To get a list of all tags within a subscription using PowerShell
Get-AzureRmTag 
Get-AzureRmTag -Detailed


# --------------------------  FindByTagName  --------------------------
# Finds all resource group with a tag with name 'Department'.
Find-AzureRmResourceGroup -Tag @{ Department = $null }

#Finds all resource group with a tag with name 'Department' and value 'IT'.

Find-AzureRmResourceGroup -Tag @{ Department ="IT" }



# Remove a resource group
Remove-AzureRmResourceGroup -Name FTResourceGroupTagged -verbose

# DONT USE THIS - Remove all resource groups
# Get-AzureRmResourceGroup | Remove-AzureRmResourceGroup -Verbose



<#
-------
# To get list of all Tags Key and its Values 

(Find-AzureRmResourceGroup).tags
# --------------------------  FindByTagName  --------------------------
# Finds all resource group with a tag with name 'testtag'.
Find-AzureRmResourceGroup -Tag @{ Department = $null }

#Finds all resource group with a tag with name 'testtag' and value 'testval'.

Find-AzureRmResourceGroup -Tag @{ Environment ="Test" }


# To get all of the resources with a particular tag and value, use the Find-AzureRmResource cmdlet.
Find-AzureRmResource -TagName Department -TagValue IT | %{ $_.ResourceName }

(Find-AzureRmResource)| Where-Object { $_.tags -eq $null }|select name, location, tags
(Find-AzureRmResource)| Where-Object { $_.tags -ne $null }|select name, location, tags
(Find-AzureRmResource)| Where-Object { $_.tags -eq '{}'}|select name, location, tags
(Find-AzureRmResource)| select name, location, tags


# To find a ResourceGroup with specific Tag ( Name="";Value="")

Find-AzureRmResourceGroup -Tag @{ Name="Department"; Value="IT" } | %{ $_.Name }

# To List all resource group with with its location and tags 

(Find-AzureRmResourceGroup)|select name, location ,tags

(Find-AzureRmResourceGroup)| Where-Object { $_.tags -ne $null } |select name, location ,tags

# To List all resource group not asociated with any tag 
(Find-AzureRmResourceGroup)| Where-Object { $_.tags -eq $null }| select name, location, tags

#>
