# Варіант 1: через зміну кольору шрифту консолі ($Host.UI.RawUI)
$fg = $Host.UI.RawUI.ForegroundColor
Get-Service | ForEach-Object -Process {
  if ($PSItem.Status -eq 'Stopped') {
    $Host.UI.RawUI.ForegroundColor = "Red"
  } else {
    $Host.UI.RawUI.ForegroundColor = $fg
  }
  $PSItem
} ; (Get-Host).UI.RawUI.ForegroundColor = 'Gray'

# Варіант 2: через цикл foreach та Write-Host із перевіркою критичних помилок
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
