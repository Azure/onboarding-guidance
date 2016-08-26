Requirements :- [Image Format RequirmentHere](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-upload-vhd/#requirements)

[Prepare the image to be uploaded](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-upload-vhd/#prepare-the-image-to-be-uploaded)


Step 2 : Capture the VM

#### To login to your Azure Subscription
azure login

#### List all the accounts that you have access .
azure account list

#### Set default account for the session
azure account set XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
azure account show

#### Change Mode to arm
azure config mode arm

#### Create a resource group or use an existing ResourceGroup
azure group create TestRG --location "WestUS"

#### Create a storage account or use an existing storage account
azure storage account create testuploadedstorage --resource-group TestRG --location "WestUS" --kind Storage --sku-name LRS

#### List storage account keys
azure storage account keys list testuploadedstorage --resource-group TestRG

#### Create a storage container
azure storage container create --account-name testuploadedstorage --account-key <key1> --container vm-images

#### Upload VHD
azure storage blob upload --blobtype page --account-name testuploadedstorage --account-key <key1> --container vm-images /path/to/disk/yourdisk.vhd


```shell

: <<'OUTPUT'

OUTPUT
```
