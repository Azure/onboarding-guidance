
# DeployCapturedVM
## Deploy a new VM from the captured image into exiting infrastructure 
# (Resource Group/ VNET/Subnet/Avilibity Set/Storage Account)


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
$ipName = "myIPaddress2"
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic

#### Need to create a new Network Interface 
$nicName = "mynic2"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id 

#### Get existing Availibity Set details
$AvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name "AvailabilitySet01"


# location of caputered image 
$urlOfCapturedImageVhd= "https://mystorageaccountft.blob.core.windows.net/system/Microsoft.Compute/Images/image/customimage-osDisk.7e5505ce-57c5-4cbb-a881-258a60b5c2df.vhd"


#--------------------
# Setup Credentials 
$user = "youaretheadmin"
$password = 'Pa$$word$1'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword) 



# Basic VM configuration 

$vmName = "myvm2"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_A1" -AvailabilitySetID $AvailabilitySet.Id 

# OS and access configuration

$compName = "myvm2"
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $compName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate

$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id 

# OS Disk setting 

$blobPath = "vhds/"+$vmname+"_os.vhd"
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $blobPath

$osdiskName = $vmname+'_osDisk'

$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osdiskName -VhdUri $osDiskUri -CreateOption fromImage -SourceImageUri $urlOfCapturedImageVhd -Windows

#Create the new VM

New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm -Verbose -Debug

<#


