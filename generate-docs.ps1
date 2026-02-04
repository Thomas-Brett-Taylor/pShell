<#
.SYNOPSIS
    Generates Groovy documentation using AntBuilder with project defaults.
.EXAMPLE
    generate-docs.ps1
    (Runs with hardcoded SOSD defaults)
.EXAMPLE
    generate-docs.ps1 "C:\OtherProject\src" "C:\OtherProject\docs"
    (Overrides defaults with custom paths)
#>
param (
    [Parameter(Position=0)]
    [string]$SourcePath = "C:\Users\BrettTaylor\IdeaProjects\SOSD-Rules\src\SOSD",

    [Parameter(Position=1)]
    [string]$OutputPath = "C:\Users\BrettTaylor\IdeaProjects\SOSD-Rules\doc-output"
)

$java17 = "C:\Users\BrettTaylor\Java17\bin\java.exe"
$libPath = "C:\Users\BrettTaylor\Groovy\lib"

# 1. Verification
if (!(Test-Path $java17)) {
    Write-Error "Java 17 not found at $java17. Documentation cannot be generated."
    exit 1
}

if (!(Test-Path $SourcePath)) {
    Write-Error "Source path not found: $SourcePath"
    exit 1
}

# 2. Preparation
$cp = (Get-ChildItem "$libPath\*.jar" | Select-Object -ExpandProperty FullName) -join ";"

if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

$escapedSource = $SourcePath.Replace('\', '/')
$escapedOutput = $OutputPath.Replace('\', '/')

# 3. Execution
$antScript = @"
import groovy.ant.AntBuilder
def ant = new AntBuilder()
ant.taskdef(name:'gd', classname:'org.codehaus.groovy.ant.Groovydoc')
ant.gd(
    destdir: '$escapedOutput', 
    sourcepath: '$escapedSource', 
    packagenames: '**.*', 
    use: 'true',
    windowtitle: 'SOSD Rules API'
)
"@

Write-Host "🏗️  Generating SOSD Documentation..." -ForegroundColor Cyan
Write-Host "   Source: $SourcePath" -ForegroundColor Gray
Write-Host "   Output: $OutputPath" -ForegroundColor Gray

& $java17 -cp $cp groovy.lang.GroovyShell -e $antScript

# 4. Final Result
if ($LASTEXITCODE -eq 0) {
    Write-Host "✨ Success! Documentation is up to date." -ForegroundColor Green
    # Optional: Uncomment the line below to auto-open the docs after every run
    # Start-Process "$OutputPath\index.html"
}