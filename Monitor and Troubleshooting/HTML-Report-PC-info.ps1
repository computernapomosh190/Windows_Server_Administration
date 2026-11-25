# ==============================================================================
# Скрипт генерації HTML-звіту про конфігурацію комп'ютера
# ==============================================================================

# 1. Властивості для комп'ютерної системи (CIM_ComputerSystem)
$csProperties = @(
    'Name',
    'Domain',
    'Manufacturer',
    'Model',
    'SystemType',
    'NumberOfProcessors',
    'NumberOfLogicalProcessors',
    @{Name = 'TotalPhysicalMemory(GB)'; Expression = {[System.Math]::Round($PSItem.TotalPhysicalMemory / 1GB, 2)}}
)

# 2. Інформація про модулі оперативної пам'яті (Win32_PhysicalMemory)
$pm = Get-CimInstance -ClassName Win32_PhysicalMemory -ComputerName $env:COMPUTERNAME |
Select-Object -Property DeviceLocator,
    Manufacturer,
    @{Name = 'Capacity(GB)'; Expression = {[System.Math]::Round($PSItem.Capacity / 1GB, 2)}},
    Speed,
    PartNumber

# 3. Інформація про операційну систему (Win32_OperatingSystem)
$osRaw = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $env:COMPUTERNAME
$os = $osRaw | Select-Object -Property Caption,
    Version,
    BuildNumber,
    OSArchitecture,
    @{Name = 'ProductType'; Expression = {switch ($PSItem.ProductType) {
        1 { 'Workstation' }
        2 { 'Domain Controller' }
        3 { 'Server' }
        default { 'Other' }
    }}},
    @{Name = 'OSLocale'; Expression = {switch ($PSItem.Locale) {
        '0409' { 'English (United States)' }
        '0422' { 'Ukrainian (Ukraine)' }
        default { 'Other' }
    }}},
    @{Name = 'OSLanguage'; Expression = {switch ($PSItem.OSLanguage) {
        1033 { 'English' }
        1058 { 'Ukrainian' }
        default { 'Other' }
    }}},
    @{Name = 'DateOfInstallation'; Expression = {($PSItem.InstallDate).ToLongDateString()}},
    @{Name = 'TimeOfLastBoot'; Expression = {($PSItem.LastBootUpTime).ToUniversalTime()}},
    @{Name = 'FreeRAM'; Expression = {"$([System.Math]::Round($PSItem.FreePhysicalMemory / 1MB, 2)) GB"}},
    @{Name = 'PageFileSize'; Expression = {"$([System.Math]::Round(($PSItem.TotalVirtualMemorySize - $PSItem.TotalVisibleMemorySize) / 1MB, 2)) GB"}},
    @{Name = 'FreePageFileSize'; Expression = {"$([System.Math]::Round($PSItem.FreeSpaceInPagingFiles / 1MB, 2)) GB"}}

# 4. Інформація про логічні диски (Win32_LogicalDisk)
$ld = Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $env:COMPUTERNAME |
Select-Object -Property @{Name = 'DriveLetter'; Expression = {$PSItem.DeviceID}},
    @{Name = 'VolumeLabel'; Expression = {$PSItem.VolumeName}},
    @{Name = 'DriveType'; Expression = {switch ($PSItem.DriveType) {
        0 { 'Unknown' }
        1 { 'No Root Directory' }
        2 { 'Removable Disk' }
        3 { 'Local Disk' }
        4 { 'Network Drive' }
        5 { 'Compact Disc' }
        6 { 'RAM Disk' }
    }}},
    @{Name = 'FileSystem'; Expression = {$PSItem.FileSystem}},
    @{Name = 'Compressed'; Expression = {$PSItem.Compressed}},
    @{Name = 'Size'; Expression = {"$([System.Math]::Round($PSItem.Size / 1GB, 2)) GB"}},
    @{Name = 'FreeSize'; Expression = {"$([System.Math]::Round($PSItem.FreeSpace / 1GB, 2)) GB"}}

# 5. Формування окремих HTML-фрагментів
$csFragment = Get-CimInstance -ClassName CIM_ComputerSystem -ComputerName $env:COMPUTERNAME |
    Select-Object $csProperties |
    ConvertTo-Html -As List -Property * -Fragment -PreContent "<h2>ComputerSystem Information</h2>"

$pmFragment = $pm | ConvertTo-Html -Property * -Fragment -PreContent "<h2>RAM Information</h2>"

$osFragment = $os | ConvertTo-Html -As List -Property * -Fragment -PreContent "<h2>OperatingSystem Information</h2>"

$ldFragment = $ld | ConvertTo-Html -Property * -Fragment -PreContent "<h2>LogicalDisk Information</h2>"

# 6. Головний заголовок із повним ім'ям хоста (FQDN)
$cn = "<h1>Computer Name: $([System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName)</h1>"

# 7. CSS-стилі для оформлення сторінки
$header = @"
<style>
  h1 {
    font-family: Arial, Helvetica, sans-serif;
    color: #000099;
    font-size: 28px;
  }
  h2 {
    font-family: Arial, Helvetica, sans-serif;
    color: #000099;
    font-size: 20px;
  }
  table {
    font-size: 16px;
    border: 0px;
    font-family: Arial, Helvetica, sans-serif;
  }
  td {
    padding: 4px;
    margin: 0px;
    border: 0;
  }
  th {
    background: #395870;
    background: linear-gradient(#49708f, #293f50);
    color: #fff;
    font-size: 11px;
    text-transform: uppercase;
    padding: 10px 15px;
    vertical-align: middle;
  }
  tbody tr:nth-child(even) {
    background: #f0f0f2;
  }
  #CreationDate {
    font-family: Arial, Helvetica, sans-serif;
    color: #ff3300;
    font-size: 16px;
  }
</style>
"@

# 8. Збірка фінального документа та збереження у файл
$htmlParameters = @{
    'Body'        = "$cn $csFragment $pmFragment $osFragment $ldFragment";
    'Title'       = "Computer Report";
    'Head'        = $header;
    'PostContent' = "<p id='CreationDate'>Creation Date: $(Get-Date)</p>"
}

$reportPath = "C:\Computer-Report.html"
$report = ConvertTo-Html @htmlParameters
$report | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "Звіт успішно збережено у файл: $reportPath" -ForegroundColor Green
