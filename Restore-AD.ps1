#Everett Paretti  012026065

set-location $PSScriptRoot

try { #beginning of try-catch error handling
Get-ADOrganizationalUnit -Identity "OU=Finance,DC=consultingfirm,DC=com" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false } #Looks for the OU in AD that by the name of Finance. If it is found it sets its attribute to be able to be deleted.
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] #If the OU wasn't found, this catch statement reports the error to the user
    {Write-error "Finance OU not found" #Error message shown to the user
     write-host " "} #adds whitespace to make the window easier to read


try { #beginning of try-catch statement
if (Get-ADOrganizationalUnit -Identity "OU=Finance,DC=consultingfirm,DC=com") #If statement. Looks for the Finance OU
    {Write-Host "Finance already exists, deleting"} } #if the finance OU exists, tell the user that it will be deleted
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] #catch statement for if the Finance OU doesnt exist
    {Write-Error "Finance OU not found" #Show this error to the user if the OU wasn't found
     write-host " "} #add whitespace

try { #beginning of try-catch statement
Remove-ADOrganizationalUnit -identity "OU=Finance,DC=consultingfirm,DC=com" -confirm:$false -Recursive } #Deletes the Finance OU and all of its users. Disables the confirm window.
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] #Catch statement for if the Finance OU doesn't exist
    {Write-Error "Could not delete, no finance OU found" #This shows the user that the script tried to delete the OU but there wasn't a finance OU to delete
     write-host " "} #add whitespace

New-ADOrganizationalUnit -name "Finance" #script that adds a new Finance OU
Write-Host "Finance OU created" #Informs user that the process to create the OU was just run

Write-Host " " #add whitespace

Write-Host "Creating Users, Please Wait" #Informs the user that the script is now creating the users, which will take some time depending on the system

$CSVusers = Import-CSV -path .\financePersonnel.csv #This assigns the variable $CSVusers to the CSV file provided with user information

foreach ($User in $CSVusers) #the foreach loop will iterate through every user in the CSV file provided, taking the data, assigning it to a variable, and then creating the user
{
$firstName= $User.First_Name #this assigns the first name field
$lastName= $User.Last_Name #this assigns the last name field
$displayName= "$firstName $lastName" #this uses the variables to create the display name
$postalCode= $User.PostalCode #assigns zipcode field
$officePhone= $User.OfficePhone #assigns office phone field
$mobilePhone= $User.MobilePhone #assigns cell phone field
$OU = "OU=Finance,DC=consultingfirm,DC=com" #assigns OU field

New-ADUser -Name $displayName -GivenName $firstName -Surname $lastName -DisplayName $displayName -PostalCode $postalCode -OfficePhone $officePhone -MobilePhone $mobilePhone -Path $OU #Command for creating a new user in AD. It gets the data assigned to the variables in the foreach loop and outputs them into this command so that every account can be created individually
}
Write-Host "Users created" #Lets the user know that creating the users was completed

Get-ADUser -Filter * -SearchBase “ou=Finance,dc=consultingfirm,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt #This command was supplied in the instructions. It gets all the users just added to the Finance OU and outputs it into a text file to make sure that the users were all created properly.

pause #this stops the script so that the user can read what happened before terminating the session
