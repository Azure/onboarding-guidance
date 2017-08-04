#### To login to your Azure Subscription
az login

#### List all the accounts that you have access .
az account list

#### Set default account for the session
az account set -s XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
az account show

#### To see Locations that can be accessed in your current subscriptions
```shell
az account list-locations
```

#### Lists virtual machines image publishers
```shell
az vm image list-publishers --location eastus
```
#### Lists virtual machines image offers by a publisher
```shell
az vm image list-offers --location eastus --publisher Canonical

or

az vm image list-offers -l eastus -p Canonical
```
#### Lists virtual machines image skus for a specific offer from a publisher
```shell
az vm image list-skus --location eastus --publisher Canonical --offer UbuntuServer

or

az vm image list-skus -l eastus -p Canonical -f UbuntuServer
```
#### Lists the virtual machines images
```shell
az vm image list --location eastus --publisher Canonical --offer UbuntuServer --sku 17.04 --all

or

az vm image list -l eastus -p Canonical -f UbuntuServer -s 17.04 --all
```

NOTE : Version :17.04.201704121  [17.04 - Ubuntu Verison | 201704121 - First 8 digit signifies Published Date for the image  in this case 2017-04-12 (YYYY-MM-DD)

#### Lists the virtual machines images
```shell
az vm image show --location eastus --publisher Canonical --offer UbuntuServer --sku 17.04 --version 17.04.201704121

or

az vm image show -l eastus -p Canonical -f UbuntuServer -s 17.04 --version 17.04.201704121

{
  "dataDiskImages": [],
  "id": "/Subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/Providers/Microsoft.Compute/Locations/eastus/Publishers/Canonical/ArtifactTypes/VMImage/Offers/UbuntuServer/Skus/17.04/Versions/17.04.201704121",
  "location": "eastus",
  "name": "17.04.201704121",
  "osDiskImage": {
    "operatingSystem": "Linux"
  },
  "plan": null,
  "tags": null
}
```
# See the following resources to learn more
* [Virtual Machines Marketplace](https://azure.microsoft.com/en-us/marketplace/virtual-machines/)
