# Load WinSCP .NET assembly
Add-Type -Path "c:\dataload\WinSCP-6.5.5-Automation\netstandard2.0\WinSCPnet.dll"

# Get this from parameters in a future iteration
$local = "c:\dataload\UnitTestPrep\time_code_update.csv"
$remote = "/interfacefiles/time_codes/"

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions 
    $sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
    $sessionOptions.HostName = "s-5034663740944e118.server.transfer.us-east-1.amazonaws.com"
    $sessionOptions.UserName = "stateofsouthdako_tst"
    $sessionOptions.SshHostKeyFingerprint = "ssh-rsa 2048 tuUWOemZHvwXgDhftI5EJ1N42T21Ak7PMtwu2Fj+EhU"
    $sessionOptions.SshPrivateKeyPath = "C:\Users\BrettTaylor\OneDrive - RPI Consultants\Documents\Projects\State of South Dakota\Connecting\stateofsouthdako_tst_winscp.ppk"


$session = New-Object WinSCP.Session

try
{
    # Connect

   $session.Open($sessionOptions)

   $transferOptions = New-Object WinSCP.TransferOptions
   $transferOptions.PreserveTimestamp = $false
   $transferOptions.FilePermissions   = $null

   $transferResult  = $session.PutFiles( $local,$remote, $false,$transferOptions)
   $transferResult.Check()
   Write-Host "Successful Upload"

    # Your code
}
finally
{
    $session.Dispose()
}
