$location = Get-Location
$files = Get-ChildItem  $location -Force -name -file  -exclude *.ps1, *.exe
$regions = $(foreach($file in $files) 
    {
        if($file -like '*(*)*' ) 
            { 
            $start=$file.indexof("(")
            $end=$file.indexof(")")
            $length = $end - $start +1
            $file.substring($start,$length)
            }
    })| Sort-Object | Get-Unique

foreach($region in $regions)
{
   if (-not ($region -Match '[0-9]|\['))
    {
        New-Item -Path "$location\export\$region" -ItemType Directory
    }
}

foreach($file in $files)
{
    $region = 
        if($file -like '*(*)*' ) 
            { 
            $start=$file.indexof("(")
            $end=$file.indexof(")")
            $length = $end - $start +1
            $file.substring($start,$length)
            }
    
    Move-Item -LiteralPath $location\$file -Destination $location\export\$region\$file
}

foreach($region in $regions)
{
$location2 = "$location\export\$region" 
$files = Get-ChildItem   -LiteralPath $location2 -Force -name -file  -exclude *.ps1, *.exe
$dirnames = $(foreach($file in $files){$file.Substring(0,1).toupper()})| Sort-Object | Get-Unique

foreach($dir in $dirnames)
{
   if (-not (Test-Path -LiteralPath $location2\#) -And ($dir -Match '[0-9]|\[')) 
        {New-Item -Path "$location2\#" -ItemType Directory}
    Elseif (-not ($dir -Match '[0-9]|\['))
    {
        New-Item -Path "$location2\$dir" -ItemType Directory
    }
}

foreach($file in $files)
{
    $direct = $file.Substring(0,1).toupper()
    if($direct -Match '[0-9]|\[') {$direct = '#'}
    Move-Item -LiteralPath $location2\$file -Destination $location2\$direct\$file
}

}
