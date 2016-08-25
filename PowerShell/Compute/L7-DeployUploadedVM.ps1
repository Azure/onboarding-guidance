
# Upload a Windows VM image to Azure for Resource Manager deployments

#### Open Azure PowerShell and sign in to your Azure account.

Login-AzureRmAccount

###### This command will open a pop-up window for you to enter your Azure credentials.

#### If the subscription ID that is selected by default is different from the one that you want to work in, use either of the following commands to set the right subscription.


Set-AzureRmContext -SubscriptionId "xxxx-xxxx-xxxx-xxxx"
###### or
Select-AzureRmSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx"

#### You can find the subscriptions that your Azure account has by using the command Get-AzureRmSubscription.


# To upload VM to Azure 



Add-AzureRmVhd -ResourceGroupName MYGROUP2 -Destination https://mystorageaccountft.blob.core.windows.net/vhds/uploaded.vhd -LocalFilePath "C:\fdisklo\fdisk.vhd" -Verbose

<#


PS C:\windows\system32> Add-AzureRmVhd -ResourceGroupName MYGROUP2 -Destination https://mystorageaccountft.blob.core.win
dows.net/vhds/win2012r2uploaded.vhd -LocalFilePath "C:\fdiskloc\fdisk.vhd" -Verbose
MD5 hash is being calculated for the file  C:\fdiskloc\fdisk.vhd.
MD5 hash calculation is completed.
Elapsed time for the operation: 00:17:28
Creating new page blob of size 136365212160...
Detecting the empty data blocks in the local file.
Detecting the empty data blocks completed.
Elapsed time for upload: 00:04:15

LocalFilePath                                               DestinationUri
-------------                                               --------------
C:\fdiskloc\fdisk.vhd                                       https://mystorageaccountft.blob.core.windows.net/vhds/wi...
/



PS C:\windows\system32> Add-AzureRmVhd -ResourceGroupName MYGROUP2 -Destination https://mystorageaccountft.blob.core.win
dows.net/vhds/uploaded.vhd -LocalFilePath "C:\fdisklo\fdisk.vhd" -Verbose
MD5 hash is being calculated for the file  C:\fdisklo\fdisk.vhd.
MD5 hash calculation is completed.
Elapsed time for the operation: 00:17:29
Creating new page blob of size 136365212160...
Detecting the empty data blocks in the local file.
Detecting the empty data blocks completed.
Elapsed time for upload: 00:04:07

LocalFilePath                                               DestinationUri
-------------                                               --------------
C:\fdisklo\fdisk.vhd                                        https://mystorageaccountft.blob.core.windows.net/vhds/uploaded.vhd


PS C:\windows\system32>


#>




# ================ 

#====================== Details of Existing Resource ============
$subnetName = "mysubnet1"
$vnetName = "myvnet1"
$rgName = "mygroup2"
$locName = "centralus"
$stName = "mystorageaccountft"
#=====================================

# Get information regarding Storage Account 

$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName

# Get information regarding Virtual Network 

$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName 

#### Need to create a new IP Address 

$ipName = "myIPaddress3"
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic

#### Need to create a new Network Interface 

$nicName = "mynic3"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id 

#### Get existing Availibity Set details

$AvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name "AvailabilitySet01"


#location of Uploaded Disk 

$osDiskUri ="https://mystorageaccountft.blob.core.windows.net/vhds/win2012r2uploaded.vhd" # This would be the URL of the OS VHD which we want to use here for creating the new VM

#--------------------
# Setup Credentials 
# Not Needed as vhd is not generlized 


# Basic VM configuration 

$vmName = "myvm3"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_A1" -AvailabilitySetID $AvailabilitySet.Id 

# OS and access configuration

$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id 

# OS Disk setting 

$osdiskName = $vmname+'_osDisk'

$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption attach -Windows


#Create the new VM

New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm -Verbose -Debug


#=============

$vmList = Get-AzureRmVM -ResourceGroupName $rgName -Name myvm3
$vmList.Name

<#

PS C:\Users\abhanand> $subnetName = "mysubnet1"
$vnetName = "myvnet1"
$rgName = "mygroup2"
$locName = "centralus"
$stName = "mystorageaccountft"

PS C:\Users\abhanand> $storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName

PS C:\Users\abhanand> $vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName 

PS C:\Users\abhanand> $ipName = "myIPaddress3"
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic

WARNING: The output object type of this cmdlet will be modified in a future release. Also, the usability o
f Tag parameter in this cmdlet will be modified in a future release. This will impact creating, updating a
nd appending tags for Azure resources. For more details about the change, please visit https://github.com/
Azure/azure-powershell/issues/726#issuecomment-213545494

PS C:\Users\abhanand> $nicName = "mynic3"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id 

WARNING: The output object type of this cmdlet will be modified in a future release. Also, the usability o
f Tag parameter in this cmdlet will be modified in a future release. This will impact creating, updating a
nd appending tags for Azure resources. For more details about the change, please visit https://github.com/
Azure/azure-powershell/issues/726#issuecomment-213545494

PS C:\Users\abhanand> 
$AvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name "AvailabilitySet01"


PS C:\Users\abhanand> 
$osDiskUri ="https://mystorageaccountft.blob.core.windows.net/vhds/uploaded.vhd" # This would be the URL of the OS VHD which we want to use here for creating the new VM


PS C:\Users\abhanand> 
$vmName = "myvm3"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_A1" -AvailabilitySetID $AvailabilitySet.Id 


