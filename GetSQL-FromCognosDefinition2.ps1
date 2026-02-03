# 1. Setup paths
$inputFile = "C:\Path\To\Your\Source.xml"
$outputFolder = "C:\Path\To\Your\LocalGitRepo\Queries"
$repoPath = "C:\Path\To\Your\LocalGitRepo"

# prepare remote GIT
Start-Service ssh-agent
ssh-add $HOME\.ssh\id_ed25519

# 2. Ensure output directory exists
if (!(Test-Path $outputFolder)) { New-Item -ItemType Directory -Path $outputFolder | Out-Null }

# 3. Load XML and Namespaces
[xml]$xmlDoc = Get-Content -Path $inputFile
$nsUri = $xmlDoc.DocumentElement.NamespaceURI
$nsManager = New-Object System.Xml.XmlNamespaceManager($xmlDoc.NameTable)
$nsManager.AddNamespace("ns", $nsUri)

# 4. Extract and Save Files
$queryNodes = $xmlDoc.SelectNodes("//ns:sqlQuery", $nsManager)
foreach ($query in $queryNodes) {
    $rawFileName = $query.name
    $sqlContent = $query.sqlText
    $safeFileName = ($rawFileName -replace '[\\/:\*\?"<>\|]', '_').Trim()
    $fullPath = Join-Path -Path $outputFolder -ChildPath "$safeFileName.sql"
    
    if ($sqlContent) { $sqlContent | Out-File -FilePath $fullPath -Force }
}

# --- GIT AUTOMATION WITH DYNAMIC MESSAGING ---

Write-Host "`nPreparing Git Commit..." -ForegroundColor Yellow
Push-Location $repoPath

try {
    if (!(Test-Path ".git")) { throw "Not a git repository!" }

    # Stage all changes
    git add .

    # Count the number of staged changes (A = Added, M = Modified, D = Deleted)
    # We filter the porcelain output to get a reliable count
    $changes = git status --porcelain | Measure-Object | Select-Object -ExpandProperty Count

    if ($changes -gt 0) {
        $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        $commitMessage = "[$changes files changed] Automated SQL extraction: $timeStamp"
        
        git commit -m $commitMessage
        git push origin main
        
        Write-Host "Successfully pushed $changes changes to GitHub." -ForegroundColor Green
    } else {
        Write-Host "No changes detected. Skipping commit." -ForegroundColor Gray
    }
}
catch {
    Write-Error "Git operation failed: $_"
}
finally {
    Pop-Location
}