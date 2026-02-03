$path = "c:/dataload/postCRP/cg_xml.lst"
$new  = "c:/dataload/postCRP/cg_xml_1.lst"
$content = Get-Content $path -Raw
# you'll need to define a regex b/c the file has a trailing newline and some other things...
#but just to be a hack, let's define how much from the end we want to try
#do this to avoid the regex for now
if ($content.Length -gt 1){
    $content = $content.Substring(1, $content.Length -3)
} 
 Set-Content $new $content