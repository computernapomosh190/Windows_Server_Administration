$srvs = '://studyposh.com','://studyposh.com','://studyposh.com','://studyposh.com'

Get-WmiObject -ClassName Win32_OperatingSystem -ComputerName $srvs | Select-Object -Property csname, @{Name='LastBootUpTime'; 
Expression={$PSItem.ConvertToDateTime($PSItem.lastbootuptime)}}
