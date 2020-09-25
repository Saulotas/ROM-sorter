$location = Get-Location
$files = Get-ChildItem -LiteralPath $location -Force -name -file -exclude *.ps1, *.exe

$dirnames = $(foreach($file in $files){$file.Substring(0,1).toupper()})| Sort-Object | Get-Unique
#Write-Output ($dirnames)
foreach($dir in $dirnames)
{
if (-not (Test-Path -LiteralPath $dir)) {

if($dir -Match '[0-9]|\[') {$dir = '#'}
New-Item -Path "$location\export\$dir" -ItemType Directory

}
}

foreach($file in $files)
{
$direct = $file.Substring(0,1).toupper()
if($direct -Match '[0-9]|\[') {$direct = '#'}
Move-Item -LiteralPath $location\$file -Destination $location\export\$direct\$file
}

