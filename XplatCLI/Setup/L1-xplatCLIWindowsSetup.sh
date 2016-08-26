#!/bin/bash

# Download : [Windows installer](https://www.microsoft.com/web/handlers/webpi.ashx?command=getinstallerredirect&appid=windowsazurexplatcli&mode=new)

# Open command prompt.
# Type azure as first command.
## First Time after installation : Select y to enable data collection :(y/n)  [ You can choose y/n based on your preference ]

azure config mode arm

: <<'END'
comments' here
and here

info:    Executing command config mode
info:    New mode is arm
info:    config mode command OK
END

# To verify mode of your CLI
azure
: <<'END'

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


END
#### Another way to get version of Command Line Interface

azure --version
: <<'END'

0.10.2 (node: 4.2.4)
END
