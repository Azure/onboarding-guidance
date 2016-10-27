# Policies with Azure Resource Manager

# Abstract

During this module, you will learn how to control access through custom policies with Azure Resource Manager. 

# Learning objectives
After completing the exercises in this module, you will be able to:
* Define a Policy Definition structure
* Set Policy Evaluation
* Use logical operators and conditions
* Create Policy Definition using PowerShell
* Create Policy Definition using Azure CLI
* How to apply a Policy

# Prerequisite 
* Completion of [Module on Storage](https://github.com/Azure/onboarding-guidance/tree/master/windows/Module%20I)

# Estimated time to complete this module:
Self-guided

# What is a Policy?
With policies, you can prevent users in your organization from breaking conventions that are needed to manage your organization's resources. 
You create policy definitions that describe the actions or resources that are specifically denied. You assign those policy definitions at the desired scope, such as the subscription, resource group, or an individual resource.

# [Use Policy to manage resources and control access]( https://azure.microsoft.com/en-us/documentation/articles/resource-manager-policy/)

With policies, you can prevent users in your organization from breaking conventions that are needed to manage your organization's resources.

How is it different from RBAC?
* RBAC focuses on the actions a user can perform at different scopes.
* Policy focuses on resource actions at various scopes.

###### Policy Evaluation
Policy will be evaluated when resource creation or template deployment happens using HTTP PUT. 

##### Policy supports three types of effect - deny, audit, and append.

Deny generates an event in the audit log and fails the request
Audit generates an event in audit log but does not fail the request
Append adds the defined set of fields to the request


# You assign those policy definitions at the desired scope, such as the subscription, resource group, or an individual resource.

## Policy Definition Examples :

1. Chargeback: Require departmental tags



####################################################
## 1. Chargeback: Require departmental tags
###################################################

#### The below policy denies all requests which don’t have a tag containing "costCenter" key.
```
$chargebackPolicy = New-AzureRmPolicyDefinition -Name chargebackPolicyDefination -Description "policy denies all requests which don’t have a tag containing costCenter key" -Policy '{
  "if": {
    "not" : {
      "field" : "tags",
      "containsKey" : "costCenter"
    }
  },
  "then" : {
    "effect" : "deny"
  }
}'
```

# Policy Assignment using PowerShell
```
New-AzureRmPolicyAssignment -Name regionPolicyAssignment -PolicyDefinition $chargebackPolicy -Scope /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/ -Verbose -Debug
```
#To create a new resource group, provide a name and location for your resource group. - This will succeed
```
New-AzureRmResourceGroup -Name MyFirstStorageRG -Location "West US" -Verbose 

```

2. Geo Compliance: Ensure resource locations

###################
## 2. Geo Compliance: Ensure resource locations
###################

#### The below examples creates a policy for allowing resources only in North Europe and West Europe.
```
$policy = New-AzureRmPolicyDefinition -Name regionPolicyDefinition -Description "Policy to allow resource creation only in certain regions" -Policy '{  
  "if" : {
    "not" : {
      "field" : "location",
      "in" : ["northeurope" , "westeurope"]
    }
  },
  "then" : {
    "effect" : "deny"
  }
}'          

```
#### Policy Assignment using PowerShell
```
New-AzureRmPolicyAssignment -Name regionPolicyAssignment -PolicyDefinition $policy -Scope /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/ -Verbose -Debug
```

## Policy Validation 

#### To create a new resource group, provide a name and location for your resource group.
```
New-AzureRmResourceGroup -Name MyFirstStorageRG -Location "West US" -Verbose
```
#### To Check Availibilty of Storage Account Name 
```
Get-AzureRmStorageAccountNameAvailability mystorageaccountft
```
#### creation of Storage Account (This should fail due to above policy )
```
New-AzureRmStorageAccount -ResourceGroupName "MyFirstStorageRG" -Name "mystorageaccountft" -Location "West US" -SkuName "Standard_GRS" -Kind "Storage" -Verbose


New-AzureRmStorageAccount : The resource action 
'Microsoft.Storage/storageAccounts/write' is disallowed by one or more policies. Policy identifier(s): '/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/providers/Microsoft.Authorization/policyDefinitions/regionPolicyDefinition'.
At line:1 char:1
+ New-AzureRmStorageAccount -ResourceGroupName "MyFirstStorageRG" -Name ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [New-AzureRmStorageAccount], Clo 
   udException
    + FullyQualifiedErrorId : Microsoft.Azure.Commands.Management.Storage.NewA 
   zureStorageAccountCommand

```
#### If you want to remove the above policy assignment 
```
Remove-AzureRmPolicyAssignment -Name regionPolicyAssignment -Scope /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/ -Verbose -Debug
```
## To validate the ploicy has been removed. 

#### creation of Storage Account (This command shoulf succeed as there are no policy to restrict it. )
```
New-AzureRmStorageAccount -ResourceGroupName "MyFirstStorageRG" -Name "mystorageaccountft" -Location "West US" -SkuName "Standard_GRS" -Kind "Storage" -Verbose

```
#### Policy Audit Events

```
Get-AzureRmLog | where {$_.OperationName -eq "Microsoft.Authorization/policies/deny/action"} 

<#
PS C:\Users\user1> Get-AzureRmLog | where {$_.OperationName -eq "Microsoft.Authorization/policies/deny/action"} 


Authorization     : 
                    Scope     : /subscriptions/6b6a59a6-e367-4913-bea7-34b68620
                    95bf/resourceGroups/MyFirstStorageRG/providers/Microsoft.St
                    orage/storageAccounts/mystorageaccountft
                    Action    : Microsoft.Storage/storageAccounts/write
                    Role      : 
                    Condition : 
Caller            : user1@microsoft.com
CorrelationId     : 65b8fb9a-8663-4752-819c-96227497c030
Category          : Administrative
EventTimestamp    : 7/25/2016 7:02:11 PM
OperationName     : Microsoft.Authorization/policies/deny/action
ResourceGroupName : MyFirstStorageRG
ResourceId        : 
Status            : Failed
SubscriptionId    : XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
SubStatus         : 

#>
``` 


##############################
Service Curation: Select the service catalog
##############################


3. Service Curation: Select the service catalog
4. Use Approved SKUs
5. Naming Convention
6. Tag requirement just for Storage resources
