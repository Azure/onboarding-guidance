

[How to enable metrics using PowerShell - Standard Storage Account ](https://azure.microsoft.com/en-us/documentation/articles/storage-enable-and-view-metrics/#how-to-enable-metrics-using-powershell)

#### How to enable metrics using PowerShell
```PowerShell
Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName | Get-AzureStorageServiceMetricsProperty -MetricsType Hour -ServiceType Blob

Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName | Get-AzureStorageServiceMetricsProperty -MetricsType Minute -ServiceType Blob
```
####  The following command switches on minute metrics for the Blob service in your default storage account with the retention period set to five days:
```PowerShell
Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName | Set-AzureStorageServiceMetricsProperty -MetricsType Minute -ServiceType Blob -MetricsLevel ServiceAndApi -RetentionDays 5

Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName | Set-AzureStorageServiceMetricsProperty -MetricsType Hour -ServiceType Blob -MetricsLevel ServiceAndApi -RetentionDays 5
```

####  How to enable Logging using PowerShell
```PowerShell
Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName | Get-AzureStorageServiceLoggingProperty -ServiceType Blob

Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName | Set-AzureStorageServiceLoggingProperty -ServiceType Blob -LoggingOperations Read,Write -RetentionDays 10
```
