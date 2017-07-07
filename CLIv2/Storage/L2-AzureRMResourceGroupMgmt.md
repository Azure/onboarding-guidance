#### To login to your Azure Subscription
az login

#### List all the accounts that you have access .
az account list

#### Set default account for the session
az account set -s XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
az account show

#### To see Locations that can be accessed in your current subscriptions
```shell
az account list-locations
```

# Commands to manage your resource groups
# Creation of an Empty Resource group in a Region
az group create -l westus -n MyCLI-RG
```
{
  "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/MyCLI-RG",
  "location": "westus",
  "managedBy": null,
  "name": "MyCLI-RG",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null
}
```

# List the resource groups for your subscription
az group list

# Set Tags on Resource Group
az group update -n MyCLI-RG --set tags.Dept=IT
```
{
  "id": "/subscriptions/711d99a7-fd79-4ce7-9831-ea1afa18442e/resourceGroups/MyCLI-RG",
  "location": "westus",
  "managedBy": null,
  "name": "MyCLI-RG",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": {
    "Dept": "IT",
    "Environment": "Test"
  }
}
```

# Update an existing tag on a resource group
az group update -n MyCLI-RG --set tags.Dept=Sales
```
{
  "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/MyCLI-RG",
  "location": "westus",
  "managedBy": null,
  "name": "MyCLI-RG",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": {
    "Dept": "Sales"
  }
}
```

# Remove a tag from a ResourceGroup
az group update -n MyCLI-RG --remove tags.Dept
# Remove all tags from a ResourceGroup
az group update -n MyCLI-RG --remove tags
```
{
  "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/MyCLI-RG",
  "location": "westus",
  "managedBy": null,
  "name": "MyCLI-RG",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": {}
}
```

# Delete a resource group
az group delete --name MyCLI-RG
```
info:    Executing command group delete
Are you sure you want to perform this operation? (y/n): y
 - Finished ..
```