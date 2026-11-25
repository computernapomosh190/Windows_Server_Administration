# Command below will combine all information into a single HTML report
$htmlParameters = @{
    'Body' = "$cn $csFragment $pmFragment $osFragment $ldFragment";
    'Title' = "Computer Report";
    'Head' = $header;
    'PostContent' = "<p id='CreationDate'>Creation Date: $(Get-Date)<p>"
}
$report = ConvertTo-Html @htmlParameters
#The command below will generate the report to an HTML file
$report | Out-File C:\Computer-Report.html
Get-ChildItem