PS C:\Users\abhanand> New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm -Verbose -Debug
DEBUG: 11:42:20 AM - NewAzureVMCommand begin processing with ParameterSet '__All
ParameterSets'.
DEBUG: 11:42:23 AM - using account id 'abhanand@microsoft.com'...
WARNING: The  usability of Tag parameter in this cmdlet will be modified in a fu
ture release.  This will impact creating, updating and appending tags for Azure 
resources.  For more details about the change, please visit https://github.com/A
zure/azure-powershell/issues/726#issuecomment-213545494
DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:43:27 PM: 71f7ace0-f5b9-451a-bed9-8039b7a861f2 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:43:27 PM: 71f7ace0-f5b9-451a-bed9-8039b7a861f2 - TokenCache: 56.655325865 minu
tes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:43:27 PM: 71f7ace0-f5b9-451a-bed9-8039b7a861f2 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:43:27 PM: 71f7ace0-f5b9-451a-bed9-8039b7a861f2 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : f2a1d6fa-2278-42e2-9aa7-0ffc1680b6de
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14987
x-ms-correlation-request-id   : 6f0898f6-10e0-4453-a9f4-511e4cfffc6c
x-ms-routing-request-id       : WESTUS:20160713T184327Z:6f0898f6-10e0-4453-a9f4-511e4cfffc6c
Date                          : Wed, 13 Jul 2016 18:43:26 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:43:57 PM: 8dc4ddc9-26ae-4d13-9435-df203c59162b - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:43:57 PM: 8dc4ddc9-26ae-4d13-9435-df203c59162b - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:43:57 PM: 8dc4ddc9-26ae-4d13-9435-df203c59162b - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:43:57 PM: 8dc4ddc9-26ae-4d13-9435-df203c59162b - TokenCache: 56.153998535 minu
tes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:43:57 PM: 8dc4ddc9-26ae-4d13-9435-df203c59162b - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:43:57 PM: 8dc4ddc9-26ae-4d13-9435-df203c59162b - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : da7da6c0-7fce-4c56-a6d8-3f78d66d3d7f
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14986
x-ms-correlation-request-id   : 7e332775-c428-4ce0-be94-1a2518b4bc3f
x-ms-routing-request-id       : WESTUS:20160713T184357Z:7e332775-c428-4ce0-be94-1a2518b4bc3f
Date                          : Wed, 13 Jul 2016 18:43:56 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:44:27 PM: 119343f9-27bb-4ad2-8711-e11631e3f325 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:44:27 PM: 119343f9-27bb-4ad2-8711-e11631e3f325 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:44:27 PM: 119343f9-27bb-4ad2-8711-e11631e3f325 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:44:27 PM: 119343f9-27bb-4ad2-8711-e11631e3f325 - TokenCache: 55.6525776716667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:44:27 PM: 119343f9-27bb-4ad2-8711-e11631e3f325 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:44:27 PM: 119343f9-27bb-4ad2-8711-e11631e3f325 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : b58647ed-0c8b-4a76-a5da-0466e3357db1
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14985
x-ms-correlation-request-id   : d646b7a8-07a6-4073-8768-e6a113d8ceec
x-ms-routing-request-id       : WESTUS:20160713T184427Z:d646b7a8-07a6-4073-8768-e6a113d8ceec
Date                          : Wed, 13 Jul 2016 18:44:26 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:44:57 PM: 50919f1c-022c-4421-9a32-e071cc9a1f95 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:44:57 PM: 50919f1c-022c-4421-9a32-e071cc9a1f95 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:44:57 PM: 50919f1c-022c-4421-9a32-e071cc9a1f95 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:44:57 PM: 50919f1c-022c-4421-9a32-e071cc9a1f95 - TokenCache: 55.150775555 minu
tes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:44:57 PM: 50919f1c-022c-4421-9a32-e071cc9a1f95 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:44:57 PM: 50919f1c-022c-4421-9a32-e071cc9a1f95 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : a0787b8f-0d54-4c6f-9c9a-41679c0e52a9
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14998
x-ms-correlation-request-id   : 87b52d81-0e97-4b4b-b08d-1520e4c2ba16
x-ms-routing-request-id       : CENTRALUS:20160713T184457Z:87b52d81-0e97-4b4b-b08d-1520e4c2ba16
Date                          : Wed, 13 Jul 2016 18:44:57 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:45:28 PM: 4a61b857-fcd3-4003-8f95-9d8ba59115d2 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:45:28 PM: 4a61b857-fcd3-4003-8f95-9d8ba59115d2 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:45:28 PM: 4a61b857-fcd3-4003-8f95-9d8ba59115d2 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:45:28 PM: 4a61b857-fcd3-4003-8f95-9d8ba59115d2 - TokenCache: 54.64404262 minut
es left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:45:28 PM: 4a61b857-fcd3-4003-8f95-9d8ba59115d2 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:45:28 PM: 4a61b857-fcd3-4003-8f95-9d8ba59115d2 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 08c83f0c-edef-406e-b446-de0e9c4d9980
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14995
x-ms-correlation-request-id   : 91e30870-a2b9-405a-95eb-c493d9333280
x-ms-routing-request-id       : CENTRALUS:20160713T184527Z:91e30870-a2b9-405a-95eb-c493d9333280
Date                          : Wed, 13 Jul 2016 18:45:27 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:45:58 PM: 3a8b84ef-efe6-47ae-9c4a-1b9b0c4fede0 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:45:58 PM: 3a8b84ef-efe6-47ae-9c4a-1b9b0c4fede0 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:45:58 PM: 3a8b84ef-efe6-47ae-9c4a-1b9b0c4fede0 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:45:58 PM: 3a8b84ef-efe6-47ae-9c4a-1b9b0c4fede0 - TokenCache: 54.14303159 minut
es left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:45:58 PM: 3a8b84ef-efe6-47ae-9c4a-1b9b0c4fede0 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:45:58 PM: 3a8b84ef-efe6-47ae-9c4a-1b9b0c4fede0 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : f8bb8085-eee1-4ff1-b427-8e0e4d40d7ea
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14994
x-ms-correlation-request-id   : d9a2d27d-6d06-4ec2-988d-dbd9d7e574fa
x-ms-routing-request-id       : CENTRALUS:20160713T184558Z:d9a2d27d-6d06-4ec2-988d-dbd9d7e574fa
Date                          : Wed, 13 Jul 2016 18:45:57 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:46:28 PM: 8a5aea5a-0a11-41bc-9cf7-607a6c78d45e - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:46:28 PM: 8a5aea5a-0a11-41bc-9cf7-607a6c78d45e - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:46:28 PM: 8a5aea5a-0a11-41bc-9cf7-607a6c78d45e - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:46:28 PM: 8a5aea5a-0a11-41bc-9cf7-607a6c78d45e - TokenCache: 53.6420375583333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:46:28 PM: 8a5aea5a-0a11-41bc-9cf7-607a6c78d45e - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:46:28 PM: 8a5aea5a-0a11-41bc-9cf7-607a6c78d45e - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : d070d309-abc8-4856-aee7-2ec82e824940
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14992
x-ms-correlation-request-id   : 892a7c7a-28f4-4bec-bc8b-e7e52115d8b9
x-ms-routing-request-id       : CENTRALUS:20160713T184628Z:892a7c7a-28f4-4bec-bc8b-e7e52115d8b9
Date                          : Wed, 13 Jul 2016 18:46:28 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:46:58 PM: 055da904-37b4-4caa-93c3-e9a1f4bc09ec - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:46:58 PM: 055da904-37b4-4caa-93c3-e9a1f4bc09ec - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:46:58 PM: 055da904-37b4-4caa-93c3-e9a1f4bc09ec - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:46:58 PM: 055da904-37b4-4caa-93c3-e9a1f4bc09ec - TokenCache: 53.14086956 minut
es left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:46:58 PM: 055da904-37b4-4caa-93c3-e9a1f4bc09ec - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:46:58 PM: 055da904-37b4-4caa-93c3-e9a1f4bc09ec - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : edd102a1-212c-44c7-90cf-a21dc4d3c171
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14988
x-ms-correlation-request-id   : 517b7640-5bca-4970-a661-34cd6b6fe07d
x-ms-routing-request-id       : WESTUS:20160713T184658Z:517b7640-5bca-4970-a661-34cd6b6fe07d
Date                          : Wed, 13 Jul 2016 18:46:57 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:47:28 PM: aa1fa5b6-9446-4de0-a453-69758b23bd99 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:47:28 PM: aa1fa5b6-9446-4de0-a453-69758b23bd99 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:47:28 PM: aa1fa5b6-9446-4de0-a453-69758b23bd99 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:47:28 PM: aa1fa5b6-9446-4de0-a453-69758b23bd99 - TokenCache: 52.6365456066667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:47:28 PM: aa1fa5b6-9446-4de0-a453-69758b23bd99 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:47:28 PM: aa1fa5b6-9446-4de0-a453-69758b23bd99 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 1aeb703f-44ff-4eea-b617-f1d06a7f9359
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14987
x-ms-correlation-request-id   : 3370d184-02a5-4b50-98c1-8cc3f26ac3a8
x-ms-routing-request-id       : WESTUS:20160713T184728Z:3370d184-02a5-4b50-98c1-8cc3f26ac3a8
Date                          : Wed, 13 Jul 2016 18:47:27 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:47:58 PM: 2d86006d-c391-4807-9adc-70847a38268c - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:47:58 PM: 2d86006d-c391-4807-9adc-70847a38268c - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:47:58 PM: 2d86006d-c391-4807-9adc-70847a38268c - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:47:58 PM: 2d86006d-c391-4807-9adc-70847a38268c - TokenCache: 52.1351285916667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:47:58 PM: 2d86006d-c391-4807-9adc-70847a38268c - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:47:58 PM: 2d86006d-c391-4807-9adc-70847a38268c - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 4ad4331f-d957-4559-afb7-20d56ab77371
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14986
x-ms-correlation-request-id   : d13071da-d699-48fd-88e4-d660f5ae7c9f
x-ms-routing-request-id       : WESTUS:20160713T184758Z:d13071da-d699-48fd-88e4-d660f5ae7c9f
Date                          : Wed, 13 Jul 2016 18:47:58 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:48:28 PM: 5243d7bb-8e0c-4890-bbf7-2ed22156c3ef - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:48:28 PM: 5243d7bb-8e0c-4890-bbf7-2ed22156c3ef - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:48:28 PM: 5243d7bb-8e0c-4890-bbf7-2ed22156c3ef - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:48:28 PM: 5243d7bb-8e0c-4890-bbf7-2ed22156c3ef - TokenCache: 51.6308257083333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:48:28 PM: 5243d7bb-8e0c-4890-bbf7-2ed22156c3ef - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:48:28 PM: 5243d7bb-8e0c-4890-bbf7-2ed22156c3ef - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : b33530b2-7dba-4cd7-9ed9-0efa85c62723
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14985
x-ms-correlation-request-id   : ee51e755-e403-4fca-aba5-01e60881140f
x-ms-routing-request-id       : WESTUS:20160713T184828Z:ee51e755-e403-4fca-aba5-01e60881140f
Date                          : Wed, 13 Jul 2016 18:48:28 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:48:58 PM: cbceeadf-8b7d-4d44-8c3f-19a3125e36f8 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:48:58 PM: cbceeadf-8b7d-4d44-8c3f-19a3125e36f8 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:48:58 PM: cbceeadf-8b7d-4d44-8c3f-19a3125e36f8 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:48:58 PM: cbceeadf-8b7d-4d44-8c3f-19a3125e36f8 - TokenCache: 51.1294343716667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:48:58 PM: cbceeadf-8b7d-4d44-8c3f-19a3125e36f8 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:48:58 PM: cbceeadf-8b7d-4d44-8c3f-19a3125e36f8 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : abf75089-2ff3-42ae-993a-ef93e0ba038d
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14984
x-ms-correlation-request-id   : 960b534e-52f7-4524-a8d5-c37add8a67c5
x-ms-routing-request-id       : WESTUS:20160713T184858Z:960b534e-52f7-4524-a8d5-c37add8a67c5
Date                          : Wed, 13 Jul 2016 18:48:58 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:49:28 PM: 724ecf69-b112-4bc4-b615-f82ce65e5710 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:49:28 PM: 724ecf69-b112-4bc4-b615-f82ce65e5710 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:49:28 PM: 724ecf69-b112-4bc4-b615-f82ce65e5710 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:49:28 PM: 724ecf69-b112-4bc4-b615-f82ce65e5710 - TokenCache: 50.628179515 minu
tes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:49:28 PM: 724ecf69-b112-4bc4-b615-f82ce65e5710 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:49:28 PM: 724ecf69-b112-4bc4-b615-f82ce65e5710 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 8f798ea2-b5f8-48fa-94ea-b468c8d32e4c
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14983
x-ms-correlation-request-id   : 23b3c093-2c03-4135-982b-f01702c80401
x-ms-routing-request-id       : WESTUS:20160713T184929Z:23b3c093-2c03-4135-982b-f01702c80401
Date                          : Wed, 13 Jul 2016 18:49:28 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:49:59 PM: 1d32a0d0-c6c0-4fde-b16b-b4c26011b8b3 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:49:59 PM: 1d32a0d0-c6c0-4fde-b16b-b4c26011b8b3 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:49:59 PM: 1d32a0d0-c6c0-4fde-b16b-b4c26011b8b3 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:49:59 PM: 1d32a0d0-c6c0-4fde-b16b-b4c26011b8b3 - TokenCache: 50.12319892 minut
es left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:49:59 PM: 1d32a0d0-c6c0-4fde-b16b-b4c26011b8b3 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:49:59 PM: 1d32a0d0-c6c0-4fde-b16b-b4c26011b8b3 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : ec4c646c-01ed-479e-8a50-d0ff478974bb
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14982
x-ms-correlation-request-id   : 5af85b61-9582-420f-a091-3d0638688404
x-ms-routing-request-id       : WESTUS:20160713T184959Z:5af85b61-9582-420f-a091-3d0638688404
Date                          : Wed, 13 Jul 2016 18:49:58 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:50:29 PM: 22578542-2508-4ba5-a4c4-de03ba96221a - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:50:29 PM: 22578542-2508-4ba5-a4c4-de03ba96221a - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:50:29 PM: 22578542-2508-4ba5-a4c4-de03ba96221a - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:50:29 PM: 22578542-2508-4ba5-a4c4-de03ba96221a - TokenCache: 49.6216866866667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:50:29 PM: 22578542-2508-4ba5-a4c4-de03ba96221a - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:50:29 PM: 22578542-2508-4ba5-a4c4-de03ba96221a - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : a9a2873e-e649-4154-9f5e-e91650925635
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14983
x-ms-correlation-request-id   : 053ef5dc-0d26-4af0-9797-bbd26190eaf4
x-ms-routing-request-id       : WESTUS:20160713T185029Z:053ef5dc-0d26-4af0-9797-bbd26190eaf4
Date                          : Wed, 13 Jul 2016 18:50:28 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:50:59 PM: 9a82fbe3-0b65-4226-96c4-91a2cd6ce2c1 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:50:59 PM: 9a82fbe3-0b65-4226-96c4-91a2cd6ce2c1 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:50:59 PM: 9a82fbe3-0b65-4226-96c4-91a2cd6ce2c1 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:50:59 PM: 9a82fbe3-0b65-4226-96c4-91a2cd6ce2c1 - TokenCache: 49.1201261666667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:50:59 PM: 9a82fbe3-0b65-4226-96c4-91a2cd6ce2c1 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:50:59 PM: 9a82fbe3-0b65-4226-96c4-91a2cd6ce2c1 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 65f86ff9-7dce-4b0e-ab0e-27c5811556cf
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14996
x-ms-correlation-request-id   : 445d5d62-81fb-41eb-8a9f-3743fe5294d4
x-ms-routing-request-id       : WESTUS:20160713T185100Z:445d5d62-81fb-41eb-8a9f-3743fe5294d4
Date                          : Wed, 13 Jul 2016 18:51:00 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:51:30 PM: 8e776557-17df-4198-a53e-f62a2ffc55ee - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:51:30 PM: 8e776557-17df-4198-a53e-f62a2ffc55ee - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:51:30 PM: 8e776557-17df-4198-a53e-f62a2ffc55ee - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:51:30 PM: 8e776557-17df-4198-a53e-f62a2ffc55ee - TokenCache: 48.6034435 minute
s left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:51:30 PM: 8e776557-17df-4198-a53e-f62a2ffc55ee - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:51:30 PM: 8e776557-17df-4198-a53e-f62a2ffc55ee - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : e6e58edb-8568-48e4-b547-5bb5420fc018
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14995
x-ms-correlation-request-id   : 10fdb460-ed9f-4746-9e14-a1acf7478c38
x-ms-routing-request-id       : WESTUS:20160713T185130Z:10fdb460-ed9f-4746-9e14-a1acf7478c38
Date                          : Wed, 13 Jul 2016 18:51:30 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:52:00 PM: bb5dd188-6e0e-407d-9e18-8db5251cfb03 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:52:00 PM: bb5dd188-6e0e-407d-9e18-8db5251cfb03 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:52:00 PM: bb5dd188-6e0e-407d-9e18-8db5251cfb03 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:52:00 PM: bb5dd188-6e0e-407d-9e18-8db5251cfb03 - TokenCache: 48.1018693683333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:52:00 PM: bb5dd188-6e0e-407d-9e18-8db5251cfb03 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:52:00 PM: bb5dd188-6e0e-407d-9e18-8db5251cfb03 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : acfddfea-af61-4356-ab3e-e76e6a2788f4
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14994
x-ms-correlation-request-id   : c7528de8-caaf-4ef9-9477-c3d59655b96e
x-ms-routing-request-id       : WESTUS:20160713T185200Z:c7528de8-caaf-4ef9-9477-c3d59655b96e
Date                          : Wed, 13 Jul 2016 18:51:59 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:52:30 PM: 098ac7dc-6231-4a58-a9c8-e69bd676a986 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:52:30 PM: 098ac7dc-6231-4a58-a9c8-e69bd676a986 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:52:30 PM: 098ac7dc-6231-4a58-a9c8-e69bd676a986 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:52:30 PM: 098ac7dc-6231-4a58-a9c8-e69bd676a986 - TokenCache: 47.6004736733333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:52:30 PM: 098ac7dc-6231-4a58-a9c8-e69bd676a986 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:52:30 PM: 098ac7dc-6231-4a58-a9c8-e69bd676a986 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : f2e3a092-8737-40c6-b40c-f7ddbd3f2644
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14993
x-ms-correlation-request-id   : 89e50306-b518-4c01-aa3b-260b410da6b1
x-ms-routing-request-id       : WESTUS:20160713T185230Z:89e50306-b518-4c01-aa3b-260b410da6b1
Date                          : Wed, 13 Jul 2016 18:52:30 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:53:00 PM: 4c4fae53-baac-41f3-8a39-8bb53e5d39af - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:53:00 PM: 4c4fae53-baac-41f3-8a39-8bb53e5d39af - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:53:00 PM: 4c4fae53-baac-41f3-8a39-8bb53e5d39af - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:53:00 PM: 4c4fae53-baac-41f3-8a39-8bb53e5d39af - TokenCache: 47.096699015 minu
tes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:53:00 PM: 4c4fae53-baac-41f3-8a39-8bb53e5d39af - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:53:00 PM: 4c4fae53-baac-41f3-8a39-8bb53e5d39af - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 9dc8aa31-b5c4-4785-ae63-e72f8d1e679a
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14992
x-ms-correlation-request-id   : 86fdeabe-3472-4c34-a800-34c079b6b3fa
x-ms-routing-request-id       : WESTUS:20160713T185300Z:86fdeabe-3472-4c34-a800-34c079b6b3fa
Date                          : Wed, 13 Jul 2016 18:52:59 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:53:30 PM: 97e6ebeb-0783-4355-829d-b7ddde86559d - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:53:30 PM: 97e6ebeb-0783-4355-829d-b7ddde86559d - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:53:30 PM: 97e6ebeb-0783-4355-829d-b7ddde86559d - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:53:30 PM: 97e6ebeb-0783-4355-829d-b7ddde86559d - TokenCache: 46.5952818466667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:53:30 PM: 97e6ebeb-0783-4355-829d-b7ddde86559d - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:53:30 PM: 97e6ebeb-0783-4355-829d-b7ddde86559d - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : c3fd1903-c6ea-4f7e-bf30-c3b3c15cd137
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14991
x-ms-correlation-request-id   : e1a6cae8-bab9-453b-8b21-fd9cf8b8915f
x-ms-routing-request-id       : WESTUS:20160713T185330Z:e1a6cae8-bab9-453b-8b21-fd9cf8b8915f
Date                          : Wed, 13 Jul 2016 18:53:30 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:54:01 PM: dc54df5d-28e0-423a-92ca-5efb3b397f51 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:54:01 PM: dc54df5d-28e0-423a-92ca-5efb3b397f51 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:54:01 PM: dc54df5d-28e0-423a-92ca-5efb3b397f51 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:54:01 PM: dc54df5d-28e0-423a-92ca-5efb3b397f51 - TokenCache: 46.093792275 minu
tes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:54:01 PM: dc54df5d-28e0-423a-92ca-5efb3b397f51 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:54:01 PM: dc54df5d-28e0-423a-92ca-5efb3b397f51 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 9f41d120-33b5-4211-baa9-0650f15cf983
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14990
x-ms-correlation-request-id   : 74564850-315a-4483-bcba-3cafc9396b38
x-ms-routing-request-id       : WESTUS:20160713T185401Z:74564850-315a-4483-bcba-3cafc9396b38
Date                          : Wed, 13 Jul 2016 18:54:00 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:54:31 PM: b65979bc-766c-4f8e-9b13-47650ed1edaa - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:54:31 PM: b65979bc-766c-4f8e-9b13-47650ed1edaa - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:54:31 PM: b65979bc-766c-4f8e-9b13-47650ed1edaa - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:54:31 PM: b65979bc-766c-4f8e-9b13-47650ed1edaa - TokenCache: 45.5894228566667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:54:31 PM: b65979bc-766c-4f8e-9b13-47650ed1edaa - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:54:31 PM: b65979bc-766c-4f8e-9b13-47650ed1edaa - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : ae73d3ab-0e33-42ec-b4cb-48bb4f1cfb56
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14989
x-ms-correlation-request-id   : 39e7d8b8-ef32-4184-84c8-fb422667f1b5
x-ms-routing-request-id       : WESTUS:20160713T185431Z:39e7d8b8-ef32-4184-84c8-fb422667f1b5
Date                          : Wed, 13 Jul 2016 18:54:30 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:55:01 PM: 27293e8c-637a-469d-b898-e8d3c436fde1 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:55:01 PM: 27293e8c-637a-469d-b898-e8d3c436fde1 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:55:01 PM: 27293e8c-637a-469d-b898-e8d3c436fde1 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:55:01 PM: 27293e8c-637a-469d-b898-e8d3c436fde1 - TokenCache: 45.087871365 minu
tes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:55:01 PM: 27293e8c-637a-469d-b898-e8d3c436fde1 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:55:01 PM: 27293e8c-637a-469d-b898-e8d3c436fde1 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 09e808c3-cb70-4a1f-a382-6781d584dca1
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14989
x-ms-correlation-request-id   : a2ed918c-5ef8-48f6-82f8-679997a95760
x-ms-routing-request-id       : WESTUS:20160713T185501Z:a2ed918c-5ef8-48f6-82f8-679997a95760
Date                          : Wed, 13 Jul 2016 18:55:00 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:55:31 PM: 887404c0-6deb-45bf-a3f2-88a5da559565 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:55:31 PM: 887404c0-6deb-45bf-a3f2-88a5da559565 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:55:31 PM: 887404c0-6deb-45bf-a3f2-88a5da559565 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:55:31 PM: 887404c0-6deb-45bf-a3f2-88a5da559565 - TokenCache: 44.5865141933333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:55:31 PM: 887404c0-6deb-45bf-a3f2-88a5da559565 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:55:31 PM: 887404c0-6deb-45bf-a3f2-88a5da559565 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : ceb315ad-762e-48d3-a537-8853d00e1e8e
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14988
x-ms-correlation-request-id   : ef35b0d8-26e3-44fc-a816-2a272d5be9ac
x-ms-routing-request-id       : WESTUS:20160713T185531Z:ef35b0d8-26e3-44fc-a816-2a272d5be9ac
Date                          : Wed, 13 Jul 2016 18:55:30 GMT
Connection                    : close

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "status": "InProgress",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:01 PM: dc72a1c5-12f5-431b-81d4-3190b364758c - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:01 PM: dc72a1c5-12f5-431b-81d4-3190b364758c - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:01 PM: dc72a1c5-12f5-431b-81d4-3190b364758c - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:01 PM: dc72a1c5-12f5-431b-81d4-3190b364758c - TokenCache: 44.0849574383333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:01 PM: dc72a1c5-12f5-431b-81d4-3190b364758c - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:01 PM: dc72a1c5-12f5-431b-81d4-3190b364758c - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/1ab5875e-02d1-42ca-8702-0f7243518055?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 8c37de99-68b7-4b1c-ad0a-06001f49f81b
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14991
x-ms-correlation-request-id   : ace445ac-af53-4747-a891-adedcb4c29c3
x-ms-routing-request-id       : CENTRALUS:20160713T185601Z:ace445ac-af53-4747-a891-adedcb4c29c3
Date                          : Wed, 13 Jul 2016 18:56:00 GMT

Body:
{
  "startTime": "2016-07-13T11:42:24.7720612-07:00",
  "endTime": "2016-07-13T11:55:33.5376078-07:00",
  "status": "Succeeded",
  "name": "1ab5875e-02d1-42ca-8702-0f7243518055"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:01 PM: 7b2c3047-7c1c-4c22-92d8-f2b5313a0742 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:01 PM: 7b2c3047-7c1c-4c22-92d8-f2b5313a0742 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:01 PM: 7b2c3047-7c1c-4c22-92d8-f2b5313a0742 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:01 PM: 7b2c3047-7c1c-4c22-92d8-f2b5313a0742 - TokenCache: 44.0791662133333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:01 PM: 7b2c3047-7c1c-4c22-92d8-f2b5313a0742 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:01 PM: 7b2c3047-7c1c-4c22-92d8-f2b5313a0742 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/my
group2/providers/Microsoft.Compute/virtualMachines/myvm2?api-version=2016-03-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 77a3b0fe-ef8b-40b9-830e-e689707f5a7c
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14990
x-ms-correlation-request-id   : c0253e0f-37bb-4e97-986c-8f025dd212e1
x-ms-routing-request-id       : CENTRALUS:20160713T185601Z:c0253e0f-37bb-4e97-986c-8f025dd212e1
Date                          : Wed, 13 Jul 2016 18:56:00 GMT

Body:
{
  "properties": {
    "vmId": "e59a8e59-e59e-44a7-8721-b74c4380e5ae",
    "availabilitySet": {
      "id": "/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/mygroup2/provider
s/Microsoft.Compute/availabilitySets/AVAILABILITYSET01"
    },
    "hardwareProfile": {
      "vmSize": "Standard_A1"
    },
    "storageProfile": {
      "osDisk": {
        "osType": "Windows",
        "name": "myvm2_osDisk",
        "createOption": "FromImage",
        "image": {
          "uri": "https://mystorageaccountft.blob.core.windows.net/system/Microsoft.Compute/Image
s/image/customimage-osDisk.7e5505ce-57c5-4cbb-a881-258a60b5c2df.vhd"
        },
        "vhd": {
          "uri": "https://mystorageaccountft.blob.core.windows.net/vhds/myvm2_os.vhd"
        },
        "caching": "ReadWrite"
      },
      "dataDisks": []
    },
    "osProfile": {
      "computerName": "myvm2",
      "adminUsername": "youaretheadmin",
      "windowsConfiguration": {
        "provisionVMAgent": true,
        "enableAutomaticUpdates": true
      },
      "secrets": []
    },
    "networkProfile": {
      "networkInterfaces": [
        {
          "id": "/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/mygroup2/prov
iders/Microsoft.Network/networkInterfaces/mynic2"
        }
      ]
    },
    "diagnosticsProfile": {
      "bootDiagnostics": {
        "enabled": true,
        "storageUri": "https://mystorageaccountft.blob.core.windows.net/"
      }
    },
    "provisioningState": "Succeeded"
  },
  "id": "/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/mygroup2/providers/Mi
crosoft.Compute/virtualMachines/myvm2",
  "name": "myvm2",
  "type": "Microsoft.Compute/virtualMachines",
  "location": "centralus"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: 5622c35b-c406-486a-9db1-b4641dcf0158 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:02 PM: 5622c35b-c406-486a-9db1-b4641dcf0158 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: 5622c35b-c406-486a-9db1-b4641dcf0158 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:02 PM: 5622c35b-c406-486a-9db1-b4641dcf0158 - TokenCache: 44.0771508916667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: 5622c35b-c406-486a-9db1-b4641dcf0158 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: 5622c35b-c406-486a-9db1-b4641dcf0158 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/publishers?api-version=2016-03-30

Headers:
x-ms-client-request-id        : 97400501-94d2-4ebf-a5b4-7da7deb51327
accept-language               : en-US

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-request-id               : 63a63ff7-ad83-41cc-b9f9-d947aa03cd93
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14989
x-ms-correlation-request-id   : 026ffd00-3e9e-4792-b7ca-5404c6cad9a1
x-ms-routing-request-id       : CENTRALUS:20160713T185602Z:026ffd00-3e9e-4792-b7ca-5404c6cad9a1
Date                          : Wed, 13 Jul 2016 18:56:01 GMT

Body:
[{"location":"centralus","name":"4psa","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/
Providers/Microsoft.Compute/Locations/centralus/Publishers/4psa"},{"location":"centralus","name":
"4ward365","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/
Locations/centralus/Publishers/4ward365"},{"location":"centralus","name":"7isolutions","id":"/Sub
scriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/P
ublishers/7isolutions"},{"location":"centralus","name":"a10networks","id":"/Subscriptions/6b6a59a
6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/a10netwo
rks"},{"location":"centralus","name":"abiquo","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686
2095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/abiquo"},{"location":"centralus
","name":"accellion","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsof
t.Compute/Locations/centralus/Publishers/accellion"},{"location":"centralus","name":"Acronis","id
":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cent
ralus/Publishers/Acronis"},{"location":"centralus","name":"Acronis.Abokov.Backup","id":"/Subscrip
tions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publis
hers/Acronis.Abokov.Backup"},{"location":"centralus","name":"Acronis.Backup","id":"/Subscriptions
/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/
Acronis.Backup"},{"location":"centralus","name":"Acronis2","id":"/Subscriptions/6b6a59a6-e367-491
3-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Acronis2"},{"locat
ion":"centralus","name":"Acronis2.Abokov.Backup","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b
6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Acronis2.Abokov.Backup"},{"l
ocation":"centralus","name":"actian_matrix","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68620
95bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/actian_matrix"},{"location":"cent
ralus","name":"active-navigation","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provi
ders/Microsoft.Compute/Locations/centralus/Publishers/active-navigation"},{"location":"centralus"
,"name":"activeeon","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft
.Compute/Locations/centralus/Publishers/activeeon"},{"location":"centralus","name":"adam-software
","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations
/centralus/Publishers/adam-software"},{"location":"centralus","name":"adatao","id":"/Subscription
s/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers
/adatao"},{"location":"centralus","name":"adobe","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b
6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/adobe"},{"location":"central
us","name":"adobe_test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micro
soft.Compute/Locations/centralus/Publishers/adobe_test"},{"location":"centralus","name":"adra-mat
ch","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locatio
ns/centralus/Publishers/adra-match"},{"location":"centralus","name":"advantech","id":"/Subscripti
ons/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishe
rs/advantech"},{"location":"centralus","name":"advantech-webaccess","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/advantech
-webaccess"},{"location":"centralus","name":"aerospike","id":"/Subscriptions/6b6a59a6-e367-4913-b
ea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/aerospike"},{"locatio
n":"centralus","name":"aerospike-database","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/aerospike-database"},{"location":"
centralus","name":"aimsinnovation","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Prov
iders/Microsoft.Compute/Locations/centralus/Publishers/aimsinnovation"},{"location":"centralus","
name":"aiscaler-cache-control-ddos-and-url-rewriting-","id":"/Subscriptions/6b6a59a6-e367-4913-be
a7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/aiscaler-cache-control
-ddos-and-url-rewriting-"},{"location":"centralus","name":"akeron","id":"/Subscriptions/6b6a59a6-
e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/akeron"},{
"location":"centralus","name":"akumina","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/akumina"},{"location":"centralus","na
me":"alachisoft","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Co
mpute/Locations/centralus/Publishers/alachisoft"},{"location":"centralus","name":"alertlogic","id
":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cent
ralus/Publishers/alertlogic"},{"location":"centralus","name":"AlertLogic.Extension","id":"/Subscr
iptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publ
ishers/AlertLogic.Extension"},{"location":"centralus","name":"algebraix-data","id":"/Subscription
s/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers
/algebraix-data"},{"location":"centralus","name":"alldigital-brevity","id":"/Subscriptions/6b6a59
a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/alldigi
tal-brevity"},{"location":"centralus","name":"alteryx","id":"/Subscriptions/6b6a59a6-e367-4913-be
a7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/alteryx"},{"location":
"centralus","name":"altiar","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/M
icrosoft.Compute/Locations/centralus/Publishers/altiar"},{"location":"centralus","name":"alvao","
id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/ce
ntralus/Publishers/alvao"},{"location":"centralus","name":"analitica","id":"/Subscriptions/6b6a59
a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/analiti
ca"},{"location":"centralus","name":"angoss","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862
095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/angoss"},{"location":"centralus"
,"name":"apigee","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Co
mpute/Locations/centralus/Publishers/apigee"},{"location":"centralus","name":"appcelerator","id":
"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centra
lus/Publishers/appcelerator"},{"location":"centralus","name":"appcitoinc","id":"/Subscriptions/6b
6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/app
citoinc"},{"location":"centralus","name":"appex-networks","id":"/Subscriptions/6b6a59a6-e367-4913
-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/appex-networks"},{"
location":"centralus","name":"appistry","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/appistry"},{"location":"centralus","n
ame":"apprenda","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Com
pute/Locations/centralus/Publishers/apprenda"},{"location":"centralus","name":"appveyorci","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/appveyorci"},{"location":"centralus","name":"appzero","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/appzero"}
,{"location":"centralus","name":"arangodb","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/arangodb"},{"location":"centralus"
,"name":"aras","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/aras"},{"location":"centralus","name":"array_networks","id":"/
Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralu
s/Publishers/array_networks"},{"location":"centralus","name":"aspera","id":"/Subscriptions/6b6a59
a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/aspera"
},{"location":"centralus","name":"aspex","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095b
f/Providers/Microsoft.Compute/Locations/centralus/Publishers/aspex"},{"location":"centralus","nam
e":"aspex-managed-cloud","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micr
osoft.Compute/Locations/centralus/Publishers/aspex-managed-cloud"},{"location":"centralus","name"
:"attunity_cloudbeam","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/attunity_cloudbeam"},{"location":"centralus","name":"au
raportal","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/L
ocations/centralus/Publishers/auraportal"},{"location":"centralus","name":"auriq-systems","id":"/
Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralu
s/Publishers/auriq-systems"},{"location":"centralus","name":"avepoint","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/avepoi
nt"},{"location":"centralus","name":"averesystems","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-3
4b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/averesystems"},{"location"
:"centralus","name":"aviatrix-systems","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/
Providers/Microsoft.Compute/Locations/centralus/Publishers/aviatrix-systems"},{"location":"centra
lus","name":"awingu","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsof
t.Compute/Locations/centralus/Publishers/awingu"},{"location":"centralus","name":"axway","id":"/S
ubscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus
/Publishers/axway"},{"location":"centralus","name":"azul","id":"/Subscriptions/6b6a59a6-e367-4913
-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/azul"},{"location":
"centralus","name":"AzureRT.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provi
ders/Microsoft.Compute/Locations/centralus/Publishers/AzureRT.Test"},{"location":"centralus","nam
e":"azuresyncfusion","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsof
t.Compute/Locations/centralus/Publishers/azuresyncfusion"},{"location":"centralus","name":"AzureT
ools1type","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/
Locations/centralus/Publishers/AzureTools1type"},{"location":"centralus","name":"AzureTools1type1
00","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locatio
ns/centralus/Publishers/AzureTools1type100"},{"location":"centralus","name":"AzureTools1type200",
"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/c
entralus/Publishers/AzureTools1type200"},{"location":"centralus","name":"balabit","id":"/Subscrip
tions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publis
hers/balabit"},{"location":"centralus","name":"Barracuda.Azure.ConnectivityAgent","id":"/Subscrip
tions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publis
hers/Barracuda.Azure.ConnectivityAgent"},{"location":"centralus","name":"barracudanetworks","id":
"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centra
lus/Publishers/barracudanetworks"},{"location":"centralus","name":"basho","id":"/Subscriptions/6b
6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/bas
ho"},{"location":"centralus","name":"Bitnami","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686
2095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Bitnami"},{"location":"centralu
s","name":"bizagi","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.
Compute/Locations/centralus/Publishers/bizagi"},{"location":"centralus","name":"biztalk360","id":
"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centra
lus/Publishers/biztalk360"},{"location":"centralus","name":"blackberry","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/black
berry"},{"location":"centralus","name":"blockapps","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-3
4b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/blockapps"},{"location":"c
entralus","name":"bluetalon","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/
Microsoft.Compute/Locations/centralus/Publishers/bluetalon"},{"location":"centralus","name":"bmc.
com","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/bmc.com"},{"location":"centralus","name":"bmc.ctm","id":"/Subscriptions/
6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/b
mc.ctm"},{"location":"centralus","name":"bmc.ctm.agent","id":"/Subscriptions/6b6a59a6-e367-4913-b
ea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/bmc.ctm.agent"},{"loc
ation":"centralus","name":"bmcctm.josh","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/bmcctm.josh"},{"location":"centralus"
,"name":"bmcctm.test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/bmcctm.test"},{"location":"centralus","name":"boundless
geo","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/boundlessgeo"},{"location":"centralus","name":"boxless","id":"/Subscript
ions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publish
ers/boxless"},{"location":"centralus","name":"brainshare-it","id":"/Subscriptions/6b6a59a6-e367-4
913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/brainshare-it"},
{"location":"centralus","name":"brocade_communications","id":"/Subscriptions/6b6a59a6-e367-4913-b
ea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/brocade_communication
s"},{"location":"centralus","name":"bryte","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/bryte"},{"location":"centralus","n
ame":"bssw","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute
/Locations/centralus/Publishers/bssw"},{"location":"centralus","name":"buddhalabs","id":"/Subscri
ptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publi
shers/buddhalabs"},{"location":"centralus","name":"bugrius","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/bugrius"},{"locat
ion":"centralus","name":"bwappengine","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/P
roviders/Microsoft.Compute/Locations/centralus/Publishers/bwappengine"},{"location":"centralus","
name":"Canonical","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/Canonical"},{"location":"centralus","name":"caringo","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/caringo"},{"location":"centralus","name":"catechnologies","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/catec
hnologies"},{"location":"centralus","name":"cautelalabs","id":"/Subscriptions/6b6a59a6-e367-4913-
bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cautelalabs"},{"loca
tion":"centralus","name":"cds","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/cds"},{"location":"centralus","name":"certivox
","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations
/centralus/Publishers/certivox"},{"location":"centralus","name":"checkpoint","id":"/Subscriptions
/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/
checkpoint"},{"location":"centralus","name":"checkpointsystems","id":"/Subscriptions/6b6a59a6-e36
7-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/checkpointsys
tems"},{"location":"centralus","name":"chef-software","id":"/Subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/chef-software"},{"locat
ion":"centralus","name":"Chef.Bootstrap.WindowsAzure","id":"/Subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Chef.Bootstrap.WindowsA
zure"},{"location":"centralus","name":"cherwell","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b
6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cherwell"},{"location":"cent
ralus","name":"cipherpoint","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/M
icrosoft.Compute/Locations/centralus/Publishers/cipherpoint"},{"location":"centralus","name":"cir
cleci","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Loca
tions/centralus/Publishers/circleci"},{"location":"centralus","name":"cires21","id":"/Subscriptio
ns/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publisher
s/cires21"},{"location":"centralus","name":"cisco","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-3
4b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cisco"},{"location":"centr
alus","name":"citrix","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/citrix"},{"location":"centralus","name":"clickberry","i
d":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cen
tralus/Publishers/clickberry"},{"location":"centralus","name":"cloud-cruiser","id":"/Subscription
s/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers
/cloud-cruiser"},{"location":"centralus","name":"cloudbees","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cloudbees"},{"loc
ation":"centralus","name":"cloudbees-enterprise-jenkins","id":"/Subscriptions/6b6a59a6-e367-4913-
bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cloudbees-enterprise
-jenkins"},{"location":"centralus","name":"cloudbolt-software","id":"/Subscriptions/6b6a59a6-e367
-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cloudbolt-soft
ware"},{"location":"centralus","name":"cloudboost","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-3
4b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cloudboost"},{"location":"
centralus","name":"cloudcoreo","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/cloudcoreo"},{"location":"centralus","name":"c
loudera","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Lo
cations/centralus/Publishers/cloudera"},{"location":"centralus","name":"cloudera1qaz2wsx","id":"/
Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralu
s/Publishers/cloudera1qaz2wsx"},{"location":"centralus","name":"cloudhouse","id":"/Subscriptions/
6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/c
loudhouse"},{"location":"centralus","name":"cloudlink","id":"/Subscriptions/6b6a59a6-e367-4913-be
a7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cloudlink"},{"location
":"centralus","name":"CloudLink.SecureVM","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095
bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/CloudLink.SecureVM"},{"location":"c
entralus","name":"CloudLink.SecureVM.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/CloudLink.SecureVM.Test"},{"locati
on":"centralus","name":"CloudLinkEMC.SecureVM","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/CloudLinkEMC.SecureVM"},{"loca
tion":"centralus","name":"CloudLinkEMC.SecureVM.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/CloudLinkEMC.SecureVM.T
est"},{"location":"centralus","name":"cloudsoft","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b
6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cloudsoft"},{"location":"cen
tralus","name":"clustrix","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mic
rosoft.Compute/Locations/centralus/Publishers/clustrix"},{"location":"centralus","name":"codelath
e","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Location
s/centralus/Publishers/codelathe"},{"location":"centralus","name":"codenvy","id":"/Subscriptions/
6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/c
odenvy"},{"location":"centralus","name":"cognosys","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-3
4b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cognosys"},{"location":"ce
ntralus","name":"cohesive","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mi
crosoft.Compute/Locations/centralus/Publishers/cohesive"},{"location":"centralus","name":"commvau
lt","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locatio
ns/centralus/Publishers/commvault"},{"location":"centralus","name":"companyname-short","id":"/Sub
scriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/P
ublishers/companyname-short"},{"location":"centralus","name":"comunity","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/comun
ity"},{"location":"centralus","name":"Confer","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686
2095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Confer"},{"location":"centralus
","name":"Confer.TestSensor","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/
Microsoft.Compute/Locations/centralus/Publishers/Confer.TestSensor"},{"location":"centralus","nam
e":"confluentinc","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/confluentinc"},{"location":"centralus","name":"consensys","
id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/ce
ntralus/Publishers/consensys"},{"location":"centralus","name":"convertigo","id":"/Subscriptions/6
b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/co
nvertigo"},{"location":"centralus","name":"cordis","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-3
4b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/cordis"},{"location":"cent
ralus","name":"corent-technology-pvt","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/P
roviders/Microsoft.Compute/Locations/centralus/Publishers/corent-technology-pvt"},{"location":"ce
ntralus","name":"CoreOS","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micr
osoft.Compute/Locations/centralus/Publishers/CoreOS"},{"location":"centralus","name":"cortical-io
","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations
/centralus/Publishers/cortical-io"},{"location":"centralus","name":"couchbase","id":"/Subscriptio
ns/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publisher
s/couchbase"},{"location":"centralus","name":"credativ","id":"/Subscriptions/6b6a59a6-e367-4913-b
ea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/credativ"},{"location
":"centralus","name":"csstest","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/csstest"},{"location":"centralus","name":"ctm.
bmc.com","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Lo
cations/centralus/Publishers/ctm.bmc.com"},{"location":"centralus","name":"dalet","id":"/Subscrip
tions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publis
hers/dalet"},{"location":"centralus","name":"danielsol.AzureTools1","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/danielsol
.AzureTools1"},{"location":"centralus","name":"danielsol.AzureTools1pns","id":"/Subscriptions/6b6
a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/dani
elsol.AzureTools1pns"},{"location":"centralus","name":"danielsol.AzureTools1pns2","id":"/Subscrip
tions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publis
hers/danielsol.AzureTools1pns2"},{"location":"centralus","name":"danielsol.AzureTools1pns3","id":
"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centra
lus/Publishers/danielsol.AzureTools1pns3"},{"location":"centralus","name":"Dans.Windows.App","id"
:"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centr
alus/Publishers/Dans.Windows.App"},{"location":"centralus","name":"Dans2.Windows.App","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/Dans2.Windows.App"},{"location":"centralus","name":"Dans3.Windows.App","id":"/Subscripti
ons/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishe
rs/Dans3.Windows.App"},{"location":"centralus","name":"dataart","id":"/Subscriptions/6b6a59a6-e36
7-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/dataart"},{"l
ocation":"centralus","name":"datacastle","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095b
f/Providers/Microsoft.Compute/Locations/centralus/Publishers/datacastle"},{"location":"centralus"
,"name":"Datadog.Agent","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micro
soft.Compute/Locations/centralus/Publishers/Datadog.Agent"},{"location":"centralus","name":"datae
xpeditioninc","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compu
te/Locations/centralus/Publishers/dataexpeditioninc"},{"location":"centralus","name":"dataiku","i
d":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cen
tralus/Publishers/dataiku"},{"location":"centralus","name":"datalayer","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/datala
yer"},{"location":"centralus","name":"dataliberation","id":"/Subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/dataliberation"},{"loca
tion":"centralus","name":"datastax","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pro
viders/Microsoft.Compute/Locations/centralus/Publishers/datastax"},{"location":"centralus","name"
:"datasunrise","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/datasunrise"},{"location":"centralus","name":"defacto_global_"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/defacto_global_"},{"location":"centralus","name":"dell-software","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/dell-software"},{"location":"centralus","name":"dell_software","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/dell_
software"},{"location":"centralus","name":"denyall","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/denyall"},{"location":"ce
ntralus","name":"derdack","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mic
rosoft.Compute/Locations/centralus/Publishers/derdack"},{"location":"centralus","name":"dgsecure"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/dgsecure"},{"location":"centralus","name":"digitaloffice","id":"/Subscriptio
ns/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publisher
s/digitaloffice"},{"location":"centralus","name":"docker","id":"/Subscriptions/6b6a59a6-e367-4913
-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/docker"},{"location
":"centralus","name":"docscorp-us","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Prov
iders/Microsoft.Compute/Locations/centralus/Publishers/docscorp-us"},{"location":"centralus","nam
e":"dolbydeveloper","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft
.Compute/Locations/centralus/Publishers/dolbydeveloper"},{"location":"centralus","name":"dome9","
id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/ce
ntralus/Publishers/dome9"},{"location":"centralus","name":"donovapub","id":"/Subscriptions/6b6a59
a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/donovap
ub"},{"location":"centralus","name":"drone","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68620
95bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/drone"},{"location":"centralus","
name":"dundas","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/dundas"},{"location":"centralus","name":"dynatrace","id":"/Sub
scriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/P
ublishers/dynatrace"},{"location":"centralus","name":"dynatrace.ruxit","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/dynatr
ace.ruxit"},{"location":"centralus","name":"easyterritory","id":"/Subscriptions/6b6a59a6-e367-491
3-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/easyterritory"},{"
location":"centralus","name":"edevtech","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/edevtech"},{"location":"centralus","n
ame":"egress","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compu
te/Locations/centralus/Publishers/egress"},{"location":"centralus","name":"eip","id":"/Subscripti
ons/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishe
rs/eip"},{"location":"centralus","name":"eip-eipower","id":"/Subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/eip-eipower"},{"locatio
n":"centralus","name":"elastacloud","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pro
viders/Microsoft.Compute/Locations/centralus/Publishers/elastacloud"},{"location":"centralus","na
me":"elasticbox","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Co
mpute/Locations/centralus/Publishers/elasticbox"},{"location":"centralus","name":"elecard","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/elecard"},{"location":"centralus","name":"elfiqnetworks","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/elfiqn
etworks"},{"location":"centralus","name":"eloquera","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/eloquera"},{"location":"c
entralus","name":"emercoin","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/M
icrosoft.Compute/Locations/centralus/Publishers/emercoin"},{"location":"centralus","name":"enforo
ngo","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/enforongo"},{"location":"centralus","name":"eperi","id":"/Subscriptions/
6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/e
peri"},{"location":"centralus","name":"equilibrium","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/equilibrium"},{"location"
:"centralus","name":"ESET","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mi
crosoft.Compute/Locations/centralus/Publishers/ESET"},{"location":"centralus","name":"ESET.FileSe
curity","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Loc
ations/centralus/Publishers/ESET.FileSecurity"},{"location":"centralus","name":"esri","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/esri"},{"location":"centralus","name":"eurotech","id":"/Subscriptions/6b6a59a6-e367-4913
-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/eurotech"},{"locati
on":"centralus","name":"evostream-inc","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/
Providers/Microsoft.Compute/Locations/centralus/Publishers/evostream-inc"},{"location":"centralus
","name":"exasol","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/exasol"},{"location":"centralus","name":"exit-games","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/exit-games"},{"location":"centralus","name":"expertime","id":"/Subscriptions/6b6a59
a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/experti
me"},{"location":"centralus","name":"f5-networks","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34
b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/f5-networks"},{"location":"
centralus","name":"fidesys","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/M
icrosoft.Compute/Locations/centralus/Publishers/fidesys"},{"location":"centralus","name":"filebri
dge","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/filebridge"},{"location":"centralus","name":"firehost","id":"/Subscripti
ons/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishe
rs/firehost"},{"location":"centralus","name":"flexerasoftware","id":"/Subscriptions/6b6a59a6-e367
-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/flexerasoftwar
e"},{"location":"centralus","name":"flowforma","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/flowforma"},{"location":"centr
alus","name":"foghorn-systems","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/foghorn-systems"},{"location":"centralus","nam
e":"folio3-dynamics-services","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers
/Microsoft.Compute/Locations/centralus/Publishers/folio3-dynamics-services"},{"location":"central
us","name":"forscene","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/forscene"},{"location":"centralus","name":"fortinet","i
d":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cen
tralus/Publishers/fortinet"},{"location":"centralus","name":"fortycloud","id":"/Subscriptions/6b6
a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/fort
ycloud"},{"location":"centralus","name":"fw","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862
095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/fw"},{"location":"centralus","na
me":"g-data-software","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/g-data-software"},{"location":"centralus","name":"gemal
to-safenet","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute
/Locations/centralus/Publishers/gemalto-safenet"},{"location":"centralus","name":"Gemalto.SafeNet
.ProtectV","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/
Locations/centralus/Publishers/Gemalto.SafeNet.ProtectV"},{"location":"centralus","name":"GitHub"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/GitHub"},{"location":"centralus","name":"gitlab","id":"/Subscriptions/6b6a59
a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/gitlab"
},{"location":"centralus","name":"greathorn","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862
095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/greathorn"},{"location":"central
us","name":"greensql","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/greensql"},{"location":"centralus","name":"gridgain","i
d":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cen
tralus/Publishers/gridgain"},{"location":"centralus","name":"haivision","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/haivi
sion"},{"location":"centralus","name":"halobicloud","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/halobicloud"},{"location"
:"centralus","name":"hanu","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mi
crosoft.Compute/Locations/centralus/Publishers/hanu"},{"location":"centralus","name":"hewlett-pac
kard","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locat
ions/centralus/Publishers/hewlett-packard"},{"location":"centralus","name":"hitachi-solutions","i
d":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cen
tralus/Publishers/hitachi-solutions"},{"location":"centralus","name":"hortonworks","id":"/Subscri
ptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publi
shers/hortonworks"},{"location":"centralus","name":"hpe","id":"/Subscriptions/6b6a59a6-e367-4913-
bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/hpe"},{"location":"c
entralus","name":"HPE.Security.ApplicationDefender","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/HPE.Security.ApplicationD
efender"},{"location":"centralus","name":"humanlogic","id":"/Subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/humanlogic"},{"location
":"centralus","name":"iaansys","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/iaansys"},{"location":"centralus","name":"iamc
loud","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locat
ions/centralus/Publishers/iamcloud"},{"location":"centralus","name":"ibabs-eu","id":"/Subscriptio
ns/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publisher
s/ibabs-eu"},{"location":"centralus","name":"imaginecommunications","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/imagineco
mmunications"},{"location":"centralus","name":"imc","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/imc"},{"location":"centra
lus","name":"imperva","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/imperva"},{"location":"centralus","name":"incredibuild"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/incredibuild"},{"location":"centralus","name":"infoblox","id":"/Subscription
s/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers
/infoblox"},{"location":"centralus","name":"infolibrarian","id":"/Subscriptions/6b6a59a6-e367-491
3-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/infolibrarian"},{"
location":"centralus","name":"informatica","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/informatica"},{"location":"central
us","name":"informatica-cloud","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/informatica-cloud"},{"location":"centralus","n
ame":"informationbuilders","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mi
crosoft.Compute/Locations/centralus/Publishers/informationbuilders"},{"location":"centralus","nam
e":"infostrat","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/infostrat"},{"location":"centralus","name":"inriver","id":"/Su
bscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/
Publishers/inriver"},{"location":"centralus","name":"intel","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/intel"},{"locatio
n":"centralus","name":"intelligent-plant-ltd","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686
2095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/intelligent-plant-ltd"},{"locat
ion":"centralus","name":"iquest","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provid
ers/Microsoft.Compute/Locations/centralus/Publishers/iquest"},{"location":"centralus","name":"ish
langu-load-balancer-adc","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micr
osoft.Compute/Locations/centralus/Publishers/ishlangu-load-balancer-adc"},{"location":"centralus"
,"name":"itelios","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/itelios"},{"location":"centralus","name":"jedox","id":"/Sub
scriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/P
ublishers/jedox"},{"location":"centralus","name":"jelastic","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/jelastic"},{"loca
tion":"centralus","name":"jetnexus","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pro
viders/Microsoft.Compute/Locations/centralus/Publishers/jetnexus"},{"location":"centralus","name"
:"jfrog","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Lo
cations/centralus/Publishers/jfrog"},{"location":"centralus","name":"jitterbit_integration","id":
"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centra
lus/Publishers/jitterbit_integration"},{"location":"centralus","name":"Josh.linux.test","id":"/Su
bscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/
Publishers/Josh.linux.test"},{"location":"centralus","name":"Joshctm.test","id":"/Subscriptions/6
b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Jo
shctm.test"},{"location":"centralus","name":"kaazing","id":"/Subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/kaazing"},{"location":"
centralus","name":"kaspersky_lab","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provi
ders/Microsoft.Compute/Locations/centralus/Publishers/kaspersky_lab"},{"location":"centralus","na
me":"kemptech","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/kemptech"},{"location":"centralus","name":"kepion","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/kepion"},{"location":"centralus","name":"knime","id":"/Subscriptions/6b6a59a6-e367-4913-
bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/knime"},{"location":
"centralus","name":"kollective","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provide
rs/Microsoft.Compute/Locations/centralus/Publishers/kollective"},{"location":"centralus","name":"
lakesidesoftware","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/lakesidesoftware"},{"location":"centralus","name":"lansa","
id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/ce
ntralus/Publishers/lansa"},{"location":"centralus","name":"le","id":"/Subscriptions/6b6a59a6-e367
-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/le"},{"locatio
n":"centralus","name":"learningtechnolgy","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095
bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/learningtechnolgy"},{"location":"ce
ntralus","name":"lieberlieber","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/lieberlieber"},{"location":"centralus","name":
"liebsoft","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/
Locations/centralus/Publishers/liebsoft"},{"location":"centralus","name":"linux.bmc.test","id":"/
Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralu
s/Publishers/linux.bmc.test"},{"location":"centralus","name":"literatu","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/liter
atu"},{"location":"centralus","name":"loadbalancer","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/loadbalancer"},{"location
":"centralus","name":"LocalTest.TrendMicro.DeepSecurity","id":"/Subscriptions/6b6a59a6-e367-4913-
bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/LocalTest.TrendMicro
.DeepSecurity"},{"location":"centralus","name":"logi-analytics","id":"/Subscriptions/6b6a59a6-e36
7-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/logi-analytic
s"},{"location":"centralus","name":"loginpeople","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b
6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/loginpeople"},{"location":"c
entralus","name":"logmein","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mi
crosoft.Compute/Locations/centralus/Publishers/logmein"},{"location":"centralus","name":"logsign"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/logsign"},{"location":"centralus","name":"logtrust","id":"/Subscriptions/6b6
a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/logt
rust"},{"location":"centralus","name":"looker","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/looker"},{"location":"centralu
s","name":"luxoft","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.
Compute/Locations/centralus/Publishers/luxoft"},{"location":"centralus","name":"mactores_inc","id
":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cent
ralus/Publishers/mactores_inc"},{"location":"centralus","name":"magelia","id":"/Subscriptions/6b6
a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/mage
lia"},{"location":"centralus","name":"manageengine","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/manageengine"},{"location
":"centralus","name":"mapr-technologies","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095b
f/Providers/Microsoft.Compute/Locations/centralus/Publishers/mapr-technologies"},{"location":"cen
tralus","name":"mariadb","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micr
osoft.Compute/Locations/centralus/Publishers/mariadb"},{"location":"centralus","name":"massiveana
lytic-","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Loc
ations/centralus/Publishers/massiveanalytic-"},{"location":"centralus","name":"mavinglobal","id":
"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centra
lus/Publishers/mavinglobal"},{"location":"centralus","name":"McAfee.EndpointSecurity","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/McAfee.EndpointSecurity"},{"location":"centralus","name":"McAfee.EndpointSecurity.test3"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/McAfee.EndpointSecurity.test3"},{"location":"centralus","name":"meanio","id"
:"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centr
alus/Publishers/meanio"},{"location":"centralus","name":"mediazenie","id":"/Subscriptions/6b6a59a
6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/mediazen
ie"},{"location":"centralus","name":"memsql","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862
095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/memsql"},{"location":"centralus"
,"name":"mendix","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Co
mpute/Locations/centralus/Publishers/mendix"},{"location":"centralus","name":"mentalnotes","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/mentalnotes"},{"location":"centralus","name":"mesosphere","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/mesos
phere"},{"location":"centralus","name":"metavistech","id":"/Subscriptions/6b6a59a6-e367-4913-bea7
-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/metavistech"},{"location
":"centralus","name":"mfiles","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers
/Microsoft.Compute/Locations/centralus/Publishers/mfiles"},{"location":"centralus","name":"Micros
oft","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/Microsoft"},{"location":"centralus","name":"microsoft-ads","id":"/Subscr
iptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publ
ishers/microsoft-ads"},{"location":"centralus","name":"microsoft-r-products","id":"/Subscriptions
/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/
microsoft-r-products"},{"location":"centralus","name":"Microsoft.Azure.Applications","id":"/Subsc
riptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pub
lishers/Microsoft.Azure.Applications"},{"location":"centralus","name":"Microsoft.Azure.Backup.Tes
t","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Location
s/centralus/Publishers/Microsoft.Azure.Backup.Test"},{"location":"centralus","name":"Microsoft.Az
ure.Diagnostics","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Co
mpute/Locations/centralus/Publishers/Microsoft.Azure.Diagnostics"},{"location":"centralus","name"
:"Microsoft.Azure.Extensions","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers
/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Azure.Extensions"},{"location":"centr
alus","name":"Microsoft.Azure.Extensions.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Azure.Extensions.Tes
t"},{"location":"centralus","name":"Microsoft.Azure.Networking.SDN","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft
.Azure.Networking.SDN"},{"location":"centralus","name":"Microsoft.Azure.RecoveryServices","id":"/
Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralu
s/Publishers/Microsoft.Azure.RecoveryServices"},{"location":"centralus","name":"Microsoft.Azure.S
ecurity","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Lo
cations/centralus/Publishers/Microsoft.Azure.Security"},{"location":"centralus","name":"Microsoft
.Azure.Security.Internal","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mic
rosoft.Compute/Locations/centralus/Publishers/Microsoft.Azure.Security.Internal"},{"location":"ce
ntralus","name":"Microsoft.Azure.SiteRecovery.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Azure.SiteRecov
ery.Test"},{"location":"centralus","name":"Microsoft.Azure.WindowsFabric.Test","id":"/Subscriptio
ns/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publisher
s/Microsoft.Azure.WindowsFabric.Test"},{"location":"centralus","name":"Microsoft.AzureCAT.AzureEn
hancedMonitoring","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/Microsoft.AzureCAT.AzureEnhancedMonitoring"},{"location":"c
entralus","name":"Microsoft.AzureCAT.AzureEnhancedMonitoringTest","id":"/Subscriptions/6b6a59a6-e
367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.A
zureCAT.AzureEnhancedMonitoringTest"},{"location":"centralus","name":"Microsoft.Compute","id":"/S
ubscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus
/Publishers/Microsoft.Compute"},{"location":"centralus","name":"Microsoft.EnterpriseCloud.Monitor
ing","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/Microsoft.EnterpriseCloud.Monitoring"},{"location":"centralus","name":"M
icrosoft.EnterpriseCloud.Monitoring.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095
bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.EnterpriseCloud.Monitorin
g.Test"},{"location":"centralus","name":"Microsoft.Golive.Extensions","id":"/Subscriptions/6b6a59
a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microso
ft.Golive.Extensions"},{"location":"centralus","name":"Microsoft.HpcCompute","id":"/Subscriptions
/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/
Microsoft.HpcCompute"},{"location":"centralus","name":"Microsoft.HpcPack","id":"/Subscriptions/6b
6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Mic
rosoft.HpcPack"},{"location":"centralus","name":"Microsoft.OSTCExtensions","id":"/Subscriptions/6
b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Mi
crosoft.OSTCExtensions"},{"location":"centralus","name":"Microsoft.OSTCExtensions.Test","id":"/Su
bscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/
Publishers/Microsoft.OSTCExtensions.Test"},{"location":"centralus","name":"Microsoft.Powershell",
"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/c
entralus/Publishers/Microsoft.Powershell"},{"location":"centralus","name":"Microsoft.Powershell.E
rrorChange","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute
/Locations/centralus/Publishers/Microsoft.Powershell.ErrorChange"},{"location":"centralus","name"
:"Microsoft.Powershell.Internal","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provid
ers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Powershell.Internal"},{"location":
"centralus","name":"Microsoft.Powershell.Internal.Telemetry","id":"/Subscriptions/6b6a59a6-e367-4
913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Powers
hell.Internal.Telemetry"},{"location":"centralus","name":"Microsoft.Powershell.PaaS","id":"/Subsc
riptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pub
lishers/Microsoft.Powershell.PaaS"},{"location":"centralus","name":"Microsoft.Powershell.Preview"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/Microsoft.Powershell.Preview"},{"location":"centralus","name":"Microsoft.Pow
ershell.Release.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/Microsoft.Powershell.Release.Test"},{"location":"centra
lus","name":"Microsoft.Powershell.Telemetry","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862
095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Powershell.Telemetry"}
,{"location":"centralus","name":"Microsoft.Powershell.Test","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Powersh
ell.Test"},{"location":"centralus","name":"Microsoft.Powershell.Test.0","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Micro
soft.Powershell.Test.0"},{"location":"centralus","name":"Microsoft.Powershell.Test.1","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/Microsoft.Powershell.Test.1"},{"location":"centralus","name":"Microsoft.Powershell.Test0
","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations
/centralus/Publishers/Microsoft.Powershell.Test0"},{"location":"centralus","name":"Microsoft.Powe
rshell.Test2","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compu
te/Locations/centralus/Publishers/Microsoft.Powershell.Test2"},{"location":"centralus","name":"Mi
crosoft.Powershell.Test3","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mic
rosoft.Compute/Locations/centralus/Publishers/Microsoft.Powershell.Test3"},{"location":"centralus
","name":"Microsoft.Powershell.UpgradeTest","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68620
95bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Powershell.UpgradeTest"
},{"location":"centralus","name":"Microsoft.Powershell.UtcTest","id":"/Subscriptions/6b6a59a6-e36
7-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Pow
ershell.UtcTest"},{"location":"centralus","name":"Microsoft.Powershell.Wmf","id":"/Subscriptions/
6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/M
icrosoft.Powershell.Wmf"},{"location":"centralus","name":"Microsoft.Powershell.Wmf4Test","id":"/S
ubscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus
/Publishers/Microsoft.Powershell.Wmf4Test"},{"location":"centralus","name":"Microsoft.Powershell.
Wmf5","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locat
ions/centralus/Publishers/Microsoft.Powershell.Wmf5"},{"location":"centralus","name":"Microsoft.P
owershell.WmfRTM","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/Microsoft.Powershell.WmfRTM"},{"location":"centralus","name
":"Microsoft.SqlServer.Managability.IaaS.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.SqlServer.Managabili
ty.IaaS.Test"},{"location":"centralus","name":"Microsoft.SqlServer.Management","id":"/Subscriptio
ns/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publisher
s/Microsoft.SqlServer.Management"},{"location":"centralus","name":"Microsoft.SystemCenter","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/Microsoft.SystemCenter"},{"location":"centralus","name":"Microsoft.VisualStudio","i
d":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cen
tralus/Publishers/Microsoft.VisualStudio"},{"location":"centralus","name":"Microsoft.VisualStudio
.Azure.ETWTraceListenerService","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provide
rs/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.VisualStudio.Azure.ETWTraceListener
Service"},{"location":"centralus","name":"Microsoft.VisualStudio.Azure.RemoteDebug","id":"/Subscr
iptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publ
ishers/Microsoft.VisualStudio.Azure.RemoteDebug"},{"location":"centralus","name":"Microsoft.Visua
lStudio.Azure.RemoteDebug.Json","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provide
rs/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.VisualStudio.Azure.RemoteDebug.Json
"},{"location":"centralus","name":"Microsoft.VisualStudio.ServiceProfiler","id":"/Subscriptions/6
b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Mi
crosoft.VisualStudio.ServiceProfiler"},{"location":"centralus","name":"Microsoft.Windows.AzureRem
oteApp.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comput
e/Locations/centralus/Publishers/Microsoft.Windows.AzureRemoteApp.Test"},{"location":"centralus",
"name":"Microsoft.Windows.RemoteDesktop","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095b
f/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Windows.RemoteDesktop"},{"
location":"centralus","name":"Microsoft.WindowsAzure.Compute","id":"/Subscriptions/6b6a59a6-e367-
4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Microsoft.Windo
wsAzure.Compute"},{"location":"centralus","name":"MicrosoftAzureSiteRecovery","id":"/Subscription
s/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers
/MicrosoftAzureSiteRecovery"},{"location":"centralus","name":"MicrosoftBizTalkServer","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/MicrosoftBizTalkServer"},{"location":"centralus","name":"MicrosoftDynamicsAX","id":"/Sub
scriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/P
ublishers/MicrosoftDynamicsAX"},{"location":"centralus","name":"MicrosoftDynamicsGP","id":"/Subsc
riptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pub
lishers/MicrosoftDynamicsGP"},{"location":"centralus","name":"MicrosoftDynamicsNAV","id":"/Subscr
iptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publ
ishers/MicrosoftDynamicsNAV"},{"location":"centralus","name":"MicrosoftHybridCloudStorage","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/MicrosoftHybridCloudStorage"},{"location":"centralus","name":"MicrosoftOSTC","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/MicrosoftOSTC"},{"location":"centralus","name":"MicrosoftRServer","id":"/Subscripti
ons/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishe
rs/MicrosoftRServer"},{"location":"centralus","name":"MicrosoftSharePoint","id":"/Subscriptions/6
b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Mi
crosoftSharePoint"},{"location":"centralus","name":"MicrosoftSQLServer","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Micro
softSQLServer"},{"location":"centralus","name":"MicrosoftVisualStudio","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Micros
oftVisualStudio"},{"location":"centralus","name":"MicrosoftWindowsServer","id":"/Subscriptions/6b
6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Mic
rosoftWindowsServer"},{"location":"centralus","name":"MicrosoftWindowsServerEssentials","id":"/Su
bscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/
Publishers/MicrosoftWindowsServerEssentials"},{"location":"centralus","name":"MicrosoftWindowsSer
verHPCPack","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute
/Locations/centralus/Publishers/MicrosoftWindowsServerHPCPack"},{"location":"centralus","name":"M
icrosoftWindowsServerRemoteDesktop","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pro
viders/Microsoft.Compute/Locations/centralus/Publishers/MicrosoftWindowsServerRemoteDesktop"},{"l
ocation":"centralus","name":"midvision","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/midvision"},{"location":"centralus","
name":"miraclelinux","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsof
t.Compute/Locations/centralus/Publishers/miraclelinux"},{"location":"centralus","name":"miracl_li
nux","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/miracl_linux"},{"location":"centralus","name":"mobilab","id":"/Subscript
ions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publish
ers/mobilab"},{"location":"centralus","name":"mokxa-technologies","id":"/Subscriptions/6b6a59a6-e
367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/mokxa-techn
ologies"},{"location":"centralus","name":"moviemasher","id":"/Subscriptions/6b6a59a6-e367-4913-be
a7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/moviemasher"},{"locati
on":"centralus","name":"msopentech","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pro
viders/Microsoft.Compute/Locations/centralus/Publishers/msopentech"},{"location":"centralus","nam
e":"msrazuresapservices","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micr
osoft.Compute/Locations/centralus/Publishers/msrazuresapservices"},{"location":"centralus","name"
:"mtnfog","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/L
ocations/centralus/Publishers/mtnfog"},{"location":"centralus","name":"mvp-systems","id":"/Subscr
iptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publ
ishers/mvp-systems"},{"location":"centralus","name":"mxhero","id":"/Subscriptions/6b6a59a6-e367-4
913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/mxhero"},{"locat
ion":"centralus","name":"my-com","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provid
ers/Microsoft.Compute/Locations/centralus/Publishers/my-com"},{"location":"centralus","name":"nam
irial","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Loca
tions/centralus/Publishers/namirial"},{"location":"centralus","name":"nasuni","id":"/Subscription
s/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers
/nasuni"},{"location":"centralus","name":"ncbi","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6
862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/ncbi"},{"location":"centralus
","name":"netapp","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/netapp"},{"location":"centralus","name":"netgate","id":"/Su
bscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/
Publishers/netgate"},{"location":"centralus","name":"netiq","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/netiq"},{"locatio
n":"centralus","name":"netwrix","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provide
rs/Microsoft.Compute/Locations/centralus/Publishers/netwrix"},{"location":"centralus","name":"neu
soft-neteye","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comput
e/Locations/centralus/Publishers/neusoft-neteye"},{"location":"centralus","name":"new-signature",
"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/c
entralus/Publishers/new-signature"},{"location":"centralus","name":"nextlimit","id":"/Subscriptio
ns/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publisher
s/nextlimit"},{"location":"centralus","name":"nexus","id":"/Subscriptions/6b6a59a6-e367-4913-bea7
-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/nexus"},{"location":"cen
tralus","name":"nginxinc","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mic
rosoft.Compute/Locations/centralus/Publishers/nginxinc"},{"location":"centralus","name":"nicepeop
leatwork","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/L
ocations/centralus/Publishers/nicepeopleatwork"},{"location":"centralus","name":"nodejsapi","id":
"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centra
lus/Publishers/nodejsapi"},{"location":"centralus","name":"nuxeo","id":"/Subscriptions/6b6a59a6-e
367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/nuxeo"},{"l
ocation":"centralus","name":"officeclipsuite","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686
2095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/officeclipsuite"},{"location":"
centralus","name":"omega-software","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Prov
iders/Microsoft.Compute/Locations/centralus/Publishers/omega-software"},{"location":"centralus","
name":"ooyala","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/ooyala"},{"location":"centralus","name":"op5","id":"/Subscript
ions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publish
ers/op5"},{"location":"centralus","name":"opencell","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/opencell"},{"location":"c
entralus","name":"OpenLogic","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/
Microsoft.Compute/Locations/centralus/Publishers/OpenLogic"},{"location":"centralus","name":"open
meap","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locat
ions/centralus/Publishers/openmeap"},{"location":"centralus","name":"opennebulasystems","id":"/Su
bscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/
Publishers/opennebulasystems"},{"location":"centralus","name":"opentext","id":"/Subscriptions/6b6
a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/open
text"},{"location":"centralus","name":"Oracle","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Oracle"},{"location":"centralu
s","name":"orfast-technologies","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provide
rs/Microsoft.Compute/Locations/centralus/Publishers/orfast-technologies"},{"location":"centralus"
,"name":"orientdb","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.
Compute/Locations/centralus/Publishers/orientdb"},{"location":"centralus","name":"osisoft","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/osisoft"},{"location":"centralus","name":"outsystems","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/outsystem
s"},{"location":"centralus","name":"paloaltonetworks","id":"/Subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/paloaltonetworks"},{"lo
cation":"centralus","name":"panorama-necto","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68620
95bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/panorama-necto"},{"location":"cen
tralus","name":"panzura-file-system","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pr
oviders/Microsoft.Compute/Locations/centralus/Publishers/panzura-file-system"},{"location":"centr
alus","name":"pointmatter","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mi
crosoft.Compute/Locations/centralus/Publishers/pointmatter"},{"location":"centralus","name":"port
alarchitects","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compu
te/Locations/centralus/Publishers/portalarchitects"},{"location":"centralus","name":"predictionio
","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations
/centralus/Publishers/predictionio"},{"location":"centralus","name":"predixion","id":"/Subscripti
ons/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishe
rs/predixion"},{"location":"centralus","name":"prestashop","id":"/Subscriptions/6b6a59a6-e367-491
3-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/prestashop"},{"loc
ation":"centralus","name":"prime-strategy","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/prime-strategy"},{"location":"cent
ralus","name":"primestream","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/M
icrosoft.Compute/Locations/centralus/Publishers/primestream"},{"location":"centralus","name":"pro
cess-one","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/L
ocations/centralus/Publishers/process-one"},{"location":"centralus","name":"profisee","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/profisee"},{"location":"centralus","name":"progelspa","id":"/Subscriptions/6b6a59a6-e367
-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/progelspa"},{"
location":"centralus","name":"ptv_group","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095b
f/Providers/Microsoft.Compute/Locations/centralus/Publishers/ptv_group"},{"location":"centralus",
"name":"puppet","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Com
pute/Locations/centralus/Publishers/puppet"},{"location":"centralus","name":"PuppetLabs","id":"/S
ubscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus
/Publishers/PuppetLabs"},{"location":"centralus","name":"PuppetLabs.Test","id":"/Subscriptions/6b
6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Pup
petLabs.Test"},{"location":"centralus","name":"pxlag_swiss","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/pxlag_swiss"},{"l
ocation":"centralus","name":"quales","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pr
oviders/Microsoft.Compute/Locations/centralus/Publishers/quales"},{"location":"centralus","name":
"Qualys","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Lo
cations/centralus/Publishers/Qualys"},{"location":"centralus","name":"Qualys.Test","id":"/Subscri
ptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publi
shers/Qualys.Test"},{"location":"centralus","name":"Qualys.Test.2","id":"/Subscriptions/6b6a59a6-
e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Qualys.Tes
t.2"},{"location":"centralus","name":"Qualys.Test.3","id":"/Subscriptions/6b6a59a6-e367-4913-bea7
-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Qualys.Test.3"},{"locati
on":"centralus","name":"qualysguard","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pr
oviders/Microsoft.Compute/Locations/centralus/Publishers/qualysguard"},{"location":"centralus","n
ame":"quasardb","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Com
pute/Locations/centralus/Publishers/quasardb"},{"location":"centralus","name":"qubole","id":"/Sub
scriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/P
ublishers/qubole"},{"location":"centralus","name":"radware","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/radware"},{"locat
ion":"centralus","name":"rancher","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provi
ders/Microsoft.Compute/Locations/centralus/Publishers/rancher"},{"location":"centralus","name":"R
edHat","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Loca
tions/centralus/Publishers/RedHat"},{"location":"centralus","name":"redpoint-global","id":"/Subsc
riptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pub
lishers/redpoint-global"},{"location":"centralus","name":"relevance-lab","id":"/Subscriptions/6b6
a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/rele
vance-lab"},{"location":"centralus","name":"remotelearner","id":"/Subscriptions/6b6a59a6-e367-491
3-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/remotelearner"},{"
location":"centralus","name":"res","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Prov
iders/Microsoft.Compute/Locations/centralus/Publishers/res"},{"location":"centralus","name":"revo
lution-analytics","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/revolution-analytics"},{"location":"centralus","name":"Righ
tScaleLinux","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comput
e/Locations/centralus/Publishers/RightScaleLinux"},{"location":"centralus","name":"RightScaleWind
owsServer","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/
Locations/centralus/Publishers/RightScaleWindowsServer"},{"location":"centralus","name":"riverbed
","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations
/centralus/Publishers/riverbed"},{"location":"centralus","name":"RiverbedTechnology","id":"/Subsc
riptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pub
lishers/RiverbedTechnology"},{"location":"centralus","name":"rocketsoftware","id":"/Subscriptions
/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/
rocketsoftware"},{"location":"centralus","name":"rocket_software","id":"/Subscriptions/6b6a59a6-e
367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/rocket_soft
ware"},{"location":"centralus","name":"rp","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/rp"},{"location":"centralus","name
":"saama","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/L
ocations/centralus/Publishers/saama"},{"location":"centralus","name":"saltstack","id":"/Subscript
ions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publish
ers/saltstack"},{"location":"centralus","name":"sap","id":"/Subscriptions/6b6a59a6-e367-4913-bea7
-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/sap"},{"location":"centr
alus","name":"scalearc","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micro
soft.Compute/Locations/centralus/Publishers/scalearc"},{"location":"centralus","name":"scalebase"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/scalebase"},{"location":"centralus","name":"scsk","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/scsk"}
,{"location":"centralus","name":"seagate","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095
bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/seagate"},{"location":"centralus","
name":"searchblox","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.
Compute/Locations/centralus/Publishers/searchblox"},{"location":"centralus","name":"sensorberg","
id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/ce
ntralus/Publishers/sensorberg"},{"location":"centralus","name":"servoy","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/servo
y"},{"location":"centralus","name":"sharefile","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/sharefile"},{"location":"centr
alus","name":"shareshiftneeraj.test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pr
oviders/Microsoft.Compute/Locations/centralus/Publishers/shareshiftneeraj.test"},{"location":"cen
tralus","name":"shavlik","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micr
osoft.Compute/Locations/centralus/Publishers/shavlik"},{"location":"centralus","name":"sightapps"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/sightapps"},{"location":"centralus","name":"silver-peak-systems","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/silver-peak-systems"},{"location":"centralus","name":"simmachinesinc","id":"/Subscriptio
ns/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publisher
s/simmachinesinc"},{"location":"centralus","name":"sinefa","id":"/Subscriptions/6b6a59a6-e367-491
3-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/sinefa"},{"locatio
n":"centralus","name":"sios_datakeeper","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/sios_datakeeper"},{"location":"centra
lus","name":"sisense","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/sisense"},{"location":"centralus","name":"Site24x7","id
":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cent
ralus/Publishers/Site24x7"},{"location":"centralus","name":"snaplogic","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/snaplo
gic"},{"location":"centralus","name":"snip2code","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b
6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/snip2code"},{"location":"cen
tralus","name":"soasta","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micro
soft.Compute/Locations/centralus/Publishers/soasta"},{"location":"centralus","name":"softnas","id
":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cent
ralus/Publishers/softnas"},{"location":"centralus","name":"soha","id":"/Subscriptions/6b6a59a6-e3
67-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/soha"},{"loc
ation":"centralus","name":"solanolabs","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/
Providers/Microsoft.Compute/Locations/centralus/Publishers/solanolabs"},{"location":"centralus","
name":"solarwinds","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.
Compute/Locations/centralus/Publishers/solarwinds"},{"location":"centralus","name":"sophos","id":
"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centra
lus/Publishers/sophos"},{"location":"centralus","name":"spacecurve","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/spacecurv
e"},{"location":"centralus","name":"spagobi","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862
095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/spagobi"},{"location":"centralus
","name":"sphere3d","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft
.Compute/Locations/centralus/Publishers/sphere3d"},{"location":"centralus","name":"splunk","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/splunk"},{"location":"centralus","name":"sqlsentry","id":"/Subscriptions/6b6a59a6-e
367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/sqlsentry"}
,{"location":"centralus","name":"stackato-platform-as-a-service","id":"/Subscriptions/6b6a59a6-e3
67-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/stackato-pla
tform-as-a-service"},{"location":"centralus","name":"stackstorm","id":"/Subscriptions/6b6a59a6-e3
67-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/stackstorm"}
,{"location":"centralus","name":"starwind","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/starwind"},{"location":"centralus"
,"name":"StatusReport.Diagnostics.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/StatusReport.Diagnostics.Test"},{"loc
ation":"centralus","name":"steelhive","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/P
roviders/Microsoft.Compute/Locations/centralus/Publishers/steelhive"},{"location":"centralus","na
me":"stonefly","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/stonefly"},{"location":"centralus","name":"stormshield","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/stormshield"},{"location":"centralus","name":"storreduce","id":"/Subscriptions/6b6a
59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/storr
educe"},{"location":"centralus","name":"stratalux","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-3
4b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/stratalux"},{"location":"c
entralus","name":"stratus-id","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers
/Microsoft.Compute/Locations/centralus/Publishers/stratus-id"},{"location":"centralus","name":"su
mologic","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Lo
cations/centralus/Publishers/sumologic"},{"location":"centralus","name":"sunview-software","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/sunview-software"},{"location":"centralus","name":"SUSE","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/SUSE"}
,{"location":"centralus","name":"Symantec","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Symantec"},{"location":"centralus"
,"name":"Symantec.QA","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/Symantec.QA"},{"location":"centralus","name":"Symantec.
staging","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Lo
cations/centralus/Publishers/Symantec.staging"},{"location":"centralus","name":"Symantec.test","i
d":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cen
tralus/Publishers/Symantec.test"},{"location":"centralus","name":"symantectest1","id":"/Subscript
ions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publish
ers/symantectest1"},{"location":"centralus","name":"SymantecTest11","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/SymantecT
est11"},{"location":"centralus","name":"SymantecTest12","id":"/Subscriptions/6b6a59a6-e367-4913-b
ea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/SymantecTest12"},{"lo
cation":"centralus","name":"SymantecTest6","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686209
5bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/SymantecTest6"},{"location":"centr
alus","name":"SymantecTest7","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/
Microsoft.Compute/Locations/centralus/Publishers/SymantecTest7"},{"location":"centralus","name":"
SymantecTest9","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/SymantecTest9"},{"location":"centralus","name":"SymantecTestLs
TestLogonImport","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Co
mpute/Locations/centralus/Publishers/SymantecTestLsTestLogonImport"},{"location":"centralus","nam
e":"SymantecTestLsTestSerdefDat","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provid
ers/Microsoft.Compute/Locations/centralus/Publishers/SymantecTestLsTestSerdefDat"},{"location":"c
entralus","name":"SymantecTestNoLu","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Pro
viders/Microsoft.Compute/Locations/centralus/Publishers/SymantecTestNoLu"},{"location":"centralus
","name":"SymantecTestQB","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Mic
rosoft.Compute/Locations/centralus/Publishers/SymantecTestQB"},{"location":"centralus","name":"Sy
mantecTestRU4","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Comp
ute/Locations/centralus/Publishers/SymantecTestRU4"},{"location":"centralus","name":"syncfusionbi
gdataplatfor","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compu
te/Locations/centralus/Publishers/syncfusionbigdataplatfor"},{"location":"centralus","name":"tabl
eau","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/tableau"},{"location":"centralus","name":"tactic","id":"/Subscriptions/6
b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/ta
ctic"},{"location":"centralus","name":"talon","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686
2095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/talon"},{"location":"centralus"
,"name":"targit","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Co
mpute/Locations/centralus/Publishers/targit"},{"location":"centralus","name":"tavendo","id":"/Sub
scriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/P
ublishers/tavendo"},{"location":"centralus","name":"techdivision","id":"/Subscriptions/6b6a59a6-e
367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/techdivisio
n"},{"location":"centralus","name":"telepat","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862
095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/telepat"},{"location":"centralus
","name":"tenable","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.
Compute/Locations/centralus/Publishers/tenable"},{"location":"centralus","name":"tentity","id":"/
Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralu
s/Publishers/tentity"},{"location":"centralus","name":"Teradici","id":"/Subscriptions/6b6a59a6-e3
67-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Teradici"},{
"location":"centralus","name":"Test.Barracuda.Azure.ConnectivityAgent","id":"/Subscriptions/6b6a5
9a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Test.B
arracuda.Azure.ConnectivityAgent"},{"location":"centralus","name":"test.dynatrace.ruxit","id":"/S
ubscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus
/Publishers/test.dynatrace.ruxit"},{"location":"centralus","name":"Test.Gemalto.SafeNet.ProtectV"
,"id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/
centralus/Publishers/Test.Gemalto.SafeNet.ProtectV"},{"location":"centralus","name":"Test.Gemalto
.SafeNet.ProtectV.Azure","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micr
osoft.Compute/Locations/centralus/Publishers/Test.Gemalto.SafeNet.ProtectV.Azure"},{"location":"c
entralus","name":"Test.HP.AppDefender","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/
Providers/Microsoft.Compute/Locations/centralus/Publishers/Test.HP.AppDefender"},{"location":"cen
tralus","name":"Test.NJHP.AppDefender","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/
Providers/Microsoft.Compute/Locations/centralus/Publishers/Test.NJHP.AppDefender"},{"location":"c
entralus","name":"Test.TrendMicro.DeepSecurity","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6
862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Test.TrendMicro.DeepSecurity"
},{"location":"centralus","name":"Test.TrendMicro.DeepSecurity2","id":"/Subscriptions/6b6a59a6-e3
67-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Test.TrendMi
cro.DeepSecurity2"},{"location":"centralus","name":"Test.TrendMicro.DeepSecurity3","id":"/Subscri
ptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publi
shers/Test.TrendMicro.DeepSecurity3"},{"location":"centralus","name":"Test1.NJHP.AppDefender","id
":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cent
ralus/Publishers/Test1.NJHP.AppDefender"},{"location":"centralus","name":"test1extnnocert","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/test1extnnocert"},{"location":"centralus","name":"Test3.Symantec.SymantecEndpointPr
otection","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/L
ocations/centralus/Publishers/Test3.Symantec.SymantecEndpointProtection"},{"location":"centralus"
,"name":"Test4.Symantec.SymantecEndpointProtection","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Test4.Symantec.SymantecEn
dpointProtection"},{"location":"centralus","name":"Test5.Symantec.SymantecEndpointProtection","id
":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cent
ralus/Publishers/Test5.Symantec.SymantecEndpointProtection"},{"location":"centralus","name":"thin
kboxsoftware","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compu
te/Locations/centralus/Publishers/thinkboxsoftware"},{"location":"centralus","name":"tibco-softwa
re","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locatio
ns/centralus/Publishers/tibco-software"},{"location":"centralus","name":"topdesk","id":"/Subscrip
tions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publis
hers/topdesk"},{"location":"centralus","name":"torusware","id":"/Subscriptions/6b6a59a6-e367-4913
-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/torusware"},{"locat
ion":"centralus","name":"townsend-security","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68620
95bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/townsend-security"},{"location":"
centralus","name":"transvault","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/transvault"},{"location":"centralus","name":"t
rendmicro","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/
Locations/centralus/Publishers/trendmicro"},{"location":"centralus","name":"TrendMicro.DeepSecuri
ty","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locatio
ns/centralus/Publishers/TrendMicro.DeepSecurity"},{"location":"centralus","name":"TrendMicro.Deep
Security.Test2","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Com
pute/Locations/centralus/Publishers/TrendMicro.DeepSecurity.Test2"},{"location":"centralus","name
":"TrendMicro.PortalProtect","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/
Microsoft.Compute/Locations/centralus/Publishers/TrendMicro.PortalProtect"},{"location":"centralu
s","name":"tsa-public-service","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/tsa-public-service"},{"location":"centralus","
name":"typesafe","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Co
mpute/Locations/centralus/Publishers/typesafe"},{"location":"centralus","name":"ubercloud","id":"
/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/central
us/Publishers/ubercloud"},{"location":"centralus","name":"unidesk","id":"/Subscriptions/6b6a59a6-
e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/unidesk"},
{"location":"centralus","name":"unidesk-corp","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b686
2095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/unidesk-corp"},{"location":"cen
tralus","name":"usp","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsof
t.Compute/Locations/centralus/Publishers/usp"},{"location":"centralus","name":"vbot","id":"/Subsc
riptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pub
lishers/vbot"},{"location":"centralus","name":"vecompsoftware","id":"/Subscriptions/6b6a59a6-e367
-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/vecompsoftware
"},{"location":"centralus","name":"veeam","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095
bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/veeam"},{"location":"centralus","na
me":"vidispine","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Com
pute/Locations/centralus/Publishers/vidispine"},{"location":"centralus","name":"vidizmo","id":"/S
ubscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus
/Publishers/vidizmo"},{"location":"centralus","name":"vintegris","id":"/Subscriptions/6b6a59a6-e3
67-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/vintegris"},
{"location":"centralus","name":"vircom","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/vircom"},{"location":"centralus","nam
e":"virtualworks","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.C
ompute/Locations/centralus/Publishers/virtualworks"},{"location":"centralus","name":"vision_solut
ions","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locat
ions/centralus/Publishers/vision_solutions"},{"location":"centralus","name":"vmturbo","id":"/Subs
criptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Pu
blishers/vmturbo"},{"location":"centralus","name":"Vormetric","id":"/Subscriptions/6b6a59a6-e367-
4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Vormetric"},{"l
ocation":"centralus","name":"Vormetric.TestExt","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6
862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Vormetric.TestExt"},{"locatio
n":"centralus","name":"Vormetric.VormetricTransparentEncryption","id":"/Subscriptions/6b6a59a6-e3
67-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/Vormetric.Vo
rmetricTransparentEncryption"},{"location":"centralus","name":"vte","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/vte"},{"l
ocation":"centralus","name":"WAD-VMSS.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68620
95bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/WAD-VMSS.Test"},{"location":"cent
ralus","name":"WAD2AI.Diagnostics.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf
/Providers/Microsoft.Compute/Locations/centralus/Publishers/WAD2AI.Diagnostics.Test"},{"location"
:"centralus","name":"WAD2EventHub.Diagnostics.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-
34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/WAD2EventHub.Diagnostics.
Test"},{"location":"centralus","name":"WADVMSS.Test","id":"/Subscriptions/6b6a59a6-e367-4913-bea7
-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/WADVMSS.Test"},{"locatio
n":"centralus","name":"wallix","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Provider
s/Microsoft.Compute/Locations/centralus/Publishers/wallix"},{"location":"centralus","name":"warat
ek","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locatio
ns/centralus/Publishers/waratek"},{"location":"centralus","name":"warewolf-esb","id":"/Subscripti
ons/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishe
rs/warewolf-esb"},{"location":"centralus","name":"watchfulsoftware","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/watchfuls
oftware"},{"location":"centralus","name":"websense-apmailpe","id":"/Subscriptions/6b6a59a6-e367-4
913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/websense-apmailp
e"},{"location":"centralus","name":"wipro-ltd","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/wipro-ltd"},{"location":"centr
alus","name":"wmspanel","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micro
soft.Compute/Locations/centralus/Publishers/wmspanel"},{"location":"centralus","name":"workshare-
technology","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute
/Locations/centralus/Publishers/workshare-technology"},{"location":"centralus","name":"wowza","id
":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/cent
ralus/Publishers/wowza"},{"location":"centralus","name":"xebialabs","id":"/Subscriptions/6b6a59a6
-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/xebialabs
"},{"location":"centralus","name":"xfinityinc","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b68
62095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/xfinityinc"},{"location":"cent
ralus","name":"xmpro","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microso
ft.Compute/Locations/centralus/Publishers/xmpro"},{"location":"centralus","name":"xrm","id":"/Sub
scriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/P
ublishers/xrm"},{"location":"centralus","name":"xtremedata","id":"/Subscriptions/6b6a59a6-e367-49
13-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/xtremedata"},{"lo
cation":"centralus","name":"yellowfin","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/
Providers/Microsoft.Compute/Locations/centralus/Publishers/yellowfin"},{"location":"centralus","n
ame":"your-shop-online","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Micro
soft.Compute/Locations/centralus/Publishers/your-shop-online"},{"location":"centralus","name":"ze
mentis","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Loc
ations/centralus/Publishers/zementis"},{"location":"centralus","name":"zend","id":"/Subscriptions
/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/
zend"},{"location":"centralus","name":"zoomdata","id":"/Subscriptions/6b6a59a6-e367-4913-bea7-34b
6862095bf/Providers/Microsoft.Compute/Locations/centralus/Publishers/zoomdata"}]


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: e1a13e7d-b935-43ad-8301-7e45fadc6f3c - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:02 PM: e1a13e7d-b935-43ad-8301-7e45fadc6f3c - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: e1a13e7d-b935-43ad-8301-7e45fadc6f3c - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:02 PM: e1a13e7d-b935-43ad-8301-7e45fadc6f3c - TokenCache: 44.0683249666667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: e1a13e7d-b935-43ad-8301-7e45fadc6f3c - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: e1a13e7d-b935-43ad-8301-7e45fadc6f3c - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/publishers/Microsoft.Compute/artifacttypes/vmextension/types?api-v
ersion=2016-03-30

Headers:
x-ms-client-request-id        : b8e7d38a-8293-42ae-90bb-af646f3bfc7d
accept-language               : en-US

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-request-id               : 87c685e9-bcda-42ba-ad87-e7eaa80111d7
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14988
x-ms-correlation-request-id   : cdb9e8d1-9910-45b8-bd54-b18bb5b99e22
x-ms-routing-request-id       : CENTRALUS:20160713T185602Z:cdb9e8d1-9910-45b8-bd54-b18bb5b99e22
Date                          : Wed, 13 Jul 2016 18:56:01 GMT

Body:
[
  {
    "location": "centralus",
    "name": "BGInfo",
    "id": "/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/Microsoft.Compute/ArtifactTypes/VMExtension/Types/BGInfo"
  },
  {
    "location": "centralus",
    "name": "CustomScriptExtension",
    "id": "/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/Microsoft.Compute/ArtifactTypes/VMExtension/Types/CustomScriptExtension"

  },
  {
    "location": "centralus",
    "name": "JsonADDomainExtension",
    "id": "/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/Microsoft.Compute/ArtifactTypes/VMExtension/Types/JsonADDomainExtension"

  },
  {
    "location": "centralus",
    "name": "VMAccessAgent",
    "id": "/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/Microsoft.Compute/ArtifactTypes/VMExtension/Types/VMAccessAgent"
  }
]


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: 00e835e1-b7be-4fc3-b452-ea7ec6446de1 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:02 PM: 00e835e1-b7be-4fc3-b452-ea7ec6446de1 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: 00e835e1-b7be-4fc3-b452-ea7ec6446de1 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:02 PM: 00e835e1-b7be-4fc3-b452-ea7ec6446de1 - TokenCache: 44.066383315 minu
tes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: 00e835e1-b7be-4fc3-b452-ea7ec6446de1 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: 00e835e1-b7be-4fc3-b452-ea7ec6446de1 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/publishers/Microsoft.Compute/artifacttypes/vmextension/types/BGInf
o/versions?api-version=2016-03-30

Headers:
x-ms-client-request-id        : 320c067d-fdd2-47dd-a0e8-8b72b700e4c8
accept-language               : en-US

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-request-id               : 1f74101f-64ac-43c8-966a-0c139e07cc61
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14987
x-ms-correlation-request-id   : c29c5f3e-90d9-43dd-bee6-c172e92c8ed4
x-ms-routing-request-id       : CENTRALUS:20160713T185602Z:c29c5f3e-90d9-43dd-bee6-c172e92c8ed4
Date                          : Wed, 13 Jul 2016 18:56:01 GMT

Body:
[
  {
    "location": "centralus",
    "name": "2.1",
    "id": "/Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locati
ons/centralus/Publishers/Microsoft.Compute/ArtifactTypes/VMExtension/Types/BGInfo/Versions/2.1"
  }
]


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: ef04c707-6c41-4fe5-b7ee-58a8387ab087 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:02 PM: ef04c707-6c41-4fe5-b7ee-58a8387ab087 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: ef04c707-6c41-4fe5-b7ee-58a8387ab087 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:02 PM: ef04c707-6c41-4fe5-b7ee-58a8387ab087 - TokenCache: 44.0650665983333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: ef04c707-6c41-4fe5-b7ee-58a8387ab087 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:02 PM: ef04c707-6c41-4fe5-b7ee-58a8387ab087 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
PUT

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/my
group2/providers/Microsoft.Compute/virtualMachines/myvm2/extensions/BGInfo?api-version=2016-03-30


Headers:
x-ms-client-request-id        : 16edec4e-0012-4ca5-a3df-fafb4ba3f892
accept-language               : en-US

Body:
{
  "properties": {
    "publisher": "Microsoft.Compute",
    "type": "BGInfo",
    "typeHandlerVersion": "2.1",
    "autoUpgradeMinorVersion": true
  },
  "location": "centralus"
}


DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
Created

Headers:
Pragma                        : no-cache
Azure-AsyncOperation          : https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea
7-34b6862095bf/providers/Microsoft.Compute/locations/centralus/operations/38074ed3-bd51-4b21-ad40
-14855bbdcc49?api-version=2016-03-30
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 38074ed3-bd51-4b21-ad40-14855bbdcc49
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-writes: 1198
x-ms-correlation-request-id   : 1ba7b6cf-0d31-4eb3-83a2-03fd35fb36bf
x-ms-routing-request-id       : CENTRALUS:20160713T185603Z:1ba7b6cf-0d31-4eb3-83a2-03fd35fb36bf
Date                          : Wed, 13 Jul 2016 18:56:03 GMT

Body:
{
  "properties": {
    "publisher": "Microsoft.Compute",
    "type": "BGInfo",
    "typeHandlerVersion": "2.1",
    "autoUpgradeMinorVersion": true,
    "provisioningState": "Creating"
  },
  "id": "/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/mygroup2/providers/Mi
crosoft.Compute/virtualMachines/myvm2/extensions/BGInfo",
  "name": "BGInfo",
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "location": "centralus"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:33 PM: 894eb71c-2e89-4512-89b0-a59ecf2d211e - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:33 PM: 894eb71c-2e89-4512-89b0-a59ecf2d211e - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:33 PM: 894eb71c-2e89-4512-89b0-a59ecf2d211e - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:56:33 PM: 894eb71c-2e89-4512-89b0-a59ecf2d211e - TokenCache: 43.5520646316667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:33 PM: 894eb71c-2e89-4512-89b0-a59ecf2d211e - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:56:33 PM: 894eb71c-2e89-4512-89b0-a59ecf2d211e - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/38074ed3-bd51-4b21-ad40-14855bbdcc49?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 5b9c2d28-3df6-4692-a1b3-be982cd2b249
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14986
x-ms-correlation-request-id   : 17c62b7c-0e13-4d8b-9b7c-ac7d05609e4f
x-ms-routing-request-id       : CENTRALUS:20160713T185633Z:17c62b7c-0e13-4d8b-9b7c-ac7d05609e4f
Date                          : Wed, 13 Jul 2016 18:56:33 GMT

Body:
{
  "startTime": "2016-07-13T11:56:03.382836-07:00",
  "status": "InProgress",
  "name": "38074ed3-bd51-4b21-ad40-14855bbdcc49"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:57:03 PM: 184ad5c4-f6aa-4907-8170-7a166818fb4a - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:57:03 PM: 184ad5c4-f6aa-4907-8170-7a166818fb4a - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:57:03 PM: 184ad5c4-f6aa-4907-8170-7a166818fb4a - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:57:03 PM: 184ad5c4-f6aa-4907-8170-7a166818fb4a - TokenCache: 43.0508803516667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:57:03 PM: 184ad5c4-f6aa-4907-8170-7a166818fb4a - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:57:03 PM: 184ad5c4-f6aa-4907-8170-7a166818fb4a - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/38074ed3-bd51-4b21-ad40-14855bbdcc49?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : e2eab73a-1385-48ee-abce-ff77999141fe
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14985
x-ms-correlation-request-id   : f6d8b27d-38ed-4f16-a0d1-6356a96fb72b
x-ms-routing-request-id       : CENTRALUS:20160713T185703Z:f6d8b27d-38ed-4f16-a0d1-6356a96fb72b
Date                          : Wed, 13 Jul 2016 18:57:03 GMT

Body:
{
  "startTime": "2016-07-13T11:56:03.382836-07:00",
  "status": "InProgress",
  "name": "38074ed3-bd51-4b21-ad40-14855bbdcc49"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:57:33 PM: abb24a1f-efed-4a9a-bf28-4f854f007583 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:57:33 PM: abb24a1f-efed-4a9a-bf28-4f854f007583 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:57:33 PM: abb24a1f-efed-4a9a-bf28-4f854f007583 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:57:33 PM: abb24a1f-efed-4a9a-bf28-4f854f007583 - TokenCache: 42.5484271316667 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:57:33 PM: abb24a1f-efed-4a9a-bf28-4f854f007583 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:57:33 PM: abb24a1f-efed-4a9a-bf28-4f854f007583 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/38074ed3-bd51-4b21-ad40-14855bbdcc49?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : e4106b25-478f-447a-90ce-5301a12eeea7
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14999
x-ms-correlation-request-id   : 22f4109c-7192-40b5-b771-b319fd5a3124
x-ms-routing-request-id       : CENTRALUS:20160713T185734Z:22f4109c-7192-40b5-b771-b319fd5a3124
Date                          : Wed, 13 Jul 2016 18:57:33 GMT

Body:
{
  "startTime": "2016-07-13T11:56:03.382836-07:00",
  "status": "InProgress",
  "name": "38074ed3-bd51-4b21-ad40-14855bbdcc49"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:58:04 PM: ab089b0c-f841-4596-883b-fc5c0a95b7f0 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:58:04 PM: ab089b0c-f841-4596-883b-fc5c0a95b7f0 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:58:04 PM: ab089b0c-f841-4596-883b-fc5c0a95b7f0 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:58:04 PM: ab089b0c-f841-4596-883b-fc5c0a95b7f0 - TokenCache: 42.0390053183333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:58:04 PM: ab089b0c-f841-4596-883b-fc5c0a95b7f0 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:58:04 PM: ab089b0c-f841-4596-883b-fc5c0a95b7f0 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/providers/Microso
ft.Compute/locations/centralus/operations/38074ed3-bd51-4b21-ad40-14855bbdcc49?api-version=2016-0
3-30

Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : cc258867-3e75-4871-9286-bb82f0046e16
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14998
x-ms-correlation-request-id   : 4faec910-dde3-4754-bfd1-f7925193aa64
x-ms-routing-request-id       : CENTRALUS:20160713T185804Z:4faec910-dde3-4754-bfd1-f7925193aa64
Date                          : Wed, 13 Jul 2016 18:58:03 GMT

Body:
{
  "startTime": "2016-07-13T11:56:03.382836-07:00",
  "endTime": "2016-07-13T11:57:56.9860829-07:00",
  "status": "Succeeded",
  "name": "38074ed3-bd51-4b21-ad40-14855bbdcc49"
}


DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:58:04 PM: e996f3ab-6a81-4bd3-9665-fef351b492c9 - AcquireTokenHandlerBase: === 
Token Acquisition started:
	Authority: https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/
	Resource: https://management.core.windows.net/
	ClientId: 1950a258-227b-4e31-a9cf-717495945fc2
	CacheType: Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache (1 items)
	Authentication Target: User
	

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:58:04 PM: e996f3ab-6a81-4bd3-9665-fef351b492c9 - TokenCache: Looking up cache 
for a token...

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:58:04 PM: e996f3ab-6a81-4bd3-9665-fef351b492c9 - TokenCache: An item matching 
the requested resource was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Verbose: 1 : 
DEBUG: 7/13/2016 6:58:04 PM: e996f3ab-6a81-4bd3-9665-fef351b492c9 - TokenCache: 42.0380720083333 
minutes left until token in cache expires

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:58:04 PM: e996f3ab-6a81-4bd3-9665-fef351b492c9 - TokenCache: A matching item (
access token or refresh token or both) was found in the cache

DEBUG: Microsoft.IdentityModel.Clients.ActiveDirectory Information: 2 : 
DEBUG: 7/13/2016 6:58:04 PM: e996f3ab-6a81-4bd3-9665-fef351b492c9 - AcquireTokenHandlerBase: === 
Token Acquisition finished successfully. An access token was retuned:
	Access Token Hash: IX17mRqqJzTp5RUHwZHMq1HmPbD9nrAePkl2ByU0KZ8=
	Refresh Token Hash: qmhST83YpPL5zyZXWWnB7tlfQLDG0/xQ0LMGdvQ5pqM=
	Expiration Time: 7/13/2016 7:40:06 PM +00:00
	User Hash: l5c/lHsl8nsQ+GnhF+I2JiJdzspZPrYo9QovfEwXhOc=
	

DEBUG: ============================ HTTP REQUEST ============================

HTTP Method:
GET

Absolute Uri:
https://management.azure.com/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/my
group2/providers/Microsoft.Compute/virtualMachines/myvm2/extensions/BGInfo?api-version=2016-03-30


Headers:

Body:



DEBUG: ============================ HTTP RESPONSE ============================

Status Code:
OK

Headers:
Pragma                        : no-cache
Strict-Transport-Security     : max-age=31536000; includeSubDomains
x-ms-served-by                : d098c1a0-556e-4624-bdd9-c5bf4863de8b_131097741406594856
x-ms-request-id               : 82fcec66-b02e-487a-8d8f-ae35f2569bac
Cache-Control                 : no-cache
Server                        : Microsoft-HTTPAPI/2.0,Microsoft-HTTPAPI/2.0
x-ms-ratelimit-remaining-subscription-reads: 14997
x-ms-correlation-request-id   : 9d0d0377-8aed-4db7-9d7b-4033556eb3db
x-ms-routing-request-id       : CENTRALUS:20160713T185804Z:9d0d0377-8aed-4db7-9d7b-4033556eb3db
Date                          : Wed, 13 Jul 2016 18:58:03 GMT

Body:
{
  "properties": {
    "publisher": "Microsoft.Compute",
    "type": "BGInfo",
    "typeHandlerVersion": "2.1",
    "autoUpgradeMinorVersion": true,
    "provisioningState": "Succeeded"
  },
  "id": "/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/mygroup2/providers/Mi
crosoft.Compute/virtualMachines/myvm2/extensions/BGInfo",
  "name": "BGInfo",
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "location": "centralus"
}



DEBUG: 11:58:05 AM - NewAzureVMCommand end processing.
DEBUG: 11:58:05 AM - NewAzureVMCommand end processing.
RequestId IsSuccessStatusCode StatusCode ReasonPhrase
--------- ------------------- ---------- ------------
                         True         OK OK          



PS C:\Users\abhanand> $vnet.Subnets[0].Id
/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/mygroup2/provider
s/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1

PS C:\Users\abhanand> $vnet.Subnets[1].Id

PS C:\Users\abhanand> $vnet.Subnets[0].Id
/subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/resourceGroups/mygroup2/providers/Microsoft.Network/virtualN
etworks/myvnet1/subnets/mysubnet1

PS C:\Users\abhanand>  Get-AzureRmResource -ResourceGroupName mygroup2
Get-AzureRmResource : Parameter set cannot be resolved using the specified named parameters.
At line:1 char:2
+  Get-AzureRmResource -ResourceGroupName mygroup2
+  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidArgument: (:) [Get-AzureRmResource], ParameterBindingException
    + FullyQualifiedErrorId : AmbiguousParameterSet,Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implement 
   ation.GetAzureResourceCmdlet
 

PS C:\Users\abhanand>  Get-AzureRmResource -ResourceGroupName mygroup2
Get-AzureRmResource : Parameter set cannot be resolved using the specified named parameters.
At line:1 char:2
+  Get-AzureRmResource -ResourceGroupName mygroup2
+  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidArgument: (:) [Get-AzureRmResource], ParameterBindingException
    + FullyQualifiedErrorId : AmbiguousParameterSet,Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implement 
   ation.GetAzureResourceCmdlet
 

PS C:\Users\abhanand> 

#>