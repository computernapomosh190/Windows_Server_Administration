Get-Service | ForEach-Object -Process {
  if ($PSItem.Status -eq 'Stopped') {
    $Host.UI.RawUI.ForegroundColor = "Red"
  } else {
    $Host.UI.RawUI.ForegroundColor = $fg
  }
  $PSItem
} ; (Get-Host).UI.RawUI.ForegroundColor = 'Gray'
