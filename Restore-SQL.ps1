#Everett Paretti 012026065

$database = "ClientDB"

try {
$SQLdatabase = SqlServer\Get-SqlDatabase -ServerInstance SRV19-PRIMARY\SQLEXPRESS | Where-Object { $_.Name -eq $database }

if ($SQLdatabase) 
{
Write-Output "Found database: $($SQLdatabase.Name)"
} else {
    Write-Output "Database '$database' not found."
    }
    }
catch [Microsoft.SqlServer.Management.PowerShell.IaaS.GetSqlDatabaseCommand]
    {Write-error "Database ClientDB Not Found"
     write-host " "}





pause
