# 初始化

# 預設編碼為UTF-8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
mode con cp select=65001 | Out-Null
if ($Alias:wget)
{
    Remove-Item Alias:wget
}

# 導入PDEV環境變數
Set-Item -Path Env:Path -Value ($Env:PDEV_PATH + $Env:Path)
$obj_path = & linked_pwd retrpath
if ($null -ne $obj_path) { Set-Location -Path $obj_path }

# Run script when leaving PDEV
$Host.UI.RawUI.ForegroundColor = "Black"
$Host.UI.RawUI.BackgroundColor = "Black"
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { &"$PSCommandRoot/ExitProfile.ps1" }

$Env:PreferPS1 = $false # 根據PowerShell版本決定是否偏好使用PS1腳本而非.exe執行檔
if (5 -le [Int]$psversiontable.psversion.major) { $Env:PreferPS1 = $true }

Set-Alias -Name "make" -Value "mingw32-make"

# 載入額外模組
$Script:Modules_Path = "$Env:PDEVTOOLS/extra/scripts/PDev_PShell_Modules".Replace("\", "/")
Import-Module -Name "$($Script:Modules_Path)/UTF8NoBom.psm1" -Global

# 改成我偏好的 Prompt
function global:prompt
{
    Write-Host ("PDev " + $(Get-Location) + "`n>") -NoNewLine
    return " "
}

# 改成我喜歡的顏色
$Host.UI.RawUI.ForegroundColor = "Gray"
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host


# PDev Message
Write-Output `
    ">>>>>          Portable Developer          <<<<<"`
    ">>>>>               ver_1.0                <<<<<"`

# 未來可能作為選項使用
# Get-Content $env:pdevhome\ReadMe.txt


# 切換到連結後的當前目錄，要在最後執行
# linked_pwd
