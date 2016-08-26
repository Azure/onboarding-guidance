
# To login to your Azure Subscription
azure login

# List all the accounts that you have access .
azure account list

# Set default account for the session
azure account set XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

# Verify Is Default options is true
azure account show

# Change Mode to arm
azure config mode arm

# Find desired location for your use
azure location list

or

azure location list  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

# group            Commands to manage your resource groups

# Creation of an Empty Resource group in a Region
azure group create --name "testRG2" --location "West US" -v
or
azure group create -n "testRG" -l "West US" -vv

```
info:    Executing command group create
verbose: Getting resource group testRG1
verbose: Creating resource group testRG1
info:    Created resource group testRG1
data:    Id:                  /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/testRG1
data:    Name:                testRG1
data:    Location:            westus
data:    Provisioning State:  Succeeded
data:    Tags: null
data:
info:    group create command OK
```

# List the resource groups for your subscription
azure group list

# Delete a resource group
azure group delete -n testRG1
```
info:    Executing command group delete
Delete resource group testRG1? [y/n]  y
+ Deleting resource group testRG1
info:    group delete command OK
```

# Tags
* help:      -t --tags <tags>               Tags to set to the resource group. Can be multiple. In the format of 'name=value'. Name is required and value is optional. For example, -t tag1=value1;tag2
* help:      --no-tags                      remove all existing tags

# Set Tags on Resource Group
group set -n testRG2 -t Department;Status= Approved
```
info:    Executing command group set
+ Getting resource group testRG3
+ Updating resource group testRG3
info:    Updated resource group testRG3
data:    Id:                  /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/testRG3
data:    Name:                testRG3
data:    Location:            westus
data:    Provisioning State:  Succeeded
data:    Tags: tag1;Department
data:
info:    group set command OK

```

# Remove all Tags from a ResourceGroup

azure group set -n testRG2 --no-tags

```
info:    Executing command group set
+ Getting resource group testRG3
+ Updating resource group testRG3
info:    Updated resource group testRG3
data:    Id:                  /subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/testRG3
data:    Name:                testRG3
data:    Location:            westus
data:    Provisioning State:  Succeeded
data:    Tags: null
data:
info:    group set command OK
```
