<#
.SYNOPSIS
    WFM Rule Auditor Script - Generates a manifest of rules from a calculation group XML.
#>

param (
    [Parameter(Mandatory=$false, Position=0)]
    [string]$XmlFile
)

# --- Help / Explanation Text ---
$HelpMessage = @"
WFM RULE AUDITOR - SCRIPT EXPLANATION
-------------------------------------
This script parses a WFM Calculation Group XML file to identify all <rule> tags 
at any depth. It extracts the Rule Name, Class, Active Status, and Description.

Output:
- Displays a table in the console.
- Generates a text file named 'manifest<InputFileName>.txt'.

Usage:
    .\findRules.ps1 -XmlFile "yourfile.xml"
    .\findRules.ps1 "yourfile.xml"

Help:
    .\findRules.ps1 -h
    .\findRules.ps1 help
"@

# --- Argument Logic ---
if ([string]::IsNullOrWhiteSpace($XmlFile) -or $XmlFile -eq "-h" -or $XmlFile -eq "help" -or $XmlFile -eq "-help") {
    Write-Host $HelpMessage -ForegroundColor Cyan
    exit
}

# --- File Validation & Output Naming ---
if (-not (Test-Path $XmlFile)) {
    Write-Host "Error: Could not find file '$XmlFile' in the current directory." -ForegroundColor Red
    exit
}

# Derive output name: manifest<filename>.txt
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($XmlFile)
$OutputFile = "manifest$($baseName).txt"

# Clear previous report if it exists
if (Test-Path $OutputFile) { Remove-Item $OutputFile }

# --- Helper to write to both console and file ---
function Log-Message($Message, $Color = "White", $NoNewline = $false) {
    Write-Host $Message -ForegroundColor $Color -NoNewline:$NoNewline
    $Message | Out-File -FilePath $OutputFile -Append
}

# --- Load and Parse ---
Log-Message "Auditing $XmlFile..." "Cyan"
try {
    [xml]$xml = Get-Content -Path $XmlFile -ErrorAction Stop
} catch {
    Write-Host "Error: Failed to parse '$XmlFile' as valid XML." -ForegroundColor Red
    exit
}

# Select all <rule> nodes at any depth in the document
$allRules = $xml.SelectNodes("//rule")

Log-Message "`nFound $($allRules.Count) rule(s) in the file.`n" "Green"

# --- Process and Format Output ---
if ($allRules.Count -gt 0) {
    $results = foreach ($rule in $allRules) {
        # Extract attributes, providing defaults if missing
        [PSCustomObject]@{
            "Rule Name"   = $rule.name
            "Class"       = $rule.class
            "Is Active"   = if ($rule.isActive) { $rule.isActive } else { "true" } # Default to true
            "Description" = if ($rule.description) { $rule.description } else { "(None)" }
        }
    }

    # Generate table string and pipe to both console and file
    $tableOutput = $results | Format-Table -AutoSize | Out-String
    Log-Message $tableOutput
}

# --- Verification for Hidden Content ---
if ($allRules.Count -eq 0) {
    Log-Message "WARNING: No <rule> tags were found via standard XML selection." "Yellow"
    
    # If standard XML fails, check for text blobs that might contain escaped XML
    $allText = Get-Content -Path $XmlFile -Raw
    $regexMatches = [regex]::Matches($allText, '<rule\s+[^>]*name="([^"]+)"')
    
    if ($regexMatches.Count -gt 0) {
        Log-Message "Detected $($regexMatches.Count) rules via Regex that the XML parser missed." "Green"
        Log-Message "This suggests the file contains 'escaped' XML within a text field." "Yellow"
    }
}

Log-Message "`nReport saved to: $OutputFile" "Cyan"
