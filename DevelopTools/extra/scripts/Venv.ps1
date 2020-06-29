# Easy way to use venv, for common used
# 簡單使用python -m venv的指令，只適用幾個較普遍的操作

# $PSDefaultParameterValues['*:Encoding'] = 'utf8'

$VenvDir="$Env:USERPROFILE\PyVenv"
$operation=$args[0]


if (-Not (Test-Path "$VenvDir")) {
    mkdir "$VenvDir" | Out-Null
}

function test_exist {
    if (Test-Path "$VenvDir\$envName") {
        Write-Output "" "已經創建過此專案，請換另一個名稱" ""
        exit
    }
}

function list_env {
    $envList=Get-ChildItem "$VenvDir\"
    if (-Not $envList) {
        Write-Output "" "您目前沒有任何虛擬環境專案" ""
    } else {
        Write-Output "" "已建立的虛擬環境專案" ""
        for ($i = 0; $i -lt $envList.Count; $i++) {
            Write-Output ("({0:d2})  $($envList[$i].Name)" -f ($i+1))
        }
        Write-Output ""
    }
}

switch($operation){
    "create" {
        $pyVer=$args[1]
        $envName=$args[2]
        test_exist
        py -$pyVer -m venv "$VenvDir\$envName"
    }
    "delete" {
        $envName=$args[1]
        if (Test-Path -Path "$VenvDir\$envName") {
            Remove-Item -r "$VenvDir\$envName"
        }
    }
    "list" {
        list_env
    }
    "activate" {
        $envName=$args[1]
        if (-Not $envName) {
            Write-Output "" "請提供虛擬環境專案名稱" ""
            # Write-Output "" "Please provide envName" ""
        } elseif (-Not (Test-Path -Path "$VenvDir\$envName")) {
            Write-Output "" "您並沒有叫做`"$envName`"的虛擬環境專案" ""
            # Write-Output "" "You don't have virtual env named `"$envName`"" ""
        } elseif (-Not (Test-Path -Path "$VenvDir\$envName\Scripts\Activate.ps1")) {
            Write-Output "" "您的虛擬環境專案已損壞，請移除並重新創建" ""
            # Write-Output "" "Your virtual env has destoried, please remove and recreate it." ""
        } else {
            Invoke-Expression -Command "$VenvDir\$envName\Scripts\Activate.ps1"
            # Set-Alias -Name activatevenv -Value $VenvDir\$envName\Scripts\Activate.ps1
            # activatevenv
        }
    }
    "-h" {
        Write-Output `
        "" `
        "[Venv - Easy way to use Python venv]"`
        " ______________________________________________________ "`
        "|  venv  [operation]  [Py_ver(if'create')]  [envName]  |"`
        "|           create        (3.7/3.8 ...)       newEnv   |"`
        "|           delete                             myEnv   |"`
        "|            list                                      |"`
        "|          activate                            myEnv   |"`
        "|             -h                                       |"`
        "|  ex.                                                 |"`
        "|      venv create 3.7 myEnv                           |"`
        "|      venv delete myEnv                               |"`
        "|______________________________________________________|"`
        ""
    }
    default {
        Write-Output "" "使用 ``venv -h`` 來查看說明" ""
        # Write-Output "" "Use ``venv -h`` to get help" ""
    }
}
