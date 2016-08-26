# To find published image on Azure. Customer needs to go through few steps

# To login to Azure Resource Manager
Login-AzureRmAccount

# List All the Datacenter that Subscription has access too.
Get-AzureRmLocation | select Location, DisplayName

Get-AzureRmLocation | sort Location | Select Location, DisplayName

# List All the Publisher in the given region that Subscription has access too.
Get-AzureRmVMImagePublisher -Location "West US" |select PublisherName

# List all the offers from the publisher 
Get-AzureRmVMImageOffer -Location "West US" -PublisherName "Canonical"

# List all the possible SKU for an offer 
Get-AzureRmVMImageSku -Location "West US" -PublisherName "Canonical" -Offer "UbuntuServer"

# List all the Images offered under seelcted SKU
Get-AzureRmVMImage -Location "West US" -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "16.04.0-LTS"

# To select your desired image for deployment 
Get-AzureRmVMImage -Location "West US" -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "16.04.0-LTS" -Version "16.04.201604203"


