Import-Csv -Path C:\Users1.csv | Select-Object -ExpandProperty Name | ForEach-Object -Process {
    $FullNameWithSpace = $PSItem
    $DisplayName = $FullNameWithSpace.Trim() -replace "\s+", " " -split " "
    $FirstName = $DisplayName[0]
    $LastName = $DisplayName[1]
    
    $SecurityAccountsManager = $FirstName + "." + $LastName
    $SamAccountName = $FirstName.Substring(0, 1) + $LastName
    $pass = 'Zxcvbn!@#' # default password
    $UserPrincipalName = $SecurityAccountsManager.ToLower()
    $Domain = "@studyposh.com"
    $UserPrincipalName = $SecurityAccountsManager.ToLower() + $Domain
    
    $OU = Get-ADOrganizationalUnit -Identity "OU=Sales-Users,OU=Sales,OU=Departments,DC=studyposh,DC=com"
    $parameters = @{
        'Name'              = "$FirstName $LastName";
        'DisplayName'       = "$FirstName $LastName";
        'AccountPassword'   = (ConvertTo-SecureString $pass -AsPlainText -Force);
        'GivenName'         = $FirstName;
        'Surname'           = $LastName;
        'Path'              = $OU.DistinguishedName;
        'SamAccountName'    = $SamAccountName;
        'UserPrincipalName' = $UserPrincipalName;
        'Enabled'           = $true
    }
    
    New-ADUser @parameters
    Write-Host "`nUser $FirstName $LastName has been created and added to $($OU.Name) OrganizationalUnit" -ForegroundColor 'Green'
}
