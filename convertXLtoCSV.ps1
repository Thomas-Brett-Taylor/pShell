$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false

$wb = $excel.Workbooks.Open("C:\dataload\postCRP\dbCompare\allMaintFormsAndFields.xlsx")

$filesToDelete = New-Object System.Collections.ArrayList

foreach ($sheet in $wb.Worksheets) {
    $sheet.Activate()
    $csv = "C:\dataload\postCRP\dbCompare\file_$($sheet.Name).csv"
    $cln = "C:\dataload\postCRP\dbCompare\clean_$($sheet.Name).csv"
    $wb.SaveAs($csv, 6)
    #use native capability of Powershell to add comma separated values in the output
    Import-CSV $csv | Export-CSV $cln
    $filesToDelete.Add($csv)
}

$wb.Close($false)
$excel.Quit()
ForEach($file in $filesToDelete){Remove-Item($file)}
