$TMPPYVER = "$($args[0])"
if ($args.Count -ge 2) {
    $arglist = "$($args[1..($args.count-1)])"
}

if ($null -ne $args[0]) {
    try {
        # 可以被轉成數字，表示有指定版本
        $PYVER = [Float]($TMPPYVER.Replace('-',''))
    } catch {
        $arglist = "$args"
        $NOTVER = "$($args[0])"
    }
} else { $NOTVER = "$($args[0])" }

$default_ver_txt = "$Env:PDEVTOOLS/Python/Launcher/default_ver.txt"
if (Test-Path -Path "$default_ver_txt") { $default_ver = Get-Content -Path "$default_ver_txt" }


# call out command set
# $py37 = "$Env:PDEVTOOLS/Python/Python37/App/Python/python.exe $arglist"
# $py38 = "$Env:PDEVTOOLS/Python/Python38/App/Python/python.exe $arglist"
# $py39 = "$Env:PDEVTOOLS/Python/Python39/App/Python/python.exe $arglist"
# $py_default = "$Env:PDEVTOOLS/Python/Python$($default_ver)/App/Python/python.exe $arglist"

$py37 = "$Env:PYTHONROOT/Python37/pythonw.exe $arglist"
$py38 = "$Env:PYTHONROOT/Python38/pythonw.exe $arglist"
$py39 = "$Env:PYTHONROOT/Python39/pythonw.exe $arglist"
$py_default = "$Env:PYTHONROOT/Python$($default_ver)/pythonw.exe $arglist"

$HelpScript=@"
Launcher arguments:

-2     : Launch the latest Python 2.x version (supported not yet)
-3     : Launch the latest Python 3.x version (supported not yet)
-X.Y   : Launch the specified Python version
     The above all default to 64 bit if a matching 64 bit python is present.
-X.Y-32: Launch the specified 32bit Python version  (supported not yet)
-X-32  : Launch the latest 32bit Python X version   (supported not yet)
-X.Y-64: Launch the specified 64bit Python version  (supported not yet)
-X-64  : Launch the latest 64bit Python X version   (supported not yet)
-0  --list       : List the available pythons       (supported not yet)
-0p --list-paths : List with paths                  (supported not yet)
"@


# 沒有安裝任何Python
if (-Not (Test-Path -Path "$Env:PYTHONROOT/Python*")) {
    Write-Output "" "尚未安裝任何 Python" "執行 ``install python x.x 來進行安裝``" ""
    exit
}


function Test-Python([string]$ver) {
    if (-Not (Test-Path -Path "$Env:PYTHONROOT/Python$($ver.Replace('.',''))/python.exe")) {
        Write-Output ""`
        "Python $($ver) not installed"`
        "Please run ``install python $($ver)`` to install it" ""
        exit
    }
}

<# 
function Set-PythonEnv([string]$ver) {
    $ver = $ver.Replace('.','')
}
 #>

if (Test-Path -Path Variable:PYVER) {
    switch ( $PYVER )
    {
        3.7 { 
            Test-Python("3.7")
            Invoke-Expression -Command $py37
        }
        3.8 { 
            Test-Python("3.8")
            Invoke-Expression -Command $py38
        }
        3.9 { 
            Test-Python("3.9")
            Invoke-Expression -Command $py39
        }
        Default {
            Write-Output "" "目前並不支援 Python $PYVER.......Orz" ""
        }
    }
} else {
    switch ($NOTVER) {
        "-setdefault" {
            Set-Content -Path "$Env:PDEVTOOLS/Python/Launcher/default_ver.txt" -Value "$(([string]$args[1]).Replace('.',''))"
        }
        "-h"   {
            Write-Output $HelpScript
            exit
        }
        default {
            Invoke-Expression -Command $py_default
        }
    }
}
