# How to install Command Line Interface on Windows :-


1. Download : [Windows installer](https://www.microsoft.com/web/handlers/webpi.ashx?command=getinstallerredirect&appid=windowsazurexplatcli&mode=new)  

* Open command prompt.
* Type azure as first command.
* Select y to enable data collection :(y/n)  [ You can choose y/n based on your preference ]

```
info:             _    _____   _ ___ ___
info:            /_\  |_  / | | | _ \ __|
info:      _ ___/ _ \__/ /| |_| |   / _|___ _ _
info:    (___  /_/ \_\/___|\___/|_|_\___| _____)
info:       (_______ _ _)         _ ______ _)_ _
info:              (______________ _ )   (___ _ _)
info:
info:    Microsoft Azure: Microsoft's Cloud Platform
info:
info:    Tool version 0.10.2
help:
help:    Display help for a given command
help:      help [options] [command]
help:
help:    Log in to an Azure subscription using Active Directory or a Microsoft account identity.
help:      login [options]
help:
help:    Log out from Azure subscription using Active Directory. Currently, the user can log out only via Microsoft organizational account
help:      logout [options] [username]
help:
help:    Open the portal in a browser
help:      portal [options]
help:
help:    Manages the data collection preference.
help:      telemetry [options]
help:
help:    Commands:
help:      account        Commands to manage your account information and publish settings
help:      batch          Commands to manage your Batch objects
help:      config         Commands to manage your local settings
help:      hdinsight      HDInsight commands in ASM mode are deprecated and will be removed in January 2017. Please use ARM mode instead by entering:  azure config mode arm
To submit jobs, please use a Secure Shell (SSH) connection to your cluster.
For more information, go to http://go.microsoft.com/fwlink/?LinkID=746541&clcid=0x404
Commands to manage HDInsight clusters and jobs
help:      mobile         Commands to manage your Mobile Services
help:      network        Commands to manage your networks
help:      sb             Commands to manage your Service Bus configuration
help:      service        Commands to manage your Cloud Services
help:      site           Commands to manage your Web Sites
help:      sql            Commands to manage your SQL Server accounts
help:      storage        Commands to invoke service management operations.
help:      vm             Commands to manage your Virtual Machines
help:
help:    Options:
help:      -h, --help     output usage information
help:      -v, --version  output the application version
help:
help:    Current Mode: asm (Azure Service Management)
```

* important information :-

-- info:    Tool version

-- help:    Current Mode:  


* Now, you will need to change the Azure CLI in resource manager mode (azure config mode arm)

NOTE : The Azure Resource Manager mode and Azure Service Management mode are mutually exclusive. That is, resources created in one mode cannot be managed from the other mode.
```shell
azure config mode arm

info:    Executing command config mode
info:    New mode is arm
info:    config mode command OK
```
* To verify mode of your CLI

```
C:\Users\user1>azure
info:             _    _____   _ ___ ___
info:            /_\  |_  / | | | _ \ __|
info:      _ ___/ _ \__/ /| |_| |   / _|___ _ _
info:    (___  /_/ \_\/___|\___/|_|_\___| _____)
info:       (_______ _ _)         _ ______ _)_ _
info:              (______________ _ )   (___ _ _)
info:
info:    Microsoft Azure: Microsoft's Cloud Platform
info:
info:    Tool version 0.10.2
help:
help:    Display help for a given command
help:      help [options] [command]
help:
help:    Log in to an Azure subscription using Active Directory or a Microsoft account identity.
help:      login [options]
help:
help:    Log out from Azure subscription using Active Directory. Currently, the user can log out only via Microsoft organizational account
help:      logout [options] [username]
help:
help:    Open the portal in a browser
help:      portal [options]
help:
help:    Manages the data collection preference.
help:      telemetry [options]
help:
help:    Commands:
help:      account          Commands to manage your account information and publish settings
help:      acs              Commands to manage your container service.
help:      ad               Commands to display Active Directory objects
help:      availset         Commands to manage your availability sets.
help:      batch            Commands to manage your Batch objects
help:      cdn              Commands to manage Azure Content Delivery Network (CDN)
help:      config           Commands to manage your local settings
help:      datalake         Commands to manage your Data Lake objects
help:      feature          Commands to manage your features
help:      group            Commands to manage your resource groups
help:      hdinsight        Commands to manage HDInsight clusters and jobs
help:      insights         Commands related to monitoring Insights (events, alert rules, autoscale settings, metrics)
help:      keyvault         Commands to manage key vault instances in the Azure Key Vault service
help:      lab              Commands to manage your DevTest Labs
help:      location         Commands to get the available locations
help:      network          Commands to manage network resources
help:      policy           Commands to manage your policies on ARM Resources.
help:      powerbi          Commands to manage your Azure Power BI Embedded Workspace Collections
help:      provider         Commands to manage resource provider registrations
help:      quotas           Command to view your aggregated Azure quotas
help:      rediscache       Commands to manage your Azure Redis Cache(s)
help:      resource         Commands to manage your resources
help:      role             Commands to manage role definitions
help:      servermanagement Commands to manage Azure Server Managment resources
help:      storage          Commands to manage your Storage objects
help:      tag              Commands to manage your resource manager tags
help:      usage            Command to view your aggregated Azure usage data
help:      vm               Commands to manage your virtual machines
help:      vmss             Commands to manage your virtual machine scale sets.
help:      vmssvm           Commands to manage your virtual machine scale set vm.
help:      webapp           Commands to manage your Azure webapps
help:
help:    Options:
help:      -h, --help     output usage information
help:      -v, --version  output the application version
help:
help:    Current Mode: arm (Azure Resource Management)

```
#### Another way to get version of Command Line Interface
```shell
azure --version

0.10.2 (node: 4.2.4)
```
