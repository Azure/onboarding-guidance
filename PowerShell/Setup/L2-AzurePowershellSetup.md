# Azure PowerShell Setup

# Abstract

During this module, you will be installing PowerShell on to your machine.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Install Azure PowerShell from the PowerShell Gallery (ARM)
* Install the Azure Resource Manager modules from the PowerShell Gallery
* Check if Azure PowerShell is installed correctly

# Prerequisite 
None

# Estimated time to complete this module:
Self-guided

# What is PowerShell?
PowerShell is a powerful scripting tool that can greatly expedite your admin tasks. PowerShell combines command-line speed, the flexibility of scripting, and the power of a GUI-based admin tool.

Azure PowerShell is a set of modules that provide cmdlets to manage Azure with Windows PowerShell. You can use the cmdlets to create, test, deploy, and manage solutions and services delivered through the Azure platform. In most cases, the cmdlets can be used for the same tasks as the Azure Management Portal, such as creating and configuring cloud services, virtual machines, virtual networks, and web apps. The cmdlets need your subscription so they can manage your services. Use your email address and password associated with your account. Azure authenticates and saves the credential information.

# Why do I want to use PowerShell?
Today, using PowerShell, it is possible to accomplish nearly everything from the command line that is possible in the Azure Portal. In fact, many tasks can only be performed using PowerShell, and some tasks can be managed more granularly using PowerShell. To provide the same support for working with Azure, PowerShell is also available to configure and manage many aspects of Microsoft Azure, including virtual machine and storage provisioning, and network configuration.

# How to install and configure Azure PowerShell:-

-------------------

