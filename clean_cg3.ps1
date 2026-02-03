$path = "c:/dataload/projectDocs/DBSynch/cl_calcgrp_xml.csv"
$new  = "c:/dataload/projectDocs/DBSynch/cl_allCalcGroups.xml"

#1. Clean up the CSV file that has all the xml for calculation
# groups and then generate a single XML document that can be parsed
$content = Get-Content $path -Raw
# it's a pretty simple pattern. Get rid of opening and closing quotation
# and get rid of the double double quotes

if ($content.Length -gt 1){
    #get rid of the quote at begining of the file
    $content = $content -replace '"<calcgroup' , '<calcgroup'
    $content = $content -replace '""', '"'
    $content = $content -replace '</calcgroup>"' , '</calcgroup>'
    $withHeader ="<SOSD>" + $content + "</SOSD>"
    } 
 #Set-Content $new $content
 Set-Content $new $withHeader