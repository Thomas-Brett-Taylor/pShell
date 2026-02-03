Import-Module -Name ImportExcel

$filePath = "C:\dataload\postCRP\ATG-SIT Values - 01 Project Conversion Template Simplified.xlsx"
$WorksheetName = "TASKS"

$data = Import-Excel -Path $filePath -WorksheetName $WorksheetName 
$data.'Payroll Eligible'
