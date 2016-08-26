# Module:- Find desired image on Azure Platform

# Abstract

During this module, you will learn to find available images on Azure and create a new virtual machine from it.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Find available images on Azure
* List All the Datacenters that a Subscription has access too
* List all the Images offered under selected SKU
* Select your desired image for deployment

# Prerequisite 
* Completion of [Module on Storage](https://github.com/Azure/onboarding-guidance/tree/master/windows/Module%20I)

# Estimated time to complete this module:
Self-guided

# What are Marketplace Virtual Machine Images?
Virtual Machines Marketplace images are download certified pre-configured software images for your Linux or Windows Server VMs from Microsoft and industry-leading software providers.

# Find available images on Azure

To find published image on Azure. Customer needs to go through few steps

1. Choose right location
2. Each location has multiple publisher - Choose Right Publisher in the given region
3. Each publisher has multiple offer - Choose right offer form selected publisher in the given region
4. Each offer has multiple sku  - Choose right sku from correct offer from  selected publisher in the given region.
5. Each sku has multiple version  - Each version correspond to one image.

#### List All the Datacenter that Subscription has access too.
```PowerShell
# List All the Datacenter that Subscription has access too.
Get-AzureRmLocation | select Location, DisplayName

```

|Location    |       DisplayName   |     
|--------     |      -----------  |      
|eastasia        |   East Asia    |      
|centralus        |  Central US   |      
|southeastasia  |    Southeast Asia   |  
|eastus            | East US       |     
|eastus2            |East US 2      |    
|westus           |  West US         |   
|northcentralus   |  North Central US |  
|southcentralus   |  South Central US  |
|northeurope      |  North Europe       |
|westeurope       |  West Europe        |
|japanwest        |  Japan West         |
|japaneast        |  Japan East         |
|brazilsouth      |  Brazil South       |
|australiaeast    |  Australia East     |
|australiasoutheast| Australia Southeast|
|southindia        | South India        |
|centralindia      | Central India      |
|westindia         | West India         |
|canadacentral     | Canada Central     |
|canadaeast        | Canada East        |


#### List All the Publisher in the given region that Subscription has access too.
```PowerShell
# List All the Publisher in the given region that Subscription has access too.
Get-AzureRmVMImagePublisher -Location "East US" |select PublisherName
```

PublisherName                                       

4psa                                                
4ward365                                            
7isolutions                                         
a10networks   
...
Canonical
...
your-shop-online                                    
zementis                                            
zend                                                
zoomdata  

#### List all the offers from the publisher
```PowerShell
# List all the offers from the publisher
Get-AzureRmVMImageOffer -Location "East US" -PublisherName "Canonical"
```


|Offer  |                   PublisherName |Location|  Id  |                                                                                                     
| :------------- | ------------- | ------------- | ------------- |
|Ubuntu15.04Snappy     |    Canonical  |   eastus |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/eastus/Publi...|
|Ubuntu15.04SnappyDocker |  Canonical |    eastus |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/eastus/Publi...|
|UbuntuServer          |    Canonical  |   eastus |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/eastus/Publi...|
|Ubuntu_Snappy_Core     |   Canonical  |   eastus |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/eastus/Publi...|
|Ubuntu_Snappy_Core_Docker |Canonical   |  eastus |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/eastus/Publi...|

#### List all the possible SKU for an offer
```PowerShell
# List all the possible SKU for an offer
Get-AzureRmVMImageSku -Location "East US" -PublisherName "Canonical" -Offer "UbuntuServer"
```

| Skus   |      Offer   |     PublisherName |Location | Id |                                                                             
| :-------      |    ----------------  | ----       | ----- | ----- |
|16.04.0-DAILY-LTS | UbuntuServer | Canonical   |   eastus  |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/eastus/...|
|16.04.0-LTS      |  UbuntuServer|  Canonical |     eastus |   /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/eastus/...|
|16.10-DAILY      |  UbuntuServer | Canonical    |  eastus  |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/eastus/...|

#### List all the Images offered under selected SKU
```PowerShell
# List all the Images offered under selected SKU
Get-AzureRmVMImage -Location "East US" -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "16.04.0-LTS"
```

| Version    |      FilterExpression | Skus      |   Offer   |      PublisherName|  Location|  Id  |                                                                      
| :-------      |    ----------------  | ----       |     ----- |      -------------| --------  | ---- |                                                                    
|16.04.201604203     |   |              16.04.0-LTS | UbuntuServer | Canonical |      eastus  |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsof...|
|16.04.201605161       |    |              16.04.0-LTS | UbuntuServer | Canonical |      eastus  |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsof...|
|16.04.201606100           |   |              16.04.0-LTS | UbuntuServer | Canonical |      eastus  |  /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsof...|


NOTE : Version :16.04.201606100  [16.04 - Ubuntu Verison | 201606100 - First 8 digit signifies Published Date for the image  in this case 2016-06-10 (YYYY-MM-DD) ]

#### To select your desired image for deployment
```PowerShell
# To select your desired image for deployment
Get-AzureRmVMImage -Location "West US" -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "16.04.0-LTS" -Version "16.04.201604203"

Output :

Id               : /Subscriptions/6b6a59a6-e367-4913-bea7-34b6862095bf/Providers/Microsoft.Compute/Locations/w
                   estus/Publishers/Canonical/ArtifactTypes/VMImage/Offers/UbuntuServer/Skus/16.04.0-LTS/Versi
                   ons/16.04.201604203
Location         : westus
PublisherName    : Canonical
Offer            : UbuntuServer
Skus             : 16.04.0-LTS
Version          : 16.04.201604203
FilterExpression :
Name             : 16.04.201604203
OSDiskImage      : {
                     "operatingSystem": "Linux"
                   }
PurchasePlan     : null
DataDiskImages   : []
```
# See the following resources to learn more
* [Virtual Machines Marketplace](https://azure.microsoft.com/en-us/marketplace/virtual-machines/)
