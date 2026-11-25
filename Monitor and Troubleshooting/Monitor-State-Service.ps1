$services = Get-Service | Sort-Object -Property Status

foreach ($service in $services) {
  $serviceStatus = $service.Status;
  $serviceDisplayName = $service.DisplayName;
  if ($serviceStatus -eq 'Running') {
    Write-Host "Service OK - Status of $serviceDisplayName is $serviceStatus" -ForegroundColor 'Green'
  } else {
    Write-Host "Check Service - Status of $serviceDisplayName is $serviceStatus" -ForegroundColor 'Yellow'
  }
  if ($service.Status -eq 'Stopped' -and $service.StartType -eq 'Automatic') {
    Write-Host "Service Error - $($service.DisplayName)" -ForegroundColor 'Red'
  } else {}
}
