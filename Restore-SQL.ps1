#Everett Paretti 012026065

$database = "ClientDB" #this assigns the variable $database to ClientDB. If the script needed to be changed to look for another database you would only need to change the name here

try { #beginning of try-catch error handling statement
$SQLdatabase = SqlServer\Get-SqlDatabase -ServerInstance SRV19-PRIMARY\SQLEXPRESS | Where-Object { $_.Name -eq $database } #this defines S$QLdatabase. tells powershell to access the SQL database at SRV-19-PRIMARY/SQLEXPRESS. It is verified with Windows Auth. This is then piped to Where-Object which compares all names to the variable set as $database

if ($SQLdatabase) #beginning of if else statement. If the database exists-
{
Write-Output "Found database: $($SQLdatabase.Name)" #Writes to the console that there was a name match on the server to the database being looked for
} else { #if the IF part of the statement didn't trigger, that there was no database name match
    Write-Output "Database '$database' not found." #Write to the console that the database that the user is searching for wasn't found on the SQL server
    }
    } #end of the 'try' portion of the try-catch statement. if an error happened the catch line would activate and send output
catch [Microsoft.SqlServer.Management.PowerShell.IaaS.GetSqlDatabaseCommand] #Looking for an error in GetSQLDatabase
    {Write-error "Database ClientDB Not Found" #If an error happened this will be sent to the console
     write-host " "} #This adds white space to the window to make the output more readable





pause
