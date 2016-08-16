
# Check Basic Machine Info :-

Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture, BootDevice,  BuildNumber, LocalDateTime| FL

get-host

$PSVersionTable

$PSVersionTable.PSVersion


# Check Environment Path Variable : -

$env:Path

$env:PSModulePath

# To check is Azure PowerShell is already installed 

Get-Module -ListAvailable Azure*

#To install Azure PowerShell on your machine.

Install-Module AzureRM -Verbose



# To check if Azure PowerShell is installed correctly.

Get-Module -ListAvailable Azure*


# To update Azure PowerShell Module

Update-Module AzureRM -Verbose