First Time installation  
WebPI installer : [Download](https://www.microsoft.com/web/handlers/webpi.ashx/getinstaller/WindowsAzurePowershellGet.3f.3f.3fnew.appids/)

Command Line : PowerShell Gallery

Note :  
* The WebPI installer will install the Azure modules in %ProgramFiles(x86)%\Microsoft SDKs\Azure\PowerShell.  
* PowerShell Gallery modules will normally install in %ProgramFiles%\WindowsPowerShell\Modules. 


### Install Azure PowerShell from the PowerShell Gallery using an elevated ((Run as Administrator) Windows PowerShell or PowerShell Integrated Scripting Environment (ISE) prompt using the following commands:

```PowerShell
# Check Basic Machine Info :-

Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture, BootDevice,  BuildNumber, LocalDateTime| FL

Caption                 : Microsoft Windows 10 Pro
InstallDate             : 4/4/2016 4:08:53 PM
ServicePackMajorVersion : 0
OSArchitecture          : 64-bit
BootDevice              : \Device\HarddiskVolume1
BuildNumber             : 10586
LocalDateTime           : 6/20/2016 3:26:53 PM

```



```PowerShell
# Check Environment Path Variable : -

$env:Path
C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\

$env:PSModulePath
C:\Users\test\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\Windows\system32\WindowsPowerShell\v1.0\Modules
```

To check is Azure PowerShell is already installed

```PowerShell
 C:\Windows\system32> Get-Module -ListAvailable Azure*
```

### Installing Azure PowerShell from the PowerShell Gallery (ARM)



```PowerShell
# Install the Azure Resource Manager modules from the PowerShell Gallery

PS C:\Windows\system32> Install-Module AzureRM -Verbose

NuGet provider is required to continue
PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based repositories. The NuGet provider must be available in 'C:\Program
Files\PackageManagement\ProviderAssemblies' or 'C:\Users\aanan\AppData\Local\PackageManagement\ProviderAssemblies'. You can also install the NuGet provider by running 'Install-PackageProvider
 -Name NuGet -MinimumVersion 2.8.5.201 -Force'. Do you want PowerShellGet to install and import the NuGet provider now?
[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y

Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to
 install the modules from 'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): A
PS C:\Windows\system32>

```
Note : If an error occurs during install, you can manually remove the Azure* folders in your %ProgramFiles%\WindowsPowerShell\Modules folder, and try the installation again.

### For Microsoft Windows Server 2012 R2 (You can skip this section if you are not using Windows Server )
```PowerShell
Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture, BootDevice,  BuildNumber, LocalDateTime| FL


Caption                 : Microsoft Windows Server 2012 R2 Datacenter
InstallDate             : 7/12/2016 12:37:03 PM
ServicePackMajorVersion : 0
OSArchitecture          : 64-bit
BootDevice              : \Device\HarddiskVolume2
BuildNumber             : 9600
LocalDateTime           : 7/14/2016 3:24:32 PM
```
Install-Module AzureRM will fail as  Note: Installing Azure PowerShell using PowerShellGet requires Windows Management Framework 5.0 (Windows 10 includes this by default).
```PowerShell
Error message :

Install-Module : The term 'Install-Module' is not recognized as the name of a cmdlet, function, script file, or
operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try
again.
At line:1 char:1
+ Install-Module AzureRM
+ ~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (Install-Module:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
```

#### Package Management Preview for PowerShell 4 & 3 is now available and this preview will enable you to easily discover and install modules from PowerShell Gallery as well as publish your modules to PowerShell Gallery.
[Package Management Preview for PowerShell 4 & 3 is now available](https://blogs.msdn.microsoft.com/powershell/2015/10/09/package-management-preview-for-powershell-4-3-is-now-available/)  : [Download Link](https://www.microsoft.com/en-us/download/confirmation.aspx?id=49186)

#### Installation of Azure ARM PowerShell Module in progress.

To check if Azure PowerShell is installed correctly.

In Windows Explorer
```PowerShell
C:\Program Files\WindowsPowerShell\Modules
```
In PowerShell

```PowerShell

PS C:\Windows\system32> Get-Module -ListAvailable Azure*


    Directory: C:\Program Files\WindowsPowerShell\Modules


ModuleType Version Name
---------- ------- ----
  Manifest 2.0.1   Azure.Storage
    Script 2.0.1   AzureRM
  Manifest 2.0.1   AzureRM.ApiManagement
  Manifest 2.0.1   AzureRM.Automation
  Manifest 2.0.1   AzureRM.Backup
  Manifest 2.0.1   AzureRM.Batch
  Manifest 2.0.1   AzureRM.Cdn
  Manifest 0.2.1   AzureRM.CognitiveServices
  Manifest 2.0.1   AzureRM.Compute
  Manifest 2.0.1   AzureRM.DataFactories
  Manifest 2.0.1   AzureRM.DataLakeAnalytics
  Manifest 2.0.1   AzureRM.DataLakeStore
  Manifest 2.0.1   AzureRM.DevTestLabs
  Manifest 2.0.1   AzureRM.Dns
  Manifest 2.0.1   AzureRM.HDInsight
  Manifest 2.0.1   AzureRM.Insights
  Manifest 2.0.1   AzureRM.KeyVault
  Manifest 2.0.1   AzureRM.LogicApp
  Manifest 0.9.4   AzureRM.MachineLearning
  Manifest 0.1.1   AzureRM.Media
  Manifest 2.0.1   AzureRM.Network
  Manifest 2.0.1   AzureRM.NotificationHubs
  Manifest 2.0.1   AzureRM.OperationalInsights
  Manifest 2.0.1   AzureRM.PowerBIEmbedded
  Manifest 2.0.1   AzureRM.profile
  Manifest 2.0.1   AzureRM.RecoveryServices
  Manifest 2.0.1   AzureRM.RecoveryServices.Backup
  Manifest 2.0.1   AzureRM.RedisCache
  Manifest 3.0.1   AzureRM.Resources
  Manifest 0.9.1   AzureRM.Scheduler
  Manifest 2.0.1   AzureRM.ServerManagement
  Manifest 2.0.1   AzureRM.SiteRecovery
  Manifest 2.0.1   AzureRM.Sql
  Manifest 2.0.1   AzureRM.Storage
  Manifest 2.0.1   AzureRM.StreamAnalytics
  Manifest 2.0.1   AzureRM.Tags
  Manifest 2.0.1   AzureRM.TrafficManager
  Manifest 2.0.1   AzureRM.UsageAggregates
  Manifest 2.0.1   AzureRM.Websites

```

#### Tips
* Installed AzureRM version is same as Azure PowerShell version.(In this case : 2.0.1)
* To check latest Released PowerShell Command : [Click Here](https://github.com/Azure/azure-powershell/blob/dev/ChangeLog.md)


# See the following resources to learn more
* [How to install and configure Azure PowerShell](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/)
