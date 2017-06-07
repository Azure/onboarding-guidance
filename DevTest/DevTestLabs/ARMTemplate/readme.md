# Dev Test Labs - Azure Resource Manager Template

This ARM Teplates creates a Dev Test Lab environment, for demonstration purposes during a Fast Track for Azure DevTest engagement. In particular, the components created are as follows: 

* A DevTest Lab with policies 
* **TBC: A private artifact repository for the lab environment**
* Two VM Types, Dev and Test. Using a parameter, you can configure the number of each VM type that is created.
* Two custom images, captured from those two VM types mentioned above.

The lab has been designed, so that it can follow recommended practices around naming conventions. To customise the lab naming, please update the parameter values in azuredeploy.parameters.json.

## Pre-Requisites
* Install [Azure Powershell](http://aka.ms/webpi-azps)

## Setup Instructions
1. Download all files from this folder (ProvisionDemoLab.ps1, azuredeploy.json, azuredeploy.parameters.json) under the same folder, e.g. C:\Users\Username\Desktop\DemoLabTemplate.

2. Run Windows Powershell

3. In the Windows Powershell console, navigate to the folder in which you stored these files by running the following command

```PowerShell
cd "<your folderpath">
```

4. Execute the following command


```PowerShell
.\ProvisionDemoLab.ps1 -SubscriptionId "<Azure subscription ID where the lab will be created>" -ResourceGroupName "<name for the new resource group where the lab will be created, remember to follow a good naming convention>" -ResourceGroupLocation "<location for the resource group to be created. e.g. West US>"

e.g.

.\ProvisionDemoLab.ps1 -SubscriptionId "12345678-1234-5678-1234-123456789000" -ResourceGroupName "fta-dev-dtl-rg" -ResourceGroupLocation "North Europe"
```
If you encounter any isues running this template, please raise an issue on our GitHub page. Thanks!