# Use Policy to manage resources and control access


#  https://azure.microsoft.com/en-us/documentation/articles/resource-manager-policy/

#### Open Azure PowerShell and sign in to your Azure account.

Login-AzureRmAccount

###### This command will open a pop-up window for you to enter your Azure credentials.

#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.


Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"


# Create Policy Definition using PowerShell

# The below examples creates a policy for allowing resources only in North Europe and West Europe.

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


# Policy Assignment using PowerShell

New-AzureRmPolicyAssignment -Name regionPolicyAssignment -PolicyDefinition $policy -Scope /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/ -Verbose -Debug



## Policy Validation 

#To create a new resource group, provide a name and location for your resource group.
New-AzureRmResourceGroup -Name MyFirstStorageRG -Location "West US" -Verbose

#To Check Availibilty of Storage Account Name 
Get-AzureRmStorageAccountNameAvailability mystorageaccountft

#creation of Storage Account (This should fail due to above policy )
New-AzureRmStorageAccount -ResourceGroupName "MyFirstStorageRG" -Name "mystorageaccountft" -Location "West US" -SkuName "Standard_GRS" -Kind "Storage" -Verbose

<#
New-AzureRmStorageAccount : The resource action 
'Microsoft.Storage/storageAccounts/write' is disallowed by one or more policies. Policy identifier(s): '/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Authorization/policyDefinitions/regionPolicyDefinition'.
At line:1 char:1
+ New-AzureRmStorageAccount -ResourceGroupName "MyFirstStorageRG" -Name ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [New-AzureRmStorageAccount], Clo 
   udException
    + FullyQualifiedErrorId : Microsoft.Azure.Commands.Management.Storage.NewA 
   zureStorageAccountCommand
#>

# If you want to remove the above policy assignment 
Remove-AzureRmPolicyAssignment -Name regionPolicyAssignment -Scope /subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/ -Verbose -Debug

## To validate the ploicy has been removed. 

#creation of Storage Account (This command shoulf succeed as there are no policy to restrict it. )
New-AzureRmStorageAccount -ResourceGroupName "MyFirstStorageRG" -Name "mystorageaccountft" -Location "West US" -SkuName "Standard_GRS" -Kind "Storage" -Verbose


# Policy Audit Events

Get-AzureRmLog | where {$_.OperationName -eq "Microsoft.Authorization/policies/deny/action"} 

<#
PS C:\Users\abhanand> Get-AzureRmLog | where {$_.OperationName -eq "Microsoft.Authorization/policies/deny/action"} 


Authorization     : 
                    Scope     : /subscriptions/6b6a59a6-e367-4913-bea7-34b68620
                    95bf/resourceGroups/MyFirstStorageRG/providers/Microsoft.St
                    orage/storageAccounts/mystorageaccountft
                    Action    : Microsoft.Storage/storageAccounts/write
                    Role      : 
                    Condition : 
Caller            : abhanand@microsoft.com
CorrelationId     : 65b8fb9a-8663-4752-819c-96227497c030
Category          : Administrative
EventTimestamp    : 7/25/2016 7:02:11 PM
OperationName     : Microsoft.Authorization/policies/deny/action
ResourceGroupName : MyFirstStorageRG
ResourceId        : 
Status            : Failed
SubscriptionId    : 6b6a59a6-e367-4913-bea7-34b6862095bf
SubStatus         : 

#>