# Connecting to Azure using Azure Command-Line Interface (Azure CLI)




To login to your Azure Subscription

```shell
# To login to Azure Subscription

azure login

: <<'OUTPUT'
info:    Executing command login
|info:    To sign in, use a web browser to open the page https://aka.ms/devicelogin. Enter the code XXXXXXXX to authenticate.
-info:    Added subscription Microsoft Azure Internal Consumption
info:    Setting subscription "Microsoft Azure Internal Consumption" as default
+
info:    login command OK
OUTPUT

```

To view your Azure Subscription

```shell
# To view all subscriptions for your account - List the imported subscriptions
azure account list

: <<'OUTPUT'
info:    Executing command account list
data:    Name                                  Id                                    Current  State
data:    ------------------------------------  ------------------------------------  -------  -------
data:    Microsoft Azure Internal Consumption  XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX  true     Enabled
data:    Microsoft Azure Internal Consumption  XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX  false    Enabled
info:    account list command OK
OUTPUT

azure account show

: <<'OUTPUT'
info:    Executing command account show
data:    Name                        : Microsoft Azure Internal Consumption
data:    ID                          : XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX
data:    State                       : Enabled
data:    Tenant ID                   : XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX
data:    Is Default                  : true
data:    Environment                 : AzureCloud
data:    Has Certificate             : No
data:    Has Access Token            : Yes
data:    User name                   : user@user.com
data:
info:    account show command OK
OUTPUT
```

Set the current subscription
```shell
# To select a default subscription for your current session
azure account set XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

: <<'OUTPUT'
info:    Executing command account set
info:    Setting subscription to "Microsoft Azure Internal Consumption" with id "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX".
info:    Changes saved
info:    account set command OK
OUTPUT
```
Remove a subscription or environment, or clear all of the stored account and environment info
```shell
azure account clear -vv
: <<'OUTPUT'
info:    Executing command account clear
This will clear all account information. Are you sure? [y/n]  y
silly:   C:\Users\user1\.azure\managementCertificate.pem does not exist
silly:   C:\Users\user1\.azure\publishSettings.xml does not exist
silly:   Removing C:\Users\user1\.azure\azureProfile.json
silly:   C:\Users\user1\.azure\accessTokens.json does not exist
info:    Account settings cleared successfully
info:    account clear command OK
OUTPUT
```
Commands to manage your account environment

```
account env list [options]
account env show [options] [environment]
account env add [options] [environment]
account env set [options] [environment]
account env delete [options] [environment]
```



To see Location that can be accessed in your current subscriptions
```shell
azure location list

or

azure location list  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

: <<'OUTPUT'
info:    Executing command location list
warn:    The "location list" commands is changed to list subscription's locations. For old information, use "provider list or show" commands.
info:    Getting locations...
data:    Name                Display Name         Latitude  Longitude
data:    ------------------  -------------------  --------  ---------
data:    eastasia            East Asia            22.267    114.188
data:    southeastasia       Southeast Asia       1.283     103.833
data:    centralus           Central US           41.5908   -93.6208
data:    eastus              East US              37.3719   -79.8164
data:    eastus2             East US 2            36.6681   -78.3889
data:    westus              West US              37.783    -122.417
data:    northcentralus      North Central US     41.8819   -87.6278
data:    southcentralus      South Central US     29.4167   -98.5
data:    northeurope         North Europe         53.3478   -6.2597
data:    westeurope          West Europe          52.3667   4.9
data:    japanwest           Japan West           34.6939   135.5022
data:    japaneast           Japan East           35.68     139.77
data:    brazilsouth         Brazil South         -23.55    -46.633
data:    australiaeast       Australia East       -33.86    151.2094
data:    australiasoutheast  Australia Southeast  -37.8136  144.9631
data:    southindia          South India          12.9822   80.1636
data:    centralindia        Central India        18.5822   73.9197
data:    westindia           West India           19.088    72.868
data:    canadacentral       Canada Central       43.653    -79.383
data:    canadaeast          Canada East          46.817    -71.217
data:    westcentralus       West Central US      40.890    -110.234
data:    westus2             West US 2            47.233    -119.852
info:    location list command OK
OUTPUT

```

To check Available AzureRmResourceProvider


