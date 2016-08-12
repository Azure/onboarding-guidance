# Module: Connect to Azure using PowerShell

# Abstract

During this module, you will be using PowerShell to connect to Azure and login to your subscription. Once logged in, you can view all the subscriptions you have access too and select one to work with.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Connect to Azure using Azure PowerShell
* Login to your Azure account
* View all subscriptions and select default for current session 
* See Registered Azure Resource Provider

# Prerequisite 
None

# Estimated time to complete this module:
Self-guided

# What is Azure PowerShell?
Azure PowerShell is a set of modules that provide cmdlets to manage Azure with Windows PowerShell. You can use the cmdlets to create, test, deploy, and manage solutions and services delivered through the Azure platform. In most cases, the cmdlets can be used for the same tasks as the Azure Management Portal, such as creating and configuring cloud services, virtual machines, virtual networks, and web apps. The cmdlets need your subscription so they can manage your services. Use your email address and password associated with your account. Azure authenticates and saves the credential information.

# Connecting to Azure using Azure PowerShell
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

# See the following resources to learn more
* [How to install and configure Azure PowerShell](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/)
