

# Check Basic Machine Info :-

Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture, BootDevice,  BuildNumber, LocalDateTime| FL

# Check Environment Path Variable : -

$env:Path

$env:PSModulePath

# To check is Azure PowerShell is already installed 

Get-Module -ListAvailable Azure*

#To install Azure PowerShell on your machine.

Install-Module AzureRM

# To check if Azure PowerShell is installed correctly.

Get-Module -ListAvailable Azure*