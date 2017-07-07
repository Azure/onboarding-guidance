# Connecting to Azure using Azure Command-Line Interface (Azure CLI)


To login to your Azure Subscription

```shell
# To login to Azure Subscription

az login
To sign in, use a web browser to open the page https://aka.ms/devicelogin and enter the code XXXXXXXXX to authenticate.
[
  {
    "cloudName": "AzureCloud",
    "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "isDefault": true,
    "name": "Azure FastTrack Team - jstrom Subscription",
    "state": "Enabled",
    "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX",
    "user": {
      "name": "jstrom@microsoft.com",
      "type": "user"
    }
  },
  {
    "cloudName": "AzureCloud",
    "id": "YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY",
    "isDefault": false,
    "name": "Azure FastTrack - Umar Subscription",
    "state": "Enabled",
    "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX",
    "user": {
      "name": "jstrom@microsoft.com",
      "type": "user"
    }
  }
]

```

To view your Azure Subscription

```shell
# To view all subscriptions for your account - List the imported subscriptions
az account list
[
  {
    "cloudName": "AzureCloud",
    "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "isDefault": true,
    "name": "Azure FastTrack Team - jstrom Subscription",
    "state": "Enabled",
    "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX",
    "user": {
      "name": "jstrom@microsoft.com",
      "type": "user"
    }
  },
  {
    "cloudName": "AzureCloud",
    "id": "YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY",
    "isDefault": false,
    "name": "Azure FastTrack - Umar Subscription",
    "state": "Enabled",
    "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX",
    "user": {
      "name": "jstrom@microsoft.com",
      "type": "user"
    }
  }
]

# Show current subscription selected
az account show

{
  "environmentName": "AzureCloud",
  "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "isDefault": true,
  "name": "Azure FastTrack Team - jstrom Subscription",
  "state": "Enabled",
  "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX",
  "user": {
    "name": "jstrom@microsoft.com",
    "type": "user"
  }
}
```

Set the current subscription
```shell
# To select a default subscription for your current session
az account set -s YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY

```
Remove a subscription or environment, or clear all of the stored account and environment info
```shell
# To remove all logged in sessions
az account clear

To see Location that can be accessed in your current subscriptions
```shell
az account list-locations
[
  {
    "displayName": "East Asia",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/eastasia",
    "latitude": "22.267",
    "longitude": "114.188",
    "name": "eastasia",
    "subscriptionId": null
  },
  {
    "displayName": "Southeast Asia",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/southeastasia",
    "latitude": "1.283",
    "longitude": "103.833",
    "name": "southeastasia",
    "subscriptionId": null
  },
  {
    "displayName": "Central US",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/centralus",
    "latitude": "41.5908",
    "longitude": "-93.6208",
    "name": "centralus",
    "subscriptionId": null
  },
  {
    "displayName": "East US",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/eastus",
    "latitude": "37.3719",
    "longitude": "-79.8164",
    "name": "eastus",
    "subscriptionId": null
  },
  {
    "displayName": "East US 2",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/eastus2",
    "latitude": "36.6681",
    "longitude": "-78.3889",
    "name": "eastus2",
    "subscriptionId": null
  },
  {
    "displayName": "West US",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/westus",
    "latitude": "37.783",
    "longitude": "-122.417",
    "name": "westus",
    "subscriptionId": null
  },
  {
    "displayName": "North Central US",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/northcentralus",
    "latitude": "41.8819",
    "longitude": "-87.6278",
    "name": "northcentralus",
    "subscriptionId": null
  },
  {
    "displayName": "South Central US",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/southcentralus",
    "latitude": "29.4167",
    "longitude": "-98.5",
    "name": "southcentralus",
    "subscriptionId": null
  },
  {
    "displayName": "North Europe",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/northeurope",
    "latitude": "53.3478",
    "longitude": "-6.2597",
    "name": "northeurope",
    "subscriptionId": null
  },
  {
    "displayName": "West Europe",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/westeurope",
    "latitude": "52.3667",
    "longitude": "4.9",
    "name": "westeurope",
    "subscriptionId": null
  },
  {
    "displayName": "Japan West",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/japanwest",
    "latitude": "34.6939",
    "longitude": "135.5022",
    "name": "japanwest",
    "subscriptionId": null
  },
  {
    "displayName": "Japan East",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/japaneast",
    "latitude": "35.68",
    "longitude": "139.77",
    "name": "japaneast",
    "subscriptionId": null
  },
  {
    "displayName": "Brazil South",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/brazilsouth",
    "latitude": "-23.55",
    "longitude": "-46.633",
    "name": "brazilsouth",
    "subscriptionId": null
  },
  {
    "displayName": "Australia East",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/australiaeast",
    "latitude": "-33.86",
    "longitude": "151.2094",
    "name": "australiaeast",
    "subscriptionId": null
  },
  {
    "displayName": "Australia Southeast",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/australiasoutheast",
    "latitude": "-37.8136",
    "longitude": "144.9631",
    "name": "australiasoutheast",
    "subscriptionId": null
  },
  {
    "displayName": "South India",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/southindia",
    "latitude": "12.9822",
    "longitude": "80.1636",
    "name": "southindia",
    "subscriptionId": null
  },
  {
    "displayName": "Central India",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/centralindia",
    "latitude": "18.5822",
    "longitude": "73.9197",
    "name": "centralindia",
    "subscriptionId": null
  },
  {
    "displayName": "West India",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/westindia",
    "latitude": "19.088",
    "longitude": "72.868",
    "name": "westindia",
    "subscriptionId": null
  },
  {
    "displayName": "Canada Central",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/canadacentral",
    "latitude": "43.653",
    "longitude": "-79.383",
    "name": "canadacentral",
    "subscriptionId": null
  },
  {
    "displayName": "Canada East",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/canadaeast",
    "latitude": "46.817",
    "longitude": "-71.217",
    "name": "canadaeast",
    "subscriptionId": null
  },
  {
    "displayName": "UK South",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/uksouth",
    "latitude": "50.941",
    "longitude": "-0.799",
    "name": "uksouth",
    "subscriptionId": null
  },
  {
    "displayName": "UK West",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/ukwest",
    "latitude": "53.427",
    "longitude": "-3.084",
    "name": "ukwest",
    "subscriptionId": null
  },
  {
    "displayName": "West Central US",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/westcentralus",
    "latitude": "40.890",
    "longitude": "-110.234",
    "name": "westcentralus",
    "subscriptionId": null
  },
  {
    "displayName": "West US 2",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/westus2",
    "latitude": "47.233",
    "longitude": "-119.852",
    "name": "westus2",
    "subscriptionId": null
  },
  {
    "displayName": "Korea Central",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/koreacentral",
    "latitude": "37.5665",
    "longitude": "126.9780",
    "name": "koreacentral",
    "subscriptionId": null
  },
  {
    "displayName": "Korea South",
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/locations/koreasouth",
    "latitude": "35.1796",
    "longitude": "129.0756",
    "name": "koreasouth",
    "subscriptionId": null
  }
]