PS C:\Users\abhanand> $vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id 

PS C:\Users\abhanand> $osdiskName = $vmname+'_osDisk'

PS C:\Users\abhanand> $vm = Set-AzureRmVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption attach -Windows

PS C:\Users\abhanand> New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm -Verbose -Debug
DEBUG: 5:50:14 PM - NewAzureVMCommand begin processing with ParameterSet '__AllParameterSets'.
DEBUG: 5:50:16 PM - using account id 'abhanand@microsoft.com'...
WARNING: The  usability of Tag parameter in this cmdlet will be modified in a future release.  This will i
mpact creating, updating and appending tags for Azure resources.  For more details about the change, pleas
e visit https://github.com/Azure/azure-powershell/issues/726#issuecomment-213545494
DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 12:59:27 AM: 43470d86-e177-4766-80b6-366f926a3df3 - TokenCache: An item matching the requ
ested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 12:59:27 AM: 43470d86-e177-4766-80b6-366f926a3df3 - TokenCache: 48.155083065 minutes left
 until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 12:59:27 AM: 43470d86-e177-4766-80b6-366f926a3df3 - TokenCache: A matching item (access t
oken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 12:59:27 AM: 43470d86-e177-4766-80b6-366f926a3df3 - AcquireTokenHandlerBase: === Token Ac
quisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : f47fceb1-8b1a-45c3-a1be-666c908e124a
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14964
x-ms-correlation-request-id   : 9d299f81-da56-42b1-971e-5c4423f7527a
x-ms-routing-request-id       : WESTUS:20160715T005927Z:9d299f81-da56-42b1-971e-5c4423f7527a
Date                          : Fri, 15 Jul 2016 00:59:26 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 12:59:57 AM: 7b443084-d686-4ecf-bf73-e89edc35f356 - AcquireTokenHandlerBase: === Token Ac
quisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 12:59:57 AM: 7b443084-d686-4ecf-bf73-e89edc35f356 - TokenCache: Looking up cache for a to
ken...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 12:59:57 AM: 7b443084-d686-4ecf-bf73-e89edc35f356 - TokenCache: An item matching the requ
ested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 12:59:57 AM: 7b443084-d686-4ecf-bf73-e89edc35f356 - TokenCache: 47.6509007516667 minutes 
left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 12:59:57 AM: 7b443084-d686-4ecf-bf73-e89edc35f356 - TokenCache: A matching item (access t
oken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 12:59:57 AM: 7b443084-d686-4ecf-bf73-e89edc35f356 - AcquireTokenHandlerBase: === Token Ac
quisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 7996125f-d678-42a8-9d25-61fd15d70bee
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14962
x-ms-correlation-request-id   : 16f146bb-472b-4feb-988a-f34b22caf740
x-ms-routing-request-id       : WESTUS:20160715T005957Z:16f146bb-472b-4feb-988a-f34b22caf740
Date                          : Fri, 15 Jul 2016 00:59:56 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:00:27 AM: 4be5a6a7-b6f3-43fa-b710-bb4c60e42aa2 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:00:27 AM: 4be5a6a7-b6f3-43fa-b710-bb4c60e42aa2 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:00:27 AM: 4be5a6a7-b6f3-43fa-b710-bb4c60e42aa2 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:00:27 AM: 4be5a6a7-b6f3-43fa-b710-bb4c60e42aa2 - TokenCache: 47.1494836283333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:00:27 AM: 4be5a6a7-b6f3-43fa-b710-bb4c60e42aa2 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:00:27 AM: 4be5a6a7-b6f3-43fa-b710-bb4c60e42aa2 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 8c292e64-c4d6-4675-83a1-c87a78011599
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14958
x-ms-correlation-request-id   : 9fea8839-df8d-4602-b8f8-f582fc8389fc
x-ms-routing-request-id       : WESTUS:20160715T010027Z:9fea8839-df8d-4602-b8f8-f582fc8389fc
Date                          : Fri, 15 Jul 2016 01:00:26 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:00:57 AM: 03e73fe2-76f3-4bcb-b79e-8b0a889f3310 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:00:57 AM: 03e73fe2-76f3-4bcb-b79e-8b0a889f3310 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:00:57 AM: 03e73fe2-76f3-4bcb-b79e-8b0a889f3310 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:00:57 AM: 03e73fe2-76f3-4bcb-b79e-8b0a889f3310 - TokenCache: 46.6457772216667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:00:57 AM: 03e73fe2-76f3-4bcb-b79e-8b0a889f3310 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:00:57 AM: 03e73fe2-76f3-4bcb-b79e-8b0a889f3310 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : a2850830-8a9c-4078-ac98-d9f977b70b9a
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14956
x-ms-correlation-request-id   : 42636f87-cae7-4965-b9d5-e59a43c5f5ee
x-ms-routing-request-id       : WESTUS:20160715T010057Z:42636f87-cae7-4965-b9d5-e59a43c5f5ee
Date                          : Fri, 15 Jul 2016 01:00:56 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:01:27 AM: 922f3ac5-64e2-4454-a6ec-51bac9e3516a - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:01:27 AM: 922f3ac5-64e2-4454-a6ec-51bac9e3516a - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:01:27 AM: 922f3ac5-64e2-4454-a6ec-51bac9e3516a - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:01:27 AM: 922f3ac5-64e2-4454-a6ec-51bac9e3516a - TokenCache: 46.14438431 minutes left u
ntil token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:01:27 AM: 922f3ac5-64e2-4454-a6ec-51bac9e3516a - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:01:27 AM: 922f3ac5-64e2-4454-a6ec-51bac9e3516a - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : b7ec4a90-7ea9-49e3-9adc-d273e9c29ed6
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14952
x-ms-correlation-request-id   : 61836e33-4034-448f-95b9-39fe8325c3fa
x-ms-routing-request-id       : WESTUS:20160715T010127Z:61836e33-4034-448f-95b9-39fe8325c3fa
Date                          : Fri, 15 Jul 2016 01:01:26 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:01:57 AM: e45e3d6c-62b0-4f9a-9407-44cb742a4f02 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:01:57 AM: e45e3d6c-62b0-4f9a-9407-44cb742a4f02 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:01:57 AM: e45e3d6c-62b0-4f9a-9407-44cb742a4f02 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:01:57 AM: e45e3d6c-62b0-4f9a-9407-44cb742a4f02 - TokenCache: 45.640831535 minutes left 
until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:01:57 AM: e45e3d6c-62b0-4f9a-9407-44cb742a4f02 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:01:57 AM: e45e3d6c-62b0-4f9a-9407-44cb742a4f02 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : c967ec6b-0a13-4aaf-9d85-0b7e4f333a0b
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14951
x-ms-correlation-request-id   : 34d6657d-6941-43b4-b43e-e953cf717c26
x-ms-routing-request-id       : WESTUS:20160715T010157Z:34d6657d-6941-43b4-b43e-e953cf717c26
Date                          : Fri, 15 Jul 2016 01:01:57 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:02:28 AM: aaf17a2d-0647-4322-b081-5bbd18878777 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:02:28 AM: aaf17a2d-0647-4322-b081-5bbd18878777 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:02:28 AM: aaf17a2d-0647-4322-b081-5bbd18878777 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:02:28 AM: aaf17a2d-0647-4322-b081-5bbd18878777 - TokenCache: 45.1396130483333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:02:28 AM: aaf17a2d-0647-4322-b081-5bbd18878777 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:02:28 AM: aaf17a2d-0647-4322-b081-5bbd18878777 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 88559fd4-7c52-4b87-8f68-cd4b626eecd3
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14948
x-ms-correlation-request-id   : 0d0031ef-c52a-40d4-bc4b-0487124b640e
x-ms-routing-request-id       : WESTUS:20160715T010227Z:0d0031ef-c52a-40d4-bc4b-0487124b640e
Date                          : Fri, 15 Jul 2016 01:02:27 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:02:58 AM: b245fbf3-10f0-416a-9d88-6c812fba5d01 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:02:58 AM: b245fbf3-10f0-416a-9d88-6c812fba5d01 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:02:58 AM: b245fbf3-10f0-416a-9d88-6c812fba5d01 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:02:58 AM: b245fbf3-10f0-416a-9d88-6c812fba5d01 - TokenCache: 44.6376066916667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:02:58 AM: b245fbf3-10f0-416a-9d88-6c812fba5d01 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:02:58 AM: b245fbf3-10f0-416a-9d88-6c812fba5d01 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : c68f02b7-29d1-4dfa-80cf-b4c399737b54
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14947
x-ms-correlation-request-id   : a174113d-1a85-4d34-8d04-053758f1eda6
x-ms-routing-request-id       : WESTUS:20160715T010258Z:a174113d-1a85-4d34-8d04-053758f1eda6
Date                          : Fri, 15 Jul 2016 01:02:57 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:03:28 AM: 92e597e8-a71f-40e5-90de-5853095f0f09 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:03:28 AM: 92e597e8-a71f-40e5-90de-5853095f0f09 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:03:28 AM: 92e597e8-a71f-40e5-90de-5853095f0f09 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:03:28 AM: 92e597e8-a71f-40e5-90de-5853095f0f09 - TokenCache: 44.136403895 minutes left 
until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:03:28 AM: 92e597e8-a71f-40e5-90de-5853095f0f09 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:03:28 AM: 92e597e8-a71f-40e5-90de-5853095f0f09 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 47eb8c3d-4583-4ba0-a09b-693af66cccd2
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14945
x-ms-correlation-request-id   : aa13a80f-2679-4732-98b0-11542885d509
x-ms-routing-request-id       : WESTUS:20160715T010328Z:aa13a80f-2679-4732-98b0-11542885d509
Date                          : Fri, 15 Jul 2016 01:03:27 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:03:58 AM: f85ecdfd-50a8-496b-a240-3beb7ec99396 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:03:58 AM: f85ecdfd-50a8-496b-a240-3beb7ec99396 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:03:58 AM: f85ecdfd-50a8-496b-a240-3beb7ec99396 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:03:58 AM: f85ecdfd-50a8-496b-a240-3beb7ec99396 - TokenCache: 43.6326623266667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:03:58 AM: f85ecdfd-50a8-496b-a240-3beb7ec99396 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:03:58 AM: f85ecdfd-50a8-496b-a240-3beb7ec99396 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 1c3feeac-e24c-4e4a-ba3f-614246768f21
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14942
x-ms-correlation-request-id   : d928f80a-8986-48ce-8efd-9aa0c0f1144e
x-ms-routing-request-id       : WESTUS:20160715T010358Z:d928f80a-8986-48ce-8efd-9aa0c0f1144e
Date                          : Fri, 15 Jul 2016 01:03:58 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:04:28 AM: 3442b2d2-a817-4e2c-8179-46a03b72d1fa - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:04:28 AM: 3442b2d2-a817-4e2c-8179-46a03b72d1fa - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:04:28 AM: 3442b2d2-a817-4e2c-8179-46a03b72d1fa - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:04:28 AM: 3442b2d2-a817-4e2c-8179-46a03b72d1fa - TokenCache: 43.1290381533333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:04:28 AM: 3442b2d2-a817-4e2c-8179-46a03b72d1fa - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:04:28 AM: 3442b2d2-a817-4e2c-8179-46a03b72d1fa - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 06557fcb-74f1-4d73-b5c1-474fa19b0f78
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14939
x-ms-correlation-request-id   : 490f1aa5-c4d5-462c-9f48-e3b6fad06733
x-ms-routing-request-id       : WESTUS:20160715T010428Z:490f1aa5-c4d5-462c-9f48-e3b6fad06733
Date                          : Fri, 15 Jul 2016 01:04:28 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:04:58 AM: d844b0a7-453d-47c9-9664-97c6d7250902 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:04:58 AM: d844b0a7-453d-47c9-9664-97c6d7250902 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:04:58 AM: d844b0a7-453d-47c9-9664-97c6d7250902 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:04:58 AM: d844b0a7-453d-47c9-9664-97c6d7250902 - TokenCache: 42.625457405 minutes left 
until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:04:58 AM: d844b0a7-453d-47c9-9664-97c6d7250902 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:04:58 AM: d844b0a7-453d-47c9-9664-97c6d7250902 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : c3342f61-dfd6-4f74-b460-2052f26d6b65
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14937
x-ms-correlation-request-id   : eafd6634-735b-470e-bd1a-c458650d3047
x-ms-routing-request-id       : WESTUS:20160715T010458Z:eafd6634-735b-470e-bd1a-c458650d3047
Date                          : Fri, 15 Jul 2016 01:04:58 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:05:28 AM: edc424b5-de01-48be-944b-86e6fb316814 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:05:28 AM: edc424b5-de01-48be-944b-86e6fb316814 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:05:28 AM: edc424b5-de01-48be-944b-86e6fb316814 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:05:28 AM: edc424b5-de01-48be-944b-86e6fb316814 - TokenCache: 42.1241427083333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:05:28 AM: edc424b5-de01-48be-944b-86e6fb316814 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:05:28 AM: edc424b5-de01-48be-944b-86e6fb316814 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 1f67d414-9f85-4e4d-aba0-860993cb5e8c
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14934
x-ms-correlation-request-id   : 897789f2-b633-4e66-adb4-6d3d1362f9f0
x-ms-routing-request-id       : WESTUS:20160715T010529Z:897789f2-b633-4e66-adb4-6d3d1362f9f0
Date                          : Fri, 15 Jul 2016 01:05:28 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:05:59 AM: 6e00cba1-327f-4358-90bc-8606a51c902a - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:05:59 AM: 6e00cba1-327f-4358-90bc-8606a51c902a - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:05:59 AM: 6e00cba1-327f-4358-90bc-8606a51c902a - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:05:59 AM: 6e00cba1-327f-4358-90bc-8606a51c902a - TokenCache: 41.6197504616667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:05:59 AM: 6e00cba1-327f-4358-90bc-8606a51c902a - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:05:59 AM: 6e00cba1-327f-4358-90bc-8606a51c902a - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 1f5d4be3-69dd-44a3-9876-2973f4b56808
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14932
x-ms-correlation-request-id   : 17ecfb68-5f37-4403-9828-089d2f35eddb
x-ms-routing-request-id       : WESTUS:20160715T010559Z:17ecfb68-5f37-4403-9828-089d2f35eddb
Date                          : Fri, 15 Jul 2016 01:05:59 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:06:29 AM: c21ba797-d55e-4d70-a0a0-f3c0768c308f - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:06:29 AM: c21ba797-d55e-4d70-a0a0-f3c0768c308f - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:06:29 AM: c21ba797-d55e-4d70-a0a0-f3c0768c308f - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:06:29 AM: c21ba797-d55e-4d70-a0a0-f3c0768c308f - TokenCache: 41.1185325066667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:06:29 AM: c21ba797-d55e-4d70-a0a0-f3c0768c308f - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:06:29 AM: c21ba797-d55e-4d70-a0a0-f3c0768c308f - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 34d88368-1a89-4a86-828d-e1f40b45834b
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14929
x-ms-correlation-request-id   : b6f79ae9-632c-4c6c-a433-7f193d73c927
x-ms-routing-request-id       : WESTUS:20160715T010629Z:b6f79ae9-632c-4c6c-a433-7f193d73c927
Date                          : Fri, 15 Jul 2016 01:06:29 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:06:59 AM: 11e4e2c3-d558-433a-8841-3a781358337d - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:06:59 AM: 11e4e2c3-d558-433a-8841-3a781358337d - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:06:59 AM: 11e4e2c3-d558-433a-8841-3a781358337d - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:06:59 AM: 11e4e2c3-d558-433a-8841-3a781358337d - TokenCache: 40.6150129683333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:06:59 AM: 11e4e2c3-d558-433a-8841-3a781358337d - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:06:59 AM: 11e4e2c3-d558-433a-8841-3a781358337d - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 9a088d90-338e-4676-9ae5-c7500de134c0
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14927
x-ms-correlation-request-id   : 03a2fc73-c5a6-46d4-8804-98ff7af90ef9
x-ms-routing-request-id       : WESTUS:20160715T010659Z:03a2fc73-c5a6-46d4-8804-98ff7af90ef9
Date                          : Fri, 15 Jul 2016 01:06:59 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:07:29 AM: fad02453-885e-4922-8dc5-9753587e31ae - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:07:29 AM: fad02453-885e-4922-8dc5-9753587e31ae - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:07:29 AM: fad02453-885e-4922-8dc5-9753587e31ae - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:07:29 AM: fad02453-885e-4922-8dc5-9753587e31ae - TokenCache: 40.1132937866667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:07:29 AM: fad02453-885e-4922-8dc5-9753587e31ae - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:07:29 AM: fad02453-885e-4922-8dc5-9753587e31ae - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 278a2c25-d4b9-40eb-98d8-c2977e202ed9
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14924
x-ms-correlation-request-id   : 12d879b4-7a77-49e6-a888-afea8eb0ceb8
x-ms-routing-request-id       : WESTUS:20160715T010729Z:12d879b4-7a77-49e6-a888-afea8eb0ceb8
Date                          : Fri, 15 Jul 2016 01:07:29 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:07:59 AM: 94eaee60-2699-4734-8609-0209d5137942 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:07:59 AM: 94eaee60-2699-4734-8609-0209d5137942 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:07:59 AM: 94eaee60-2699-4734-8609-0209d5137942 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:07:59 AM: 94eaee60-2699-4734-8609-0209d5137942 - TokenCache: 39.6097524516667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:07:59 AM: 94eaee60-2699-4734-8609-0209d5137942 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:07:59 AM: 94eaee60-2699-4734-8609-0209d5137942 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 2983e9ed-efc6-46b7-8a43-937242f3fc40
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14922
x-ms-correlation-request-id   : 7e15dc6e-c2cd-4c9c-b4ae-eb7cff6d5faa
x-ms-routing-request-id       : WESTUS:20160715T010759Z:7e15dc6e-c2cd-4c9c-b4ae-eb7cff6d5faa
Date                          : Fri, 15 Jul 2016 01:07:59 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:08:29 AM: a597b977-35f1-4026-9825-ac99b2ce6e9e - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:08:29 AM: a597b977-35f1-4026-9825-ac99b2ce6e9e - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:08:29 AM: a597b977-35f1-4026-9825-ac99b2ce6e9e - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:08:29 AM: a597b977-35f1-4026-9825-ac99b2ce6e9e - TokenCache: 39.1083466083333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:08:29 AM: a597b977-35f1-4026-9825-ac99b2ce6e9e - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:08:29 AM: a597b977-35f1-4026-9825-ac99b2ce6e9e - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 7eadda9c-1ece-4adf-ba23-0ac1984f2772
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14919
x-ms-correlation-request-id   : 33774aa1-5d40-438c-adcd-c8a6643987ed
x-ms-routing-request-id       : WESTUS:20160715T010829Z:33774aa1-5d40-438c-adcd-c8a6643987ed
Date                          : Fri, 15 Jul 2016 01:08:29 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:08:59 AM: 8827a167-2ac3-49db-a439-8b4ef191e2e5 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:08:59 AM: 8827a167-2ac3-49db-a439-8b4ef191e2e5 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:08:59 AM: 8827a167-2ac3-49db-a439-8b4ef191e2e5 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:08:59 AM: 8827a167-2ac3-49db-a439-8b4ef191e2e5 - TokenCache: 38.6070697783333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:08:59 AM: 8827a167-2ac3-49db-a439-8b4ef191e2e5 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:08:59 AM: 8827a167-2ac3-49db-a439-8b4ef191e2e5 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 30f8838a-5588-406b-b0b6-9f87ad5f0a91
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14917
x-ms-correlation-request-id   : 1dc9c907-ad93-443d-aa7c-caf2d8f2739b
x-ms-routing-request-id       : WESTUS:20160715T010859Z:1dc9c907-ad93-443d-aa7c-caf2d8f2739b
Date                          : Fri, 15 Jul 2016 01:08:59 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:09:30 AM: 8b34ca39-2dad-42ea-bfb3-0e220e4cba77 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:09:30 AM: 8b34ca39-2dad-42ea-bfb3-0e220e4cba77 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:09:30 AM: 8b34ca39-2dad-42ea-bfb3-0e220e4cba77 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:09:30 AM: 8b34ca39-2dad-42ea-bfb3-0e220e4cba77 - TokenCache: 38.104309215 minutes left 
until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:09:30 AM: 8b34ca39-2dad-42ea-bfb3-0e220e4cba77 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:09:30 AM: 8b34ca39-2dad-42ea-bfb3-0e220e4cba77 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 20b7ea93-4922-4b53-877e-f7036960ee0c
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14914
x-ms-correlation-request-id   : c044dcd9-c238-4d35-8322-d468b8bdc07f
x-ms-routing-request-id       : WESTUS:20160715T010930Z:c044dcd9-c238-4d35-8322-d468b8bdc07f
Date                          : Fri, 15 Jul 2016 01:09:29 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:10:00 AM: 92e6371a-39a2-46b1-88db-43b3eb68a376 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:10:00 AM: 92e6371a-39a2-46b1-88db-43b3eb68a376 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:10:00 AM: 92e6371a-39a2-46b1-88db-43b3eb68a376 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:10:00 AM: 92e6371a-39a2-46b1-88db-43b3eb68a376 - TokenCache: 37.60006597 minutes left u
ntil token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:10:00 AM: 92e6371a-39a2-46b1-88db-43b3eb68a376 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:10:00 AM: 92e6371a-39a2-46b1-88db-43b3eb68a376 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : be01a1a3-6d7f-4e5b-9b1e-2ac770c0d354
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14912
x-ms-correlation-request-id   : 9c284c78-288c-4d3b-aa1c-a5721b0579be
x-ms-routing-request-id       : WESTUS:20160715T011000Z:9c284c78-288c-4d3b-aa1c-a5721b0579be
Date                          : Fri, 15 Jul 2016 01:10:00 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:10:30 AM: 77cd5885-33e2-4ae3-b8f2-ff9ccf5b6415 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:10:30 AM: 77cd5885-33e2-4ae3-b8f2-ff9ccf5b6415 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:10:30 AM: 77cd5885-33e2-4ae3-b8f2-ff9ccf5b6415 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:10:30 AM: 77cd5885-33e2-4ae3-b8f2-ff9ccf5b6415 - TokenCache: 37.09865803 minutes left u
ntil token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:10:30 AM: 77cd5885-33e2-4ae3-b8f2-ff9ccf5b6415 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:10:30 AM: 77cd5885-33e2-4ae3-b8f2-ff9ccf5b6415 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 2401fa11-e3e5-48c4-8709-07b758f11a6a
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14909
x-ms-correlation-request-id   : 65a53376-e8e2-4b6a-95fa-3e394167ba05
x-ms-routing-request-id       : WESTUS:20160715T011030Z:65a53376-e8e2-4b6a-95fa-3e394167ba05
Date                          : Fri, 15 Jul 2016 01:10:30 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:11:00 AM: 0539042b-3d68-4e7a-a1ff-acd7563ad6c6 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:11:00 AM: 0539042b-3d68-4e7a-a1ff-acd7563ad6c6 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:11:00 AM: 0539042b-3d68-4e7a-a1ff-acd7563ad6c6 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:11:00 AM: 0539042b-3d68-4e7a-a1ff-acd7563ad6c6 - TokenCache: 36.5973556166667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:11:00 AM: 0539042b-3d68-4e7a-a1ff-acd7563ad6c6 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:11:00 AM: 0539042b-3d68-4e7a-a1ff-acd7563ad6c6 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : bc4f9265-ae87-4e7b-83d4-d8394517f242
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14984
x-ms-correlation-request-id   : 03a95a68-fe97-4d0d-9cf8-77ebf6ae197c
x-ms-routing-request-id       : CENTRALUS:20160715T011100Z:03a95a68-fe97-4d0d-9cf8-77ebf6ae197c
Date                          : Fri, 15 Jul 2016 01:11:00 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:11:30 AM: 377968af-9e94-490a-9fd5-6d525821fe75 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:11:30 AM: 377968af-9e94-490a-9fd5-6d525821fe75 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:11:30 AM: 377968af-9e94-490a-9fd5-6d525821fe75 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:11:30 AM: 377968af-9e94-490a-9fd5-6d525821fe75 - TokenCache: 36.0912771016667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:11:30 AM: 377968af-9e94-490a-9fd5-6d525821fe75 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:11:30 AM: 377968af-9e94-490a-9fd5-6d525821fe75 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 7a55c2fa-6d32-413d-ae32-8946a54bcfe8
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14983
x-ms-correlation-request-id   : 0ca29373-214d-4c01-9b82-703fedb69049
x-ms-routing-request-id       : CENTRALUS:20160715T011130Z:0ca29373-214d-4c01-9b82-703fedb69049
Date                          : Fri, 15 Jul 2016 01:11:30 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:12:00 AM: e2699412-6f10-4e6d-976e-4006cb87bf06 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:12:00 AM: e2699412-6f10-4e6d-976e-4006cb87bf06 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:12:00 AM: e2699412-6f10-4e6d-976e-4006cb87bf06 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:12:00 AM: e2699412-6f10-4e6d-976e-4006cb87bf06 - TokenCache: 35.590277845 minutes left 
until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:12:00 AM: e2699412-6f10-4e6d-976e-4006cb87bf06 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:12:00 AM: e2699412-6f10-4e6d-976e-4006cb87bf06 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : f64d0d93-0b59-4e8b-bedd-4477a0ebd1b2
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14982
x-ms-correlation-request-id   : 2b7bbc0b-1e77-4522-aa86-5b6bfb0690e9
x-ms-routing-request-id       : CENTRALUS:20160715T011200Z:2b7bbc0b-1e77-4522-aa86-5b6bfb0690e9
Date                          : Fri, 15 Jul 2016 01:12:00 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:12:31 AM: 35095604-44f7-4f5e-87bd-5ccfaf5a180f - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:12:31 AM: 35095604-44f7-4f5e-87bd-5ccfaf5a180f - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:12:31 AM: 35095604-44f7-4f5e-87bd-5ccfaf5a180f - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:12:31 AM: 35095604-44f7-4f5e-87bd-5ccfaf5a180f - TokenCache: 35.0892481266667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:12:31 AM: 35095604-44f7-4f5e-87bd-5ccfaf5a180f - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:12:31 AM: 35095604-44f7-4f5e-87bd-5ccfaf5a180f - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 4295e618-f445-4b2f-ac16-e7577ba4af2a
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14987
x-ms-correlation-request-id   : 084d5260-ba5f-4a79-9ee9-5c53df0c1bd7
x-ms-routing-request-id       : CENTRALUS:20160715T011231Z:084d5260-ba5f-4a79-9ee9-5c53df0c1bd7
Date                          : Fri, 15 Jul 2016 01:12:30 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:13:01 AM: ff451ea4-06ae-4f8f-a25d-08199b533d71 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:13:01 AM: ff451ea4-06ae-4f8f-a25d-08199b533d71 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:13:01 AM: ff451ea4-06ae-4f8f-a25d-08199b533d71 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:13:01 AM: ff451ea4-06ae-4f8f-a25d-08199b533d71 - TokenCache: 34.5853653266667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:13:01 AM: ff451ea4-06ae-4f8f-a25d-08199b533d71 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:13:01 AM: ff451ea4-06ae-4f8f-a25d-08199b533d71 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : b027d214-af79-4d61-8bad-e48b82590056
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14986
x-ms-correlation-request-id   : 735b585c-8557-439f-bffd-a93640128ed9
x-ms-routing-request-id       : CENTRALUS:20160715T011301Z:735b585c-8557-439f-bffd-a93640128ed9
Date                          : Fri, 15 Jul 2016 01:13:00 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:13:31 AM: ba726c3e-fd6c-4b50-b6d6-74644111d903 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:13:31 AM: ba726c3e-fd6c-4b50-b6d6-74644111d903 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:13:31 AM: ba726c3e-fd6c-4b50-b6d6-74644111d903 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:13:31 AM: ba726c3e-fd6c-4b50-b6d6-74644111d903 - TokenCache: 34.0842491233333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:13:31 AM: ba726c3e-fd6c-4b50-b6d6-74644111d903 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:13:31 AM: ba726c3e-fd6c-4b50-b6d6-74644111d903 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 5a264474-df95-4b80-9fda-108019ea3699
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14985
x-ms-correlation-request-id   : 9877cff0-4883-4141-9c3c-914646897d4d
x-ms-routing-request-id       : CENTRALUS:20160715T011331Z:9877cff0-4883-4141-9c3c-914646897d4d
Date                          : Fri, 15 Jul 2016 01:13:30 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:14:01 AM: 230ef533-2ee8-467a-a6dc-5f9a914ad250 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:14:01 AM: 230ef533-2ee8-467a-a6dc-5f9a914ad250 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:14:01 AM: 230ef533-2ee8-467a-a6dc-5f9a914ad250 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:14:01 AM: 230ef533-2ee8-467a-a6dc-5f9a914ad250 - TokenCache: 33.5832854533333 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:14:01 AM: 230ef533-2ee8-467a-a6dc-5f9a914ad250 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:14:01 AM: 230ef533-2ee8-467a-a6dc-5f9a914ad250 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 7464c574-89fb-4475-84a6-c70f24c247ef
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14998
x-ms-correlation-request-id   : 7a3d8827-830c-4f81-8b9c-8e00fcc7ee95
x-ms-routing-request-id       : WESTUS:20160715T011401Z:7a3d8827-830c-4f81-8b9c-8e00fcc7ee95
Date                          : Fri, 15 Jul 2016 01:14:01 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:14:31 AM: c9c1f7e6-0ac8-472a-8036-f6003009186d - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:14:31 AM: c9c1f7e6-0ac8-472a-8036-f6003009186d - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:14:31 AM: c9c1f7e6-0ac8-472a-8036-f6003009186d - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:14:31 AM: c9c1f7e6-0ac8-472a-8036-f6003009186d - TokenCache: 33.0796905666667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:14:31 AM: c9c1f7e6-0ac8-472a-8036-f6003009186d - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:14:31 AM: c9c1f7e6-0ac8-472a-8036-f6003009186d - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : bec8c864-c5a9-41dd-a8f1-16da713e2d11
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14997
x-ms-correlation-request-id   : a5c1b6d1-4eaf-47a8-a74a-c9809efcf899
x-ms-routing-request-id       : WESTUS:20160715T011431Z:a5c1b6d1-4eaf-47a8-a74a-c9809efcf899
Date                          : Fri, 15 Jul 2016 01:14:31 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:15:01 AM: 52efb5fd-b992-4341-98f2-02d65377faad - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:15:01 AM: 52efb5fd-b992-4341-98f2-02d65377faad - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:15:01 AM: 52efb5fd-b992-4341-98f2-02d65377faad - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:15:01 AM: 52efb5fd-b992-4341-98f2-02d65377faad - TokenCache: 32.5784850416667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:15:01 AM: 52efb5fd-b992-4341-98f2-02d65377faad - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:15:01 AM: 52efb5fd-b992-4341-98f2-02d65377faad - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 2828face-cdea-441a-8b33-4b3c16ad39c2
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14996
x-ms-correlation-request-id   : db65bfce-6cf8-498d-8a56-2d551c292b9e
x-ms-routing-request-id       : WESTUS:20160715T011501Z:db65bfce-6cf8-498d-8a56-2d551c292b9e
Date                          : Fri, 15 Jul 2016 01:15:01 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:15:31 AM: 3f549d12-46ce-48ff-96ad-d32e84e594c5 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:15:31 AM: 3f549d12-46ce-48ff-96ad-d32e84e594c5 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:15:31 AM: 3f549d12-46ce-48ff-96ad-d32e84e594c5 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:15:31 AM: 3f549d12-46ce-48ff-96ad-d32e84e594c5 - TokenCache: 32.0772173266667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:15:31 AM: 3f549d12-46ce-48ff-96ad-d32e84e594c5 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:15:31 AM: 3f549d12-46ce-48ff-96ad-d32e84e594c5 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 2ce63d36-5ba2-4668-8295-a475ce23ed2d
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14995
x-ms-correlation-request-id   : 17037b90-c6ac-4dc5-8fb2-6f5b37ed0ab3
x-ms-routing-request-id       : WESTUS:20160715T011531Z:17037b90-c6ac-4dc5-8fb2-6f5b37ed0ab3
Date                          : Fri, 15 Jul 2016 01:15:31 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:16:01 AM: 6012f626-12fb-49d0-a03f-9cdd129bcbeb - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:16:01 AM: 6012f626-12fb-49d0-a03f-9cdd129bcbeb - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:16:01 AM: 6012f626-12fb-49d0-a03f-9cdd129bcbeb - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:16:01 AM: 6012f626-12fb-49d0-a03f-9cdd129bcbeb - TokenCache: 31.57600244 minutes left u
ntil token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:16:01 AM: 6012f626-12fb-49d0-a03f-9cdd129bcbeb - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:16:01 AM: 6012f626-12fb-49d0-a03f-9cdd129bcbeb - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 9a07f138-c315-441e-a263-b1ed6d110a44
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14994
x-ms-correlation-request-id   : 026f834b-dcd7-4499-a8a0-826c9f28a079
x-ms-routing-request-id       : WESTUS:20160715T011601Z:026f834b-dcd7-4499-a8a0-826c9f28a079
Date                          : Fri, 15 Jul 2016 01:16:01 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:16:31 AM: ba430ca5-45a0-42ce-957a-d98d6750104d - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:16:31 AM: ba430ca5-45a0-42ce-957a-d98d6750104d - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:16:31 AM: ba430ca5-45a0-42ce-957a-d98d6750104d - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:16:31 AM: ba430ca5-45a0-42ce-957a-d98d6750104d - TokenCache: 31.07477127 minutes left u
ntil token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:16:31 AM: ba430ca5-45a0-42ce-957a-d98d6750104d - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:16:31 AM: ba430ca5-45a0-42ce-957a-d98d6750104d - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 2ad73e77-e503-43dd-ab81-48e68831e06b
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14993
x-ms-correlation-request-id   : 9f1899f6-445f-4d95-ab3b-678be10c9f88
x-ms-routing-request-id       : WESTUS:20160715T011631Z:9f1899f6-445f-4d95-ab3b-678be10c9f88
Date                          : Fri, 15 Jul 2016 01:16:31 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "status": "InProgress",
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:17:01 AM: 366b79fc-82bd-4f62-bb21-1c6b818dde93 - AcquireTokenHandlerBase: === Token Acq
uisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:17:01 AM: 366b79fc-82bd-4f62-bb21-1c6b818dde93 - TokenCache: Looking up cache for a tok
en...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:17:01 AM: 366b79fc-82bd-4f62-bb21-1c6b818dde93 - TokenCache: An item matching the reque
sted resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/15/2016 1:17:01 AM: 366b79fc-82bd-4f62-bb21-1c6b818dde93 - TokenCache: 30.5735536166667 minutes l
eft until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:17:01 AM: 366b79fc-82bd-4f62-bb21-1c6b818dde93 - TokenCache: A matching item (access to
ken or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/15/2016 1:17:01 AM: 366b79fc-82bd-4f62-bb21-1c6b818dde93 - AcquireTokenHandlerBase: === Token Acq
uisition finished successfully. An access token was retuned:
	Access Token Hash: J8r7JrTp5O7GG9vWctYZNQtNoxMYuXdl0YaW31lJQdY=
	Refresh Token Hash: 3LxWMG19kNVqMl2O5nqFVAfTHuz9QgFMwU3pxXnjQAc=
	Expiration Time: 7/15/2016 1:47:36 AM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microsoft.Comput
e/locations/centralus/operations/dfe00619-7b71-4338-9b8d-91a9c0a7374e?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 80d04c4d-ff63-43fe-ade2-2d0e6ccc61a1
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14992
x-ms-correlation-request-id   : 7593da82-eeea-4b24-98a6-53f27badbfa6
x-ms-routing-request-id       : WESTUS:20160715T011701Z:7593da82-eeea-4b24-98a6-53f27badbfa6
Date                          : Fri, 15 Jul 2016 01:17:01 GMT

Body:
{
  "startTime": "2016-07-14T17:51:23.600078-07:00",
  "endTime": "2016-07-14T18:16:51.1293438-07:00",
  "status": "Failed",
  "error": {
    "code": "VMAgentStatusCommunicationError",
    "message": "VM 'myvm3' has not reported status for VM agent or extensions. Please verify the VM has a 
running VM agent, and can establish outbound connections to Azure storage."
  },
  "name": "dfe00619-7b71-4338-9b8d-91a9c0a7374e"
}


DEBUG: 6:17:02 PM - NewAzureVMCommand end processing.
DEBUG: 6:17:02 PM - NewAzureVMCommand end processing.
New-AzureRmVM : Long running operation failed with status 'Failed'.
StartTime: 7/14/2016 5:51:23 PM
EndTime: 7/14/2016 6:16:51 PM
OperationID: 
Status: Failed
ErrorCode: VMAgentStatusCommunicationError
ErrorMessage: VM 'myvm3' has not reported status for VM agent or extensions. Please verify the VM has a 
running VM agent, and can establish outbound connections to Azure storage.
At line:1 char:1
+ New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm - ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [New-AzureRmVM], ComputeCloudException
    + FullyQualifiedErrorId : Microsoft.Azure.Commands.Compute.NewAzureVMCommand
 
DEBUG: 6:17:24 PM - NewAzureVMCommand end processing.
DEBUG: 6:17:24 PM - NewAzureVMCommand end processing.

#>