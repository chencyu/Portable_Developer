[CmdletBinding()]
param (
    [Parameter(ParameterSetName = "AddHost")] [switch] $AddHost,
    [Parameter(ParameterSetName = "Update")] [switch] $Update,
    [Parameter(Position = 0, ParameterSetName = "Update")] [string] $ServerName
)

function ConvertTo-UTF8NoBom
{
    process
    {
        $Script:Content = Get-Content -Path "$_" -Raw
        $Script:Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines("$_", $Script:Content, $Script:Utf8NoBomEncoding)
    }
}



$SSH_Config = "$($HOME)/.ssh/config".Replace("\", "/")

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

if ($AddHost)
{
    $CIP_ID = Read-Host -Prompt "請提供存放Server當前IP的Google雲端檔案的ID"
    $MyUserName = Read-Host -Prompt "請提供登入伺服器時用的使用者名稱"
    $ServerName = Read-Host -Prompt "請提供伺服器名稱(自己取名)，不能有空格"
    $ServerPort = Read-Host -Prompt "請提供伺服器在SSH服務提供的端口"
    $IdentityFile_path = Read-Host -Prompt "請自行取得私鑰後，提供私鑰存放路徑，無私鑰請直接 Enter忽略"
    $IdentityFile_path = "$IdentityFile_path".Replace("\", "/")

    $ServerSettingFile = "$($HOME)/.ssh/Dynamic_IP_Server_setting/$($ServerName)"
    if (-Not (Test-Path -Path $ServerSettingFile)) { New-Item -ItemType File -Force -Path $ServerSettingFile }

    $ServerSettingTable = `
    @{
        IPID = "$($CIP_ID)";
        User = "$($MyUserName)";
        Name = "$($ServerName)";
        Port = "$($ServerPort)";
        Iden = "$($IdentityFile_path)"
    }
    $ServerSettingTable | ConvertTo-Json > $ServerSettingFile
    $ServerSettingFile | ConvertTo-UTF8NoBom
}
elseif ($Update)
{
    # Update the Dynamic IP of Host in $(HOME)/.ssh/config now
    $ServerSettingFile = "$($HOME)/.ssh/Dynamic_IP_Server_setting/$($ServerName)"
    $ServerSettingJson = (Get-Content -Path "$($ServerSettingFile)") | ConvertFrom-Json


    $CIP_ID = [string]($ServerSettingJson.IPID)

    $MyUserName = [string]($ServerSettingJson.User)
    $ServerName = [string]($ServerSettingJson.Name)
    $progressPreference = 'silentlyContinue' # 避免Invoke-Webrequest顯示進度干擾畫面
    $ServerAddress = ([string](Invoke-Webrequest -Uri "https://drive.google.com/uc?export=download&id=$($CIP_ID)")).Replace("`n", "").Replace("`r", "")
    $ServerPort = [string]($ServerSettingJson.Port)
    $IdentityFile_path = [string]($ServerSettingJson.Iden)

    #region Detect if Host exist in config file
    if (Test-Path -Path "$($SSH_Config)")
    {
        $SSH_Config_Content = Get-Content -Path "$($SSH_Config)"
        $HostNameLine = 1
        foreach ($line in $SSH_Config_Content)
        {
            if ($line -like "Host $($ServerName)")
            {
                $HostConfigExist = $true
                $SSH_Config_Content[$HostNameLine] = "    HostName $($ServerAddress)"
                Set-Content -Path "$($SSH_Config)" -Value $SSH_Config_Content -Encoding ASCII
                break
            }
            $HostNameLine++
        }
    }
    #endregion

    #region Add the Host setting into Config file
    if (-Not ($HostConfigExist))
    {
        $Host_Config_Content = `
        @(
            ""
            "Host $($ServerName)"
            "    HostName $($ServerAddress)"
            "    StrictHostKeyChecking no"
            "    IdentityFile $($IdentityFile_path)"
            "    User $($MyUserName)"
            "    Port $($ServerPort)"
            "    ForwardAgent yes"
            "    CheckHostIP no"
        ) -join "`r`n"

        Add-Content -Path "$($SSH_Config)" -Value $Host_Config_Content -Encoding ASCII
    }
    #endregion
}

# PDev專用
if (Test-Path -Path "Env:PDEVTOOLS")
{
    $VSCodeSettingFile = "$Env:APPDATA/Code/User/settings.json"
    if (Test-Path -Path $VSCodeSettingFile)
    {
        $VSCodeSetting_Table = (Get-Content -Path $VSCodeSettingFile | ConvertFrom-Json)
        if (Get-Member -InputObject $VSCodeSetting_Table -Name "remote.SSH.configFile")
        {
            if ($VSCodeSetting_Table.'remote.SSH.configFile' -ne "$SSH_Config")
            {
                $Dirty = $true
                $VSCodeSetting_Table.'remote.SSH.configFile' = "$SSH_Config"
            }
        }
        else
        {
            $Dirty = $true
            $VSCodeSetting_Table | Add-Member -NotePropertyName "remote.SSH.configFile" -NotePropertyValue "$SSH_Config"
        }
        if ($Dirty)
        {
            $VSCodeSetting_Table | ConvertTo-Json > $VSCodeSettingFile
            $VSCodeSettingFile | ConvertTo-UTF8NoBom
        }
    }
}