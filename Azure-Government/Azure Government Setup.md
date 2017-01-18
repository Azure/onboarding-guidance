# Azure Government

# Azure Government Documentation

Microsoft Azure Government delivers a cloud platform built upon the foundational principles of security, privacy and control, compliance, and transparency. Public Sector entities receive a physically isolated instance of Microsoft Azure that employs world-class security and compliance services critical to U.S. government for all systems and applications built on its architecture. For more info see [Azure Documentation](https://docs.microsoft.com/en-us/azure/azure-government-overview?toc=%2fazure%2fazure-government%2ftoc.json).

# Endpoints
* To access Azure Government Portal, go to: [http://portal.azure.us/](http://portal.azure.us/)
* To manage subscription and track usage go to: [https://account.windowsazure.us/](https://account.windowsazure.us/)

# PowerShell 
When using PowerShell to manage Azure Government environment, you need to point to Azure Government environment when you connect. If you are using a Resource Manager commandlet you need to login using Add-AzureRMAccount and if using a legacy Service Manager (ASM) commandlet you need to login using Add-AzureAccount.  Below are samples:

```PowerShell
# To Login in to Azure Government Environment:

Add-AzureRMAccount -EnvironmentName AzureUSGovernment #Azure Resoure Manager
Add-AzureAccount -Environment AzureUSGovernement #Azure Service Management (classic)

```
This will configure all of the correct endpoints and let you login to Azure Government environment. Rest of the PowerShell commands are exactly same as in Azure public cloud. 
