# Tag Based Resource Group with Azure Resource Manager

# Abstract

During this module, you will learn how to use tags to organize your Azure resources.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Add a value to a resource tag
* Create a resource tag
* Delete a resource tag
* List all resource tags and values
* Remove a value from a resource tag

# Prerequisite 
* Completion of [Module on Storage](https://github.com/Azure/onboarding-guidance/tree/master/windows/Module%20I)

# Estimated time to complete this module:
Self-guided

# What are Tags?
Predefined tags let you establish standard, consistent, predictable names and values for the tags in your subscription.  Resources and resource groups can be tagged with a set of name-value pairs. Adding tags to resources enables you to group resources together across resource groups and to create your own views. Each resource or resource group can have a maximum of 15 tags. The tag name can have a maximum of 512 characters, and the tag value 256 characters.

# Tag Based Resource Group with Azure Resource Manager


Using tags to organize your Azure resources

* Tags can be helpful when you need to organize resources for billing or management.
* Each tag you add to a resource or resource group is automatically added to the subscription-wide taxonomy.
* Each resource or resource group can have a maximum of 15 tags. The tag name is limited to 512 characters, and the tag value is limited to 256 characters.

Predefined tags let you establish standard, consistent, predictable names and values for the tags in your subscription. 


| Key | Value     |
| :------------- | :------------- |
| Department       | IT, Finance, HR       |  
| Team       | Network, Development ,Storage       |
| Environment       | Prod, Dev, Test       |
| ApprovalStatus       | Approved, Pending, Denied       |




### Verify that module for AzureRm.Resources should be 3.0.1 or later
```PowerShell
Get-Module -ListAvailable -Name AzureRm.Resources | Select Version
```

## TAG creation 

###  Create a predefined tag with no Value 

This command creates a predefined tag named FY2015. This tag has no values. You can apply a tag with no values to a resource or resource group
```PowerShell
New-AzureRmTag -Name "Department"
```
### Add a value to a predefined tag / Create a new Tag with Value

This command creates a predefined tag named Department with a value of IT.
```PowerShell
New-AzureRmTag -Name "Department" -Value "IT"
```
If the tag name exists, New-AzureRmTag adds the value to the existing tag instead of creating a new one.
```PowerShell
New-AzureRmTag -Name "Department" -Value "Finance"
```
Note : Predefined tags can have multiple values, but you can enter only one value in each command. 
        



## Tag based ResourceGroup management

### Apply a tag to a resource group (Assuming no Tags are in place)
```PowerShell
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{Department="IT";Environment="Test"}

ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
                    Name         Value
                    ===========  =====
                    Environment  Test
                    Department   IT   

ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroupTagged
```

#### To create a new resource group, provide a name and location for your resource group with Tag .
```PowerShell
New-AzureRmResourceGroup -Location "West US" -Name FTResourceGroupTagged -Tag @{Empty=$null; Department="Marketing"}

output:
ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
                    Name        Value    
                    ==========  =========
                    Empty                
                    Department  Marketing

ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroupTagged
```

Tags exist directly on resources and resource groups,

This command creates a new empty resource group. This command  assigns tags to the resource group. The first tag, named "Empty," could be used to identify resource groups that have no resources.

The second tag is named "Department" and has a value of "Marketing". You can use a tag like this one to categorize resource groups for administration or budgeting.


####Add tags to a resource group
```PowerShell
$tags = (Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags
$tags += @{Status="Approved"}
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag $tags


ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
                    Name         Value   
                    ===========  ========
                    Department   IT      
                    Status       Approved
                    Environment  Test    

ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroupTagged
```

#### This command deletes all tags from the resource group. It uses the Tag parameter with an empty hash table value.

```
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{}

output :
ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroupTagged
```

#### Get all tags of a resource group

```PowerShell
(Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags
```
#### Finds all resource group with a tag with name 'Department'.
```PowerShell
Find-AzureRmResourceGroup -Tag @{ Department = $null }
```
#### Finds all resource group with a tag with name 'Department' and value 'IT'.
```PowerShell
Find-AzureRmResourceGroup -Tag @{ Department ="IT" }
Find-AzureRmResourceGroup -Tag @{ Department ="IT" })| select Name, Location

name                  location
----                  --------
FTResourceGroupTagged westus  
TestRG                eastus
```


#### To get list of all Tags Key and its Values for all ResourceGroup in your subscription
```PowerShell
(Find-AzureRmResourceGroup)| select Name, location, tags 

```


## Tag based Resources management

