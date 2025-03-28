#Everett Paretti  012026065

set-location $PSScriptRoot

try {
Get-ADOrganizationalUnit -Identity "OU=Finance,DC=consultingfirm,DC=com" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false }
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {Write-error "Finance OU not found"
     write-host " "}


try {
if (Get-ADOrganizationalUnit -Identity "OU=Finance,DC=consultingfirm,DC=com")
    {Write-Host "Finance already exists, deleting"} }
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {Write-Error "Finance OU not found"
     write-host " "}

try {
Remove-ADOrganizationalUnit -identity "OU=Finance,DC=consultingfirm,DC=com" -confirm:$false -Recursive }
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {Write-Error "Could not delete, no finance OU found"
     write-host " "}

New-ADOrganizationalUnit -name "Finance"
Write-Host "Finance OU created"

Write-Host " "

Write-Host "Creating Users"

$CSVusers = Import-CSV -path .\financePersonnel.csv

foreach ($User in $CSVusers)
{
$firstName= $User.First_Name
$lastName= $User.Last_Name
$displayName= "$firstName $lastName"
$postalCode= $User.PostalCode
$officePhone= $User.OfficePhone
$mobilePhone= $User.MobilePhone
$OU = "OU=Finance,DC=consultingfirm,DC=com"

New-ADUser -Name $displayName -GivenName $firstName -Surname $lastName -DisplayName $displayName -PostalCode $postalCode -OfficePhone $officePhone -MobilePhone $mobilePhone -Path $OU 

Get-ADUser -Filter * -SearchBase “ou=Finance,dc=consultingfirm,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt

}
Write-Host "Users created"
pause
