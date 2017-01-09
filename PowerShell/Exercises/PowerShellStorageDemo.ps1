##################################################################

# Microsoft Azure Storage Explorer  : http://storageexplorer.com/ 

#################################################
#login to the Account 
Login-AzureRmAccount

$rg = 'ftaz-poc-rg'
$stname = 'ftazweb01vmst'

# Uploading VHD using Powershell 

Add-AzureRmVhd -ResourceGroupName $rg -Destination https://ftazweb01vmst.blob.core.windows.net/vhds/customuploaded.vhd -LocalFilePath "C:\Users\abhanand\Downloads\9600.16415.amd64fre.winblue_refresh.130928-2229_server_serverdatacentereval_en-us.vhd" -Verbose -debug

#################################################


# List all Storage Account 
Get-AzureRmStorageAccount |select ResourceGroupName,storageAccountName,Location -Verbose -Debug

# Verify Correct storage account details  where you would like to upload data 
Get-AzureRmStorageAccount -ResourceGroupName $rg -StorageAccountName $stname

#Get Storage account Key 
$storageAccoutKey =(Get-AzureRMStorageAccountKey -ResourceGroupName $rg -Name ftazweb01vmst)[0].value

# Get Context where you would like to upload data 
$storageAccountContext = New-AzureStorageContext -StorageAccountKey $storageAccoutKey -StorageAccountName $stname

# Create new containers in the storage account 
New-AzureStorageContainer -Name container1 -Context $storageAccountContext -Permission Off

Get-AzureStorageContainer -Context $storageAccountContext | select Name

##################################################################

# upload data to Azure  
Set-AzureStorageBlobContent -File "C:\Users\abhanand\Downloads\data\cat1.jpg" -Container container1 -Blob catuploaded.jpg -Context $storageAccountContext -Verbose -debug

##################################################################

# Download the latest version of AzCopy : http://aka.ms/downloadazcopy 
# Documentaion  : https://azure.microsoft.com/en-us/documentation/articles/storage-use-azcopy/ 

# PS C:\Users\abhanand> cd "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"

# PS C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy> 

.\AzCopy.exe /Source:C:\Users\abhanand\Downloads\data /Dest:https://$stname.blob.core.windows.net/container1 /DestKey:<key> /S /V

##################################################################



