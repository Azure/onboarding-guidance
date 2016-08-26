
#### Open Azure PowerShell and sign in to your Azure account.

Login-AzureRmAccount
Login-AzureRmAccount
###### This command will open a pop-up window for you to enter your Azure credentials.

Get-AzureRmSubscription



#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.


Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"


### Find Azure location that subscription has access too.
Get-AzureRmLocation | sort Location | Select Location
