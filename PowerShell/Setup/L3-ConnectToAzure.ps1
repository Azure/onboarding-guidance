


# To login to Azure Resource Manager
Login-AzureRmAccount

# To view all subscriptions for your account
Get-AzureRmSubscription

# To select a default subscription for your current session .

Get-AzureRmSubscription –SubscriptionName “your sub” | Select-AzureRmSubscription

Get-AzureRmSubscription -SubscriptionId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" | Select-AzureRmSubscription


# To see Location that can be  under your subscriptions
Get-AzureRmLocation | select Location, DisplayName 


# To check the AzureRM Subscription Context
Get-AzureRmContext

# To check Registered AzureRmResourceProvider

Get-AzureRmResourceProvider | FT

# To check availalbe AzureRmResourceProvider

Get-AzureRmResourceProvider -ListAvailable | FT

#  Registers a subscription with a resource provider. A subscription must be registered with a resource provider before you can start using the resources supported by that provider. You can check the registration state of the providers in your subscription by running Get-AzureRmResourceProvider -ListAvailable

Get-AzureRmResourceProvider -ProviderNamespace Microsoft.EventHub

Register-AzureRmResourceProvider -ProviderNamespace Microsoft.EventHub