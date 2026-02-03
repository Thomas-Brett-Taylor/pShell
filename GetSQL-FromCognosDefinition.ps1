# 1. Define your file paths
$inputFile = "C:\dataload\ProjectDocs\CognosReports\db_schema.xml"
$outputFolder = "C:\dataload\ProjectDocs\SQL\db_schema"

# Create output folder if it doesn't exist
if (!(Test-Path $outputFolder)) { New-Item -ItemType Directory -Path $outputFolder | Out-Null }

# 2. Load the XML content
[xml]$xmlDoc = Get-Content -Path $inputFile

# 3. Handle Namespaces
$nsUri = $xmlDoc.DocumentElement.NamespaceURI
$nsManager = New-Object System.Xml.XmlNamespaceManager($xmlDoc.NameTable)
$nsManager.AddNamespace("ns", $nsUri)

# 4. Find all <sqlQuery> (the parent) tags
$queryNodes = $xmlDoc.SelectNodes("//ns:sqlQuery", $nsManager)

foreach ($query in $queryNodes) {
    # 5. Extract the name for the file and the SQL text for the content
    $rawFileName = $query.name
    $sqlContent = $query.sqlText
    
    # Sanitize the filename (remove characters like \ / : * ? " < > | that are illegal in Windows)
    $safeFileName = $rawFileName -replace '[\\/:\*\?"<>\|]', '_'
    $fullPath = Join-Path -Path $outputFolder -ChildPath "$safeFileName.sql"
    
    if ($sqlContent) {
        $sqlContent | Out-File -FilePath $fullPath
        Write-Host "Exported: $safeFileName.sql" -ForegroundColor Green
    } else {
        Write-Warning "No sqlText found for query: $rawFileName"
    }
}

Write-Host "`nProcessing Complete!" -ForegroundColor Cyan
$xmlDoc | Out-Null
$inputFile | Out-Null