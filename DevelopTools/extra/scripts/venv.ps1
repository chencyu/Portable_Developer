<#
.SYNOPSIS
    Easy way to use venv, for common used.
    簡單使用python -m venv的指令，只適用幾個較普遍的操作。
.DESCRIPTION
    .
.PARAMETER Path
    The path to the .
.PARAMETER LiteralPath
    Specifies a path to one or more locations. Unlike Path, the value of 
    LiteralPath is used exactly as it is typed. No characters are interpreted 
    as wildcards. If the path includes escape characters, enclose it in single
    quotation marks. Single quotation marks tell Windows PowerShell not to 
    interpret any characters as escape sequences.
.EXAMPLE
    C:/PS> 
    <Description of example>
.NOTES
    Author: ChenCYu
    Date:   July 09, 2020    
#>

[CmdletBinding(DefaultParameterSetName = "General")]
param
(
    [Parameter(Position = 0)] [String] $Operation,
    # [Parameter(ParameterSetName=)]
    [Alias("help")]
    [Parameter(            )] [Switch] $h = $false,
    [Alias("Py")]
    [Parameter(            )] [String] $PyVer = "3.8",
    [Parameter(Position = 1)] [String] $EnvName
)

if ($h)
{
    Write-Output `
        ""`
        " _________________________________________________________"`
        "| [Venv - Easy way to use Python venv]                    |"`
        "|---------------------------------------------------------|"`
        "|  venv  <operation>        <Py_ver>           <envName>  |"`
        "|           create       -py <3.7/3.8 ...>       newEnv   |"`
        "|           upgrade      -py <3.7/3.8 ...>        myEnv   |"`
        "|           remove                                myEnv   |"`
        "|            list                                         |"`
        "|          activate                               myEnv   |"`
        "|             -h                                          |"`
        "|  ex.                                                    |"`
        "|      venv create -py 3.7 newEnvName                     |"`
        "|      venv remove myEnvName                              |"`
        "|_________________________________________________________|"`
        ""
    return
}

$VenvSet = "$Env:UserProfile/.pyvenvs"
# $Operation = $args[0]


if (-Not (Test-Path "$VenvSet"))
{
    mkdir "$VenvSet" | Out-Null
}

function test_exist
{
    if (Test-Path "$VenvSet/$Script:envName")
    {
        return 1
    }
    else
    {
        return 0
    }
}

function env_Nexist
{
    Write-Output "" "尚未建立名為`"$EnvName`"的專案" ""
}

function list_env
{
    $envList = Get-ChildItem "$VenvSet/"
    if (-Not $envList)
    {
        Write-Output "" "您目前沒有任何虛擬環境專案" ""
    }
    else
    {
        Write-Output "" "已建立的虛擬環境專案" ""
        for ($i = 0; $i -lt $envList.Count; $i++)
        {
            Write-Output ("({0:d2})  $($envList[$i].Name)" -f ($i + 1))
        }
        Write-Output ""
    }
}

switch ($Operation)
{
    { $_ -in "create", "cr", "-cr" }
    {
        # $PyVer = $args[1]
        # $EnvName = $args[2]
        if (test_exist)
        {
            Write-Output "" "已經創建過此專案，請換另一個名稱" ""
            exit
        }
        py -$PyVer -m venv "$VenvSet/$EnvName"
    }
    { $_ -in "upgrade", "up" }
    {
        # $PyVer = $args[1]
        # $EnvName = $args[2]
        if (-Not (test_exist))
        {
            env_Nexist
        }
        py -$PyVer -m venv --upgrade "$VenvSet/$EnvName"
    }
    { $_ -in "delete", "del", "remove", "rm" }
    {
        # $EnvName = $args[1]
        Remove-Item -r "$VenvSet/$EnvName"
    }
    { $_ -in "list", "ls" }
    {
        list_env
    }
    { $_ -in "activate", "act", "-ac" }
    {
        # $EnvName = $args[1]
        if (-Not $EnvName)
        {
            Write-Output "" "請提供虛擬環境專案名稱" ""
            # Write-Output "" "Please provide envName" ""
        }
        elseif (-Not (test_exist))
        {
            env_Nexist
        }
        elseif (-Not (Test-Path -Path "$VenvSet/$EnvName/Scripts/Activate.ps1"))
        {
            Write-Output "" "您的虛擬環境專案已損壞，請移除並重新創建" ""
            # Write-Output "" "Your virtual env has destoried, please remove and recreate it." ""
        }
        else
        {
            &"$VenvSet/$EnvName/Scripts/Activate.ps1"
        }
    }
    default
    {
        Write-Output "" "語法錯誤"
        Write-Output "使用 'venv -h' 來查看說明" ""
        # Write-Output "" "Use 'venv -h' to get help" ""
    }
}