```shell

azure provider list

: <<'OUTPUT'

info:    Executing command provider list
+ Getting ARM registered providers
data:    Namespace                               Registered
data:    --------------------------------------  -------------
data:    Microsoft.Batch                         Registered
data:    Microsoft.Cache                         Registered
data:    Microsoft.ClassicCompute                Registered
data:    Microsoft.ClassicNetwork                Registered
data:    Microsoft.ClassicStorage                Registered
data:    Microsoft.Compute                       Registered
data:    Microsoft.EventHub                      Registered
data:    Microsoft.HdInsight                     Registered
data:    microsoft.insights                      Registered
data:    Microsoft.KeyVault                      Registered
data:    Microsoft.Network                       Registered
data:    Microsoft.OperationalInsights           Registered
data:    Microsoft.RecoveryServices              Registered
data:    Microsoft.ResourceHealth                Registered
data:    Microsoft.Security                      Registered
data:    Microsoft.ServiceFabric                 Registered
data:    Microsoft.SiteRecovery                  Registered
data:    Microsoft.Sql                           Registered
data:    Microsoft.Storage                       Registered
data:    Microsoft.Web                           Registered
data:    Aspera.Transfers                        NotRegistered
data:    Citrix.Cloud                            NotRegistered
data:    Cloudyn.Analytics                       NotRegistered
data:    Conexlink.MyCloudIT                     NotRegistered
data:    Dynatrace.Ruxit                         NotRegistered
data:    LiveArena.Broadcast                     NotRegistered
data:    Lombiq.DotNest                          NotRegistered
data:    Microsoft.ADHybridHealthService         Registered
data:    Microsoft.ApiManagement                 NotRegistered
data:    Microsoft.AppService                    NotRegistered
data:    Microsoft.Authorization                 Registered
data:    Microsoft.Automation                    NotRegistered
data:    Microsoft.BingMaps                      NotRegistered
data:    Microsoft.BizTalkServices               NotRegistered
data:    Microsoft.Cdn                           NotRegistered
data:    Microsoft.CertificateRegistration       NotRegistered
data:    Microsoft.ClassicInfrastructureMigrate  NotRegistered
data:    Microsoft.CognitiveServices             NotRegistered
data:    Microsoft.ContainerService              NotRegistered
data:    Microsoft.ContentModerator              NotRegistered
data:    Microsoft.DataCatalog                   NotRegistered
data:    Microsoft.DataFactory                   NotRegistered
data:    Microsoft.DataLakeAnalytics             NotRegistered
data:    Microsoft.DataLakeStore                 NotRegistered
data:    Microsoft.Devices                       NotRegistered
data:    Microsoft.DevTestLab                    NotRegistered
data:    Microsoft.DocumentDB                    NotRegistered
data:    Microsoft.DomainRegistration            NotRegistered
data:    Microsoft.DynamicsLcs                   NotRegistered
data:    Microsoft.Features                      Registered
data:    Microsoft.Logic                         NotRegistered
data:    Microsoft.MachineLearning               NotRegistered
data:    Microsoft.MarketplaceOrdering           NotRegistered
data:    Microsoft.Media                         NotRegistered
data:    Microsoft.NotificationHubs              NotRegistered
data:    Microsoft.OperationsManagement          NotRegistered
data:    Microsoft.Portal                        NotRegistered
data:    Microsoft.PowerBI                       NotRegistered
data:    Microsoft.Resources                     Registered
data:    Microsoft.Scheduler                     NotRegistered
data:    Microsoft.Search                        NotRegistered
data:    Microsoft.ServerManagement              NotRegistered
data:    Microsoft.ServiceBus                    NotRegistered
data:    Microsoft.StreamAnalytics               NotRegistered
data:    microsoft.support                       Registered
data:    microsoft.visualstudio                  NotRegistered
data:    Myget.PackageManagement                 NotRegistered
data:    NewRelic.APM                            NotRegistered
data:    Pokitdok.Platform                       NotRegistered
data:    RavenHq.Db                              NotRegistered
data:    Raygun.CrashReporting                   NotRegistered
data:    Sendgrid.Email                          NotRegistered
data:    Signiant.Flight                         NotRegistered
data:    SuccessBricks.ClearDB                   NotRegistered
data:    TrendMicro.DeepSecurity                 NotRegistered
data:    U2uconsult.TheIdentityHub               NotRegistered
info:    provider list command OK

OUTPUT

```
