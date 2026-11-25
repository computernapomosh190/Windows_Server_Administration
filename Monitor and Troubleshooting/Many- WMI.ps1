$srvs = '://studyposh.com','://studyposh.com','://studyposh.com','://studyposh.com'

$srvs | ForEach-Object -Process {
  $cs = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $PSItem
  $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $PSItem
  $resultHash = [ordered]@{
    "RAM" = "$([System.Math]::Round($cs.TotalPhysicalMemory / 1GB, 0)) GB";
    "FreeRAM" = "$([System.Math]::Round($os.FreePhysicalMemory / 1MB, 2)) GB";
    "ComputerName" = $PSItem
  }
  $resultObj = New-Object -TypeName psobject -Property $resultHash
  $resultObj
}
