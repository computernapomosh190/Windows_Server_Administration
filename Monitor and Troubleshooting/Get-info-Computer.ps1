Get-WmiObject -ClassName Win32_OperatingSystem | Select-Object -Property csname, @{Name='LastBootUpTime'; Expression={$PSItem.ConvertToDateTime($PSItem.lastbootuptime)}}