```

To check Available AzureRmResourceProvider


```shell

az provider list
[
 {
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/providers/Microsoft.Advisor",
    "namespace": "Microsoft.Advisor",
    "registrationState": "Registered",
    "resourceTypes": [
      {
        "aliases": null,
        "apiVersions": [
          "2017-04-19-alpha",
          "2017-03-31-alpha",
          "2017-03-31",
          "2016-07-12-rc",
          "2016-07-12-preview",
          "2016-07-12-alpha",
          "2016-05-09-preview",
          "2016-05-09-alpha"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "suppressions"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2017-04-19-alpha",
          "2017-03-31-alpha",
          "2017-03-31",
          "2016-07-12-rc",
          "2016-07-12-preview",
          "2016-07-12-alpha",
          "2016-05-09-preview",
          "2016-05-09-alpha"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "recommendations"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2017-04-19-alpha",
          "2017-03-31-alpha",
          "2017-03-31",
          "2016-07-12-rc",
          "2016-07-12-preview",
          "2016-07-12-alpha",
          "2016-05-09-preview",
          "2016-05-09-alpha"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "generateRecommendations"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2017-04-19-alpha",
          "2017-03-31-alpha",
          "2017-03-31",
          "2016-07-12-rc",
          "2016-07-12-preview",
          "2016-07-12-alpha",
          "2016-05-09-preview",
          "2016-05-09-alpha"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "operations"
      }
    ]
  },
  #...
  #...
  #... Lots of other providers here
  #...
  #...
  {
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/providers/TrendMicro.DeepSecurity",
    "namespace": "TrendMicro.DeepSecurity",
    "registrationState": "NotRegistered",
    "resourceTypes": [
      {
        "aliases": null,
        "apiVersions": [
          "2015-06-15"
        ],
        "locations": [
          "Central US"
        ],
        "properties": null,
        "resourceType": "accounts"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2015-06-15"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "operations"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2015-06-15"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "listCommunicationPreference"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2015-06-15"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "updateCommunicationPreference"
      }
    ]
  },
  {
    "id": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/providers/U2uconsult.TheIdentityHub",
    "namespace": "U2uconsult.TheIdentityHub",
    "registrationState": "NotRegistered",
    "resourceTypes": [
      {
        "aliases": null,
        "apiVersions": [
          "2015-06-15"
        ],
        "locations": [
          "West Europe"
        ],
        "properties": null,
        "resourceType": "services"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2015-06-15"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "operations"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2015-06-15"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "listCommunicationPreference"
      },
      {
        "aliases": null,
        "apiVersions": [
          "2015-06-15"
        ],
        "locations": [],
        "properties": null,
        "resourceType": "updateCommunicationPreference"
      }
    ]
  }
]
```
