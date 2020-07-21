[CmdletBinding()]
param
(
    [Parameter(Mandatory, Position = 0)]
    [String]
    $update_target,
    [Parameter(Mandatory = $false, Position = 1)]
    [String]
    $version
)

$Script:portable_vscode_link = "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
$Script:mingw_w64_seh_url = "https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-:::API:::/seh/x86_64-8.1.0-release-:::API:::-seh-rt_v6-rev0.7z"
$Script:PYURL = "https://sourceforge.net/projects/portable-python/files/Portable%20Python%20:::VER:::/Portable%20Python-:::VER:::.:::REAR:::%20x64.exe/download"
$Script:tmp_update_path = "$Env:TMP/tmp_update_dir"

# 有些網站想下載，.NET 用的必須要是新版的TLSv1.2
# 解法來源 https://blog.miniasp.com/post/2019/01/12/PowerShell-Invoke-WebRequest-use-TLS-v12
$Script:NetSP = ([System.Net.ServicePointManager]::SecurityProtocol | Write-Output)
if (($NetSP -notlike "*tls12*") -and ($NetSP -notlike "*tls11*")) { [System.Net.ServicePointManager]::SecurityProtocol = "tls12" }

function Install_VSCode
{
    $target = "VSCode_Program_File"
    $link = $Script:portable_vscode_link

    $tmp_update_path = $Script:tmp_update_path
    $target_file = "$target" + ".zip"

    # 下載新版VSCode
    if (-Not (Test-Path -Path "$tmp_update_path")) { mkdir "$tmp_update_path" | Out-Null }
    try
    {
        Invoke-WebRequest -Uri "$link" -OutFile "$tmp_update_path/$target_file"
    }
    catch
    {
        Write-Host "`nCan't download VSCode`n" -ForegroundColor Red
    }
    # Start-Process -FilePath "wget.exe" -ArgumentList "--convert-links","$link","-O","$tmp_update_path/$target_file" -Wait -NoNewWindow
    Start-Process -FilePath "unzip.exe" -ArgumentList "$tmp_update_path/$target_file", "-d", "$tmp_update_path/$target" -Wait -NoNewWindow

    # 刪除舊版VSCode
    if (Test-Path -Path "$env:PDEVTOOLS/$target")
    {
        Write-Host "`nDeleting old VSCode.....`n" -ForegroundColor Green
        try { Remove-Item -Path $env:PDEVTOOLS/$target -Recurse -Force } catch {  }
    }

    # 移入新版VSCode
    Copy-Item -Path "$tmp_update_path/$target" -Destination "$env:PDEVTOOLS/$target" -Recurse
    if (Test-Path -Path "$tmp_update_path")
    {
        try { Remove-Item -Path "$tmp_update_path" -Recurse -Force } catch {  }
    }
}

