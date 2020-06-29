[CmdletBinding()]
param (
    [Parameter(Mandatory, Position=0)]
    [string]
    $zipfile,
    [Parameter(Mandatory, Position=1)]
    [string]
    $outpath
)
Add-Type -AssemblyName System.IO.Compression.FileSystem

try {
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
} catch {
    try
    {
        [System.IO.Compression.ZipArchive]::ExtractToDirectory($zipfile, $outpath)
    }
    catch
    {
        & "$ENV:PDEVTOOLS/extra/bin/unzip.exe" $zipfile $outpath
    }
}