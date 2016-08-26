### Azure Resource Manager overview

[Microsoft Official Article] - [Click Here](https://azure.microsoft.com/en-us/documentation/articles/resource-group-overview/)


* Creation of Empty Azure Resource group
* Creation of Empty Azure Resource group with tags
* Cleaning Tags from Azure Resource group
* Updating Tags for Azure Resource group

There are some important factors to consider when defining your resource group:

1. All of the resources in your group should share the same lifecycle. You will deploy, update and delete them together. If one resource, such as a database server, needs to exist on a different deployment cycle it should be in another resource group.
2. Each resource can only exist in one resource group.
3. You can add or remove a resource to a resource group at any time.
4. You can move a resource from one resource group to another group. For more information, see Move resources to new resource group or subscription.
5. A resource group can contain resources that reside in different regions.
6. A resource group can be used to scope access control for administrative actions.
7. A resource can interact with a resource in another resource groups when the two resources are related but they do not share the same lifecycle (for example, a web apps connecting to a database).


##### To create a new resource group, provide a name and location for your resource group.
```PowerShell
New-AzureRmResourceGroup -Name FTResourceGroup -Location "West US"

Output :
ResourceGroupName : FTResourceGroup
Location          : westus
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/FTResourceGroup
```

##### To create a new resource group, provide a name and location for your resource group with Tag .
This command creates a new empty resource group. This command  assigns tags to the resource group. The first tag, named "Empty," could be used to identify resource groups that have no resources.
The second tag is named "Department" and has a value of "IT". You can use a tag like this one to categorize resource groups for administration or budgeting.
```PowerShell
New-AzureRmResourceGroup -Location "West US" -Name FTResourceGroupTagged -Tag @{Name="Empty"}, @{Name="Department";Value="IT"} -Verbose -Debug

Output :

ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
                    Name        Value
                    ==========  =====
                    Empty            
                    Department  IT   

ResourceId        : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/FTResourceGroupTagged
```

##### Get all tags of a resource group  
```PowerShell
(Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags

(Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags| %{ $_.Name + ": " + $_.Value }

Output :

Name                           Value                                                                                                           
----                           -----                                                                                                                 
Value                                                                                                                                                
Name                           Empty                                                                                                                 
Value                          IT                                                                                                                    
Name                           Department  
```

##### This command deletes all tags from the resource group. It uses the Tag parameter with an empty hash table value.
```PowerShell
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{}

Output :

ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/FTResourceGroupTagged

```

##### Apply a tag to a resource group   
```PowerShell
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{Name="Department";Value="IT"}

output :
ResourceGroupName : FTResourceGroupTagged
Location          : westus
ProvisioningState : Succeeded
Tags              :
                    Name        Value
                    ==========  =====
                    Department  IT   

ResourceId        : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/FTResourceGroupTagged
```

##### Add tags to a resource group  
```PowerShell
$tags = (Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags
$tags += @{Name="Status";Value="Approved"}
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

ResourceId        : /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/FTResourceGroupTagged
```

##### To get all of the resources with a particular tag and value, use the Find-AzureRmResource cmdlet.

Find-AzureRmResource -TagName Department -TagValue IT | %{ $_.ResourceName }


##### Remove a resource group  
```PowerShell
Remove-AzureRmResourceGroup -Name FTResourceGroupTagged -verbose
```
##### Caution : DON'T USE THIS - Remove all resource groups  
```PowerShell
Get-AzureRmResourceGroup | Remove-AzureRmResourceGroup -Verbose
```