function Install_Python([string]$VER)
{
    if ($VER -eq $null)
    {
        Write-Host "`n請指定所要安裝的Python版本`n" -ForegroundColor Red
        return
    }
    $PYVER_without_DOT = $VER.Replace('.', '')
    $target_dir = "Python$($PYVER_without_DOT)"
    $REAR = 9

    # 下載指定版本的最新版 Portable Python
    if ($PYVER_without_DOT -eq "36")
    {
        Write-Host "`n由於Portable Python 3.6 的連結比較不規則`n需要手動下載安裝.....`n真是抱歉.....Orz" -ForegroundColor Red
        return
    }
    if (-Not (Test-Path -Path "$tmp_update_path")) { mkdir "$tmp_update_path" | Out-Null }
    Write-Host "`nDownloading   Portable Python-$($VER) x64......`n" -ForegroundColor Green
    do
    {
        $invalid_link = $false
        $target_file = "Portable Python-$($VER).$($REAR)x64.exe"
        $PYURI = ($PYURL.Replace(":::VER:::", "$VER")).Replace(":::REAR:::", "$REAR")
        try
        {
            Invoke-WebRequest -Uri $PYURI -OutFile "$tmp_update_path/$target_file" -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
        }
        catch
        {
            $REAR -= 1
            $invalid_link = $true
        }
        if ($REAR -lt 0)
        {
            Write-Host "`n目前並沒有 Python $($VER)......Orz`n" -ForegroundColor Red
            return
        }
    } while (($invalid_link -eq $true) -and ($REAR -ge 0))

    $SelfExtractDir = "Portable Python-$($VER).$($REAR) x64"
    # 解壓縮，解壓縮出來會是"Portable Python-x.x.x x64"
    Start-Process -FilePath "$tmp_update_path/$target_file" -ArgumentList "-y", "`"-o$tmp_update_path`"" -Wait

    # 刪除舊版同版本Python
    if (Test-Path -Path "$Env:PYTHONROOT/$target_dir")
    {
        Write-Output "" "Deleting old Python....." ""
        Remove-Item -Path "$Env:PYTHONROOT/$target_dir" -Recurse -Force
    }

    # 移入新版Python
    if (-Not (Test-Path -Path "$Env:PYTHONROOT")) { mkdir -Path "$Env:PYTHONROOT" | Out-Null }
    Copy-Item -Path "$tmp_update_path/$SelfExtractDir/App/Python" -Destination "$Env:PYTHONROOT/$target_dir" -Recurse
    if (Test-Path -Path "$tmp_update_path")
    {
        Remove-Item -Path $tmp_update_path -Recurse -Force
    }

    # 若下載的Python比原先的default_ver新，則更新
    $default_ver_txt = "$Env:PDEVTOOLS/Python/Launcher/default_ver.txt"
    if (Test-Path -Path $default_ver_txt) { $default_ver = [Int](Get-Content -Path $default_ver_txt) }
    else { $default_ver = 0 }
    if ($default_ver -lt $PYVER_without_DOT) { Write-Output "$PYVER_without_DOT" > $default_ver_txt }

    Write-Output "" "The new Python $($VER) has been installed successfully" ""
}

function Install_MinGW([string]$API)
{
    if (("$API" -ne "posix") -and ("$API" -ne "win32"))
    {
        Write-Host "`nOnly accept   'posix' / 'win32'  version for MinGW-W64`n" -ForegroundColor Red
        return
    }
    $target_dir = "mingw64"
    # 下載指定threads版本的最新版 MinGW
    if (-Not (Test-Path -Path "$tmp_update_path")) { mkdir "$tmp_update_path" | Out-Null }
    Write-Output "" "Downloading   $($API) MinGW-W64......" ""

    $target_file = "$($VER)_MinGW_W64.exe"
    $MINGWURI = $Script:mingw_w64_seh_url.Replace(":::API:::", "$API")
    try
    {
        Invoke-WebRequest -Uri "$MINGWURI" -OutFile "$tmp_update_path/$target_file" -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
    }
    catch
    {
        Write-Host "Can't download MinGW-W64" -ForegroundColor Red
        Write-Output "$(Get-Date) | Mingw URL Invalid" >> "$Env:PDEVLOGS"
        Write-Output "$(Get-Date) | URI: $MINGWURI" >> "$Env:PDEVLOGS"
        return
    }

    # 解壓縮，解壓縮出來會是"mingw64"
    7za x "$tmp_update_path/$target_file" "-o$tmp_update_path" -y

    # 刪除舊版MinGW W64
    if (Test-Path -Path "$Env:PDEVTOOLS/$target_dir")
    {
        Write-Output "" "Deleting old MinGW-W64....." ""
        Remove-Item -Path "$Env:PDEVTOOLS/$target_dir" -Recurse -Force
    }

    # 移入新版MinGW W64
    Copy-Item -Path "$tmp_update_path/$target_dir" -Destination "$Env:PDEVTOOLS/$target_dir" -Recurse
    if (Test-Path -Path "$tmp_update_path")
    {
        Remove-Item -Path $tmp_update_path -Recurse -Force
    }

    Write-Output "" "The new $($API) MinGW-W64 has been installed successfully" ""
}

switch ($update_target)
{
    "vscode" { Install_VSCode }
    "python" { Install_Python $version }
    "mingw" { Install_MinGW $version }
    Default
    {
        Write-Output ""`
            "Not valid update target"`
            "Valid update target list:"`
            "                   vscode"`
            "                   python x.x"`
            ""
    }
}