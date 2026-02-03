# Define connection parameters
$server = "localhost"
$port = 5432
$database = "postgres"
$user = "wfm_client"
$pass = "wfm_client"

# Construct the DSN-less connection string
$connString = "Driver={PostgreSQL Unicode(x64)};Server=$server;Port=$port;Database=$database;Uid=$user;Pwd=$pass;"

# Create and open the connection (similar to Option 1)
$conn = New-Object System.Data.Odbc.OdbcConnection
$conn.ConnectionString = $connString

try {
    $conn.Open()
    Write-Host "Connection to PostgreSQL successful!" -ForegroundColor Green

    # Example query
    $query = "SELECT employee, name_given_name FROM ghr_employee LIMIT 5;"
    $command = New-Object System.Data.Odbc.OdbcCommand($query, $conn)
    $reader = $command.ExecuteReader()

    # Process results (e.g., load into a DataTable for easier handling)
    $dataTable = New-Object System.Data.DataTable
    $dataTable.Load($reader)
    $dataTable | Format-Table

} catch {
    Write-Host "Connection failed: $_.Exception.Message" -ForegroundColor Red
} finally {
    if ($conn.State -eq 'Open') {
        $conn.Close()
        Write-Host "Connection closed."
    }
}
