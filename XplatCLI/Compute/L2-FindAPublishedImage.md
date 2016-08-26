


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


#### To see Location that can be accessed in your current subscriptions

```shell
azure location list

or

azure location list  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX
```
#### Lists virtual machines image publishers
```shell
azure vm image list-publishers --location eastus

: <<'OUTPUT'

OUTPUT
```
#### Lists virtual machines image offers by a publisher
```shell
azure vm image list-offers --location eastus --publisher Canonical

: <<'OUTPUT'

OUTPUT
```
#### Lists virtual machines image skus for a specific offer from a publisher
```shell
azure vm image list-skus --location eastus --publisher Canonical --offer UbuntuServer

: <<'OUTPUT'

OUTPUT
```
#### Lists the virtual machines images
```shell
azure vm image list --location eastus --publisher Canonical --offer UbuntuServer --sku 16.04.0-LTS

: <<'OUTPUT'

OUTPUT
```

NOTE : Version :16.04.201606100  [16.04 - Ubuntu Verison | 20160815 - First 8 digit signifies Published Date for the image  in this case 2016-08-15 (YYYY-MM-DD)

#### Lists the virtual machines images
```shell
azure vm image show --location eastus --publisher Canonical --offer UbuntuServer --sku 16.04.0-LTS --version 16.04.201608150

: <<'OUTPUT'

OUTPUT
```
# See the following resources to learn more
* [Virtual Machines Marketplace](https://azure.microsoft.com/en-us/marketplace/virtual-machines/)
