function ConvertTo-UTF8NoBom
{
    process
    {
        $Script:Content = Get-Content -Path "$_" -Raw
        $Script:Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines("$_", $Script:Content, $Script:Utf8NoBomEncoding)
    }
}

