# Define the folders you want to search
$IncludeList = @("bin", "Documents", "IdeaProjects")

Get-ChildItem -Path "C:\Users\BrettTaylor" -Directory -Force -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -in $IncludeList } | 
    Get-ChildItem -Filter ".git" -Recurse -Directory -Force -ErrorAction SilentlyContinue | 
    Select-Object -ExpandProperty FullName | 
    Tee-Object -FilePath "$HOME\GitRepoList.txt"