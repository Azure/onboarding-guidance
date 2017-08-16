# Azure Resource Group Management

# Abstract

During this module, you will learn to create resource groups, create tags for resource groups, and delete resource groups.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Create a new resource group
* Create a resource group with tags
* Delete a resource group

# Prerequisite 
* Completion of [Module on Storage](https://github.com/Azure/onboarding-guidance/tree/master/windows/Module%20I)

# Estimated time to complete this module:
Self-guided

# What are Resource Groups?
The infrastructure for your application is typically made up of many components – maybe a virtual machine, storage account, and virtual network, or a web app, database, database server, and 3rd party services. You do not see these components as separate entities, instead you see them as related and interdependent parts of a single entity. You want to deploy, manage, and monitor them as a group. Azure Resource Manager enables you to work with the resources in your solution as a group. You can deploy, update or delete all of the resources for your solution in a single, coordinated operation.

### Azure Resource Manager overview

* Creation of Empty Azure Resource group
* Creation of Empty Azure Resource group with tags


### Important factors to consider when defining your resource group:

1. All of the resources in your group should share the same lifecycle. You will deploy, update and delete them together. If one resource, such as a database server, needs to exist on a different deployment cycle it should be in another resource group.
2. Each resource can only exist in one resource group.
3. You can add or remove a resource to a resource group at any time.
4. You can move a resource from one resource group to another group. For more information, see Move resources to new resource group or subscription.
5. A resource group can contain resources that reside in different regions.
6. A resource group can be used to scope access control for administrative actions.
7. Resource groups are not a definition of resource connectivity nor determine how resources communicate between eachother or to/from the internet


##### To create a new resource group, provide a name and location for your resource group.
```PowerShell
New-AzureRmResourceGroup -Name FTResourceGroup -Location "West US"

Output :
ResourceGroupName : FTResourceGroup
Location          : westus
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroup
```

##### To create a new resource group, provide a name and location for your resource group with Tag .
This command creates a new empty resource group. This command  assigns tags to the resource group. The first tag, named "Empty," could be used to identify resource groups that have no resources.
The second tag is named "Department" and has a value of "Marketing". You can use a tag like this one to categorize resource groups for administration or budgeting.
```PowerShell
New-AzureRmResourceGroup -Location "West US" -Name FTResourceGroupTagged -Tag @{Empty=$null; Department="Marketing"} -Verbose -Debug

Output :

ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
                    Name        Value
                    ==========  =====
                    Empty            
                    Department  Marketing    

ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroupTagged
```

##### Get all tags of a resource group  
```PowerShell
(Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags

Output :

Name                           Value                                                                                                      ----                           -----                                                                                                      Value                                                                                                                                    Name                           Empty                                                                                                      Value                          Marketing                                                                                                  Name                           Department  
```

##### This command deletes all tags from the resource group. It uses the Tag parameter with an empty hash table value.
```PowerShell
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{}

Output :

ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroupTagged

```

##### Apply a tag to a resource group   
```PowerShell
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{Department="IT";Environment="Test"}

output :
ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
                    Name        Value
                    ==========  =====
                    Department  IT
                    Environment Test

ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroupTagged
```

##### Add tags to a resource group  
```PowerShell
$tags = (Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags
$tags += @{Status="Approved"}
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag $tags

Output :
ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
                    Name        Value   
                    ==========  ========
                    Department  IT      
                    Status      Approved

ResourceId        : /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/FTResourceGroupTagged
```


##### Remove a resource group  
```PowerShell
Remove-AzureRmResourceGroup -Name FTResourceGroupTagged -verbose
```
# See the following resources to learn more
* [Resource Group Overview](https://azure.microsoft.com/en-us/documentation/articles/resource-group-overview/)
