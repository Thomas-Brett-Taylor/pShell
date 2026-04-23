###################################################################
#navigational shortcuts

###################################################################

#just get directories lsd
function Get-Directories {Get-ChildItem -Directory}
Set-Alias lsd Get-Directories


#get all files so you can see hidden things lsf
function Get-AllFiles {Get-ChildItem -Force}
Set-Alias lsf  Get-AllFiles

#get all files sorted by extension
function Get-FilesByExtension { Get-ChildItem | Sort-Object -Property Extension}
Set-Alias lsx Get-FilesByExtension


#get all files sorted by date       lst
function Get-FilesByDate { 	Get-ChildItem | Sort-Object LastWriteTime}
Set-Alias lst  Get-FilesByDate


#shortcut to get to one drive without a lot of typing
function Set-Location-OneDrive {
	$onedrive = Get-ChildItem env:OneDrive
	Set-Location $onedrive.value
	Get-Location
}
Set-Alias one Set-Location-OneDrive

###################################################################
#commonly called powershell tools that have been built
###################################################################

#parser to generate a manifest file from a given xml copy of a calculation group
function Run-ManifestGenerator { & "C:\Users\BrettTaylor\bin\pShell\GenerateRuleManifest.ps1" @args}
Set-Alias gen-manifest Run-ManifestGenerator

###################################################################
#functions to mimic bash shell
###################################################################

function touch {
    param([string]$file)
    if (Test-Path $file) {
        # Update the timestamp if the file exists.
        (Get-Item -LiteralPath $file).LastWriteTime = Get-Date
    }
    else {
        # Create a new file if it doesn't exist.
        New-Item -Path $file -ItemType File
    }
}

###################################################################
#jazz up the prompt, a result of 30 second gemini ask
###################################################################

function prompt {
    #$user = (whoami).Split('\')[-1]
    #$hostname = hostname
    $curdir = (Get-Location).Path
    
    # Shorten the path if it's the home directory
    if ($curdir -eq $HOME) {
        $curdir = '~'
    } else {
        # Optional: display only the last folder name
        $curdir = $curdir.Split('\')[-1] 
    }

    Write-Host "$((Get-History).Count) " -NoNewline # Display command history ID
    Write-Host "$((Get-Date).ToShortTimeString()) " -ForegroundColor Yellow -NoNewline # Time in Yellow
    # Write-Host "$($user)@$($hostname) " -ForegroundColor Green -NoNewLine # User and Host in Green
    Write-Host "$($curdir) `:" -ForegroundColor Blue -NoNewLine # Current Path in Blue
    return ' ' # The actual prompt character/space
}

###################################################################
# using gemini again to build a function and alias to keep the git-hub
# rolling strong
###################################################################

function Sync-Git {
    param([string]$Message)
    
    Write-Host "📥 Checking for remote updates..." -ForegroundColor Cyan
    # 1. Pull first to avoid 'behind remote' errors
    git pull --rebase
    
    # 2. Stage everything
    git add -A
    
    # 3. Check if there's actually anything to commit
    $status = git status --porcelain
    if ($null -eq $status) {
        Write-Host "✅ No local changes to sync. You're all caught up!" -ForegroundColor Green
        return
    }

    # 4. Show the user what is staged
    Write-Host "`n--- Files to be Pushed ---" -ForegroundColor Yellow
    git status --short
    Write-Host "--------------------------" -ForegroundColor Yellow

    # 5. Get the commit message
    if (-not $Message) {
        $Message = Read-Host "Enter commit message (or Enter for 'Quick sync')"
        if (-not $Message) { $Message = "Quick sync" }
    }

    # 6. Final Push
    git commit -m $Message
    git push
    Write-Host "`n🚀 Success! Your local and remote are perfectly synced." -ForegroundColor Green
}

Set-Alias gs Sync-Git

#adding a comment to prove that file is managed and in source control



###################################################################
# environment variables that are only good during this session
###################################################################
$env:PGUSER = "wfm_client"
$env:PGPASSWORD = "wfm_client"
$env:PGDATABASE = "postgres"