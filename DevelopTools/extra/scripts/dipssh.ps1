[CmdletBinding()]
param (
    [Parameter(Position=0)]
    [switch]
    $UpdateNow
)


$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

$Script:updateip=$args[0]

if (-Not $UpdateNow)
{
    $Script:CIP_ID              = Read-Host -Prompt "請提供存放Server當前IP的Google雲端檔案的ID"
    $Script:MyUserName          = Read-Host -Prompt "請提供登入伺服器時用的使用者名稱"
    $Script:ServerName          = Read-Host -Prompt "請提供伺服器名稱(自己取名)，不能有空格"
    $Script:ServerPort          = Read-Host -Prompt "請提供伺服器在SSH服務提供的端口"
    $Script:IdentityFile_path   = Read-Host -Prompt "請自行取得私鑰後，提供私鑰存放路徑，無私鑰請直接 Enter忽略"
    $Script:IdentityFile_path   = "$Script:IdentityFile_path".Replace("\","/")

    $Script:ServerSettingFile   = "$($HOME)/.ssh/Dynamic_IP_Server_setting/$($Script:ServerName)"
    if(-Not (Test-Path -Path $Script:ServerSettingFile)) { New-Item -ItemType File -Force -Path $Script:ServerSettingFile }

    $Script:ServerSettingTable  =`
    @{
        IPID = "$($Script:CIP_ID)";
        User = "$($Script:MyUserName)";
        Name = "$($Script:ServerName)";
        Port = "$($Script:ServerPort)";
        Iden = "$($Script:IdentityFile_path)"
    }
    $Script:ServerSettingTable | ConvertTo-Json > $Script:ServerSettingFile
    $Script:ServerSettingFile | ConvertTo-UTF8NoBom
}

$Script:ServerSettingJson = (Get-Content -Path "$($Script:ServerSettingFile)") | ConvertFrom-Json
$Script:Config_path = "$($HOME)/.ssh/config"


$Script:CIP_ID = [string]($Script:ServerSettingJson.IPID)

$Script:MyUserName = [string]($Script:ServerSettingJson.User)
$Script:ServerName = [string]($Script:ServerSettingJson.Name)
$progressPreference = 'silentlyContinue' # 避免Invoke-Webrequest顯示進度干擾畫面
$Script:ServerAddress = ([string](Invoke-Webrequest -Uri "https://drive.google.com/uc?export=download&id=$($Script:CIP_ID)")).Replace("`n","").Replace("`r","")
$Script:ServerPort = [string]($Script:ServerSettingJson.Port)
$Script:IdentityFile_path = [string]($Script:ServerSettingJson.Iden)

$Script:Config_content = `
@(
    "# Read more about SSH config files: https://linux.die.net/man/5/ssh_config"
    "Host $($Script:ServerName)"
    "    HostName $($Script:ServerAddress)"
    "    StrictHostKeyChecking no"
    "    UserKnownHostsFile no"
    "    IdentityFile $($Script:IdentityFile_path)"
    "    User $($Script:MyUserName)"
    "    Port $($Script:ServerPort)"
    "    ForwardAgent yes"
) -join "`r`n"

Set-Content -Path "$($Script:Config_path)" -Value $Script:Config_content -Encoding ASCII
