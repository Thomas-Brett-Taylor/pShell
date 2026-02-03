#https://rpiteam.sharepoint.com/sites/StateofSouthDakota/Shared%20Documents/Forms/AllItems.aspx?FolderCTID=0x012000522B3DD8BE095441A5B27A00BA3F591E&id=%2Fsites%2FStateofSouthDakota%2FShared%20Documents%2FGeneral%2FWave%202%2F03%20%2D%20Build%20%26%20Develop%2FWFM%2FConfiguration
# Define Variables
$SiteURL = "https://rpiteam.sharepoint.com"
$LocalFilePath = "C:\dataload\ProjectDocs\Configuration\ConfigWorkbook.xlsx"
$TargetFolder = "/sites/StateofSouthDakota/Shared Documents/General/Wave 2/03 - Build & Develop/WFM/Configuration" # 'General' is the channel name
<#$urlFolder = "/sites/StateofSouthDakota/Shared%20Documents/Forms/AllItems.aspx?FolderCTID=0x012000522B3DD8BE095441A5B27A00BA3F591E&id=%2Fsites%2FStateofSouthDakota%2FShared%20Documents%2FGeneral%2FWave%202%2F03%20%2D%20Build%20%26%20Develop%2FWFM%2FConfiguration"
$quotedFolder = [System.Net.WebUtility]::UrlDecode($urlFolder)
$quotedFolder
#>
# Connect and Upload
Connect-PnPOnline -Url $SiteURL -Interactive
Add-PnPFile -Path $LocalFilePath -Folder $TargetFolder
