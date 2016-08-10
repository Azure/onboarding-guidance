# Connecting to Azure using Azure PowerShell

[Microsoft Official Article] - [Click Here](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/)

To login to your AzureRM SubscriptionName
```PowerShell
# To login to Azure Resource Manager
PS C:\> Login-AzureRmAccount
```
To view your AzureRM SubscriptionName

```PowerShell
# To view all subscriptions for your account
PS C:\> Get-AzureRmSubscription

# To select a default subscription for your current session
PS C:\> Get-AzureRmSubscription –SubscriptionName “your sub” | Select-AzureRmSubscription
```

To see Location that can be  under your subscriptions
```PowerShell
Get-AzureRmLocation | select Location, DisplayName
```
To check the AzureRM Subscription Context
```PowerShell
# View your current Azure PowerShell session context
# This session state is only applicable to the current session and will not affect other sessions
PS C:\> Get-AzureRmContext

Environment           : AzureCloud
Account               : abhanand@microsoft.com
TenantId              : 72f988bf-86f1-41af-91ab-2d7cd011db47
SubscriptionId        : 6b6a59a6-e367-4913-bea7-34b6862095bf
SubscriptionName      : Microsoft Azure Internal Consumption
CurrentStorageAccount :
```



To check Available AzureRmResourceProvider
```PowerShell
# To see Registered AzureRmResourceProvider
C:\> Get-AzureRmResourceProvider

# To see Available (Registered + NotRegistered) AzureRmResourceProvider
C:\> Get-AzureRmResourceProvider -ListAvailable
```
