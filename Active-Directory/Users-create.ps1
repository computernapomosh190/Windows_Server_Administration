"Serhii Mapych", "Alan Turing", "Ann Jones" | ForEach-Object -Process {
    $FullNameWithSpace = $PSItem
    $DisplayName = $FullNameWithSpace.Trim() -replace "\s+", " " -split " "
    $FirstName = $DisplayName[0]
    $LastName = $DisplayName[1]
    
    # Формирование логина формата sMapych (первая буква имени + фамилия)
    $SecurityAccountsManager = $FirstName + "." + $LastName
    $SamAccountName = $FirstName.Substring(0, 1) + $LastName
    $UserPrincipalName = $SecurityAccountsManager.ToLower()
    $Domain = "@studyposh.com"
    $UserPrincipalName = $SecurityAccountsManager.ToLower() + $Domain
    
    # Получение путей OU и целевой группы
    $OU = Get-ADOrganizationalUnit -Identity "OU=IT,OU=Departments,DC=studyposh,DC=com"
    $SpecificGroup = Get-ADGroup -Identity "CN=Domain Admins,CN=Users,DC=studyposh,DC=com"
    
    # Хэш-таблица параметров (Splatting)
    $parameters = @{
        'Name'              = "$FirstName $LastName";
        'DisplayName'       = "$FirstName $LastName";
        'AccountPassword'   = (Get-Secret -Vault LocalStore -Name domain_adm_pass).Password;
        'GivenName'         = $FirstName;
        'Surname'           = $LastName;
        'Path'              = $OU.DistinguishedName;
        'SamAccountName'    = $SamAccountName;
        'UserPrincipalName' = $UserPrincipalName;
        'Enabled'           = $true
    }
    
    # Создание пользователя, добавление в группу и вывод отчёта
    New-ADUser @parameters
    Add-ADGroupMember -Identity ($SpecificGroup.SamAccountName) -Members $SamAccountName
    Write-Host "User $FirstName $LastName has been created and added to $($SpecificGroup.Name) group" -ForegroundColor Green
}
