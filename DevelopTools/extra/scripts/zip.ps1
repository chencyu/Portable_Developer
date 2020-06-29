[CmdletBinding()]
param (
    [Parameter(Mandatory, Position=0)]
    [string]
    $src_path,
    [Parameter(Mandatory, Position=1)]
    [string]
    $zipfile
)
Add-Type -AssemblyName System.IO.Compression.FileSystem

try
{
    [System.IO.Compression.ZipFile]::CreateFromDirectory($src_path, $zipfile)
}
catch
{
    & "$ENV:PDEVTOOLS/extra/bin/zip.exe" $src_path $zipfile
}
