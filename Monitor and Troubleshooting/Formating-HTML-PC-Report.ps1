$htmlParameters = @{
  'Body' = "$cn $csFragment $pmFragment $osFragment $ldFragment";
  'Title' = "Computer Report";
  'Head' = $header;
  'PostContent' = "<p id='CreationDate'>Creation Date: $(Get-Date)<p>"
}
$report = ConvertTo-Html @htmlParameters
$report | Out-File C:\Computer-Report.html
Get-ChildItem
exit
