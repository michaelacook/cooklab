Import-Module Active Directory

$CsvPath = Read-Host -Prompt "Enter the full path to the users CSV file"
Write-Host "`n"

$Users = Import-Csv -Path $CsvPath

# Default initial password - not used in production
$Password = ConvertTo-SecureString "Windows1Windows19478!"

foreach ($user in $Users)
{
    New-ADUser -Name $user.name `
     -DisplayName $user.Name `
     -Department $user.Department `
     -Title $user.Title `
     -UserPrincipalName $user.UserPrincipalName `
     -SamAccountName $user.SamAccountName `
     -PasswordNeverExpires $true `
     -ChangePasswordAtLogon $true `
     -AccountPassword $Password `
     -Enabled $true

    $u = Get-ADUser -Identity $user.SamAccountName
    Add-ADGroupMember -Identity $user.Department -Members $u.DistinguishedName
    
    $dept = $user.Department
    Move-ADObject -Identity $u.DistinguishedName -TargetPath "OU=Users,OU=$dept,DC=cooklab,DC=local"
}