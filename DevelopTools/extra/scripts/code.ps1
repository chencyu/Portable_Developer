if (Test-Path -Path "Env:VSCODE_DEV") { Remove-Item -Path "Env:VSCODE_DEV" }
Set-Item -Path "Env:ELECTRON_RUN_AS_NODE" -Value 1

$VSCodePath = "$Env:PDEVTOOLS/VSCode_Program_File"
$VSCodeCMD = `
@(
    "$VSCodePath/Code.exe"
    "$VSCodePath/resources/app/out/cli.js"
    "$args"
) -join " "

Invoke-Expression $VSCodeCMD