Import-Module -Name ImportExcel

$filePath = "C:\dataload\UnitTestPrep\reload_emp_def_labor.xlsx"
$outputFile = "C:\dataload\UnitTestPrep\reload_emp_def_labor.csv"
$WorksheetName = "emp_def_labor_3"

Import-Excel -Path $filePath -WorksheetName $WorksheetName  | 
     Export-Csv -Path $outputFile -NoHeader
