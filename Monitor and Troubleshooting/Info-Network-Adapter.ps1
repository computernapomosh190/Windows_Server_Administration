$srvs = '://studyposh.com','://studyposh.com','://studyposh.com','://studyposh.com'

foreach ($computer in $srvs) {
  $adapter = Invoke-Command -ScriptBlock {Get-NetAdapter} -ComputerName $computer
  $ipConfig = Invoke-Command -ScriptBlock {Get-NetIPConfiguration} -ComputerName $computer
  $stat = Invoke-Command -ScriptBlock {Get-NetAdapterStatistics} -ComputerName $computer
  $adapterArray = @()
  $adapterHash = [ordered]@{
    'ComputerName' = $computer;
    'NICName' = $adapter.Name;
    'NICIndex' = $adapter.ifIndex;
    'Status' = $adapter.Status;
    'NICSpeed' = $adapter.LinkSpeed;
    'MACAddress' = $adapter.MacAddress;
    'IPAddress' = $($ipConfig | Select-Object -ExpandProperty IPv4Address);
    'Statistic: Sent' = "$([System.Math]::Round($stat.SentBytes / 1MB, 2)) MB";
    'Statistic: Received' = "$([System.Math]::Round($stat.ReceivedBytes / 1MB, 2)) MB";
  }
  $adapterObj = New-Object -TypeName psobject -Property $adapterHash
  $adapterArray += $adapterObj
  $adapterArray
}
