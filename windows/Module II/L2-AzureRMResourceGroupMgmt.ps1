
# Run Login-AzureRmAccount to login
Login-AzureRmAccount


#To create a new resource group, provide a name and location for your resource group.
New-AzureRmResourceGroup -Name FTResourceGroup -Location "West US"




#To create a new resource group, provide a name and location for your resource group with Tag .
New-AzureRmResourceGroup -Location "West US" -Name FTResourceGroupTagged -Tag @{Name="Empty"}, @{Name="Department";Value="IT"} -Verbose -Debug

    
# This command creates a new empty resource group. This command  assigns tags to the resource group. The first tag, named "Empty," could be used to identify resource groups that have no resources. 
# The second tag is named "Department" and has a value of "IT". You can use a tag like this one to categorize resource groups for administration or budgeting.


#Get all tags of a resource group  
(Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags




# This command deletes all tags from the resource group. It uses the Tag parameter with an empty hash table value.
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{}



# Apply a tag to a resource group   
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag @{Name="Department";Value="IT"} 




# Add tags to a resource group  
$tags = (Get-AzureRmResourceGroup -Name FTResourceGroupTagged).Tags
$tags += @{Name="Status";Value="Approved"}
Set-AzureRmResourceGroup -Name FTResourceGroupTagged -Tag $tags



# Remove a resource group  
Remove-AzureRmResourceGroup -Name FTResourceGroupTagged -verbose

# DONT USE THIS - Remove all resource groups  
Get-AzureRmResourceGroup | Remove-AzureRmResourceGroup -Verbose