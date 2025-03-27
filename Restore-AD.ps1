#Everett Paretti  
try {
Get-ADOrganizationalUnit -Identity "OU=Finance,DC=consultingfirm,DC=com" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false }
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] 
    {write-host "Finance OU not found, creating Finance OU"}

try {
if (Get-ADOrganizationalUnit -Identity "OU=Finance,DC=consultingfirm,DC=com") 
    {Write-Host "Finance already exists, deleting"} }
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {write-host " "}

try {
Remove-ADOrganizationalUnit -identity "OU=Finance,DC=consultingfirm,DC=com" -confirm:$false }
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {write-host " "}

New-ADOrganizationalUnit -name "Finance"
Write-Host "Finance OU created"

pause
