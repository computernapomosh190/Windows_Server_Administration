while ($true) {
  $ComputerCPU = (Get-WmiObject -Class win32_processor -ErrorAction Stop |
    Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average

  $ComputerMemory = Get-WmiObject -Class win32_operatingsystem -ErrorAction Stop
  $UsedMemory = $ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory
  $Memory = (($UsedMemory / $ComputerMemory.TotalVisibleMemorySize) * 100)
  $RoundMemory = [math]::Round($Memory, 2)

  $TotalDisk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | ForEach-Object { [math]::truncate($_.Size / 1GB) }
  $FreeSpace = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | ForEach-Object { [math]::truncate($_.Freespace / 1GB) }

  $Date = Get-Date -DisplayHint Date -Format MM/dd/yyyy
  $Time = Get-Date -DisplayHint Time -Format HH:mm:ss

  "Date: {0} Time: {1} CPU: {2} Memory: {3} FreeSpace (C: drive): {4} GB TotalSize (C: drive): {5} GB" `
    -f $Date, $Time, $ComputerCPU, $RoundMemory, $FreeSpace, $TotalDisk

  Start-Sleep 5
}
