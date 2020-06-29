# Hack VSCode to make it use .ttf directly
# which means we can use custom font without install .ttf

# modify VSCode_Program_File\resources\app\out\vs\code\electron-browser\workbench\workbench.js
# VSCode will show the message that your vscode are not supported

# $PSDefaultParameterValues['*:Encoding'] = 'utf8'

function vsfont_help {
    Write-Output "
    vsfont -h             for help
    vsfont list           to show num & list of .ttf
    vsfont add num        to add (n) FontName into VSCode
    vsfont restore        to restore VSCode into original
    "
}

$global:FontFamilyHome = "$env:USERPROFILE\FontFamily"
$global:workbench_dir = "$env:pdevtools\VSCode_Program_File\resources\app\out\vs\code\electron-browser\workbench"

# Get list of TTF
if ((Test-Path -Path $global:FontFamilyHome)) { 
    if ((Get-ChildItem -Path "$global:FontFamilyHome")) {
        $global:ttf_not_empty=1
    } else {
        $global:ttf_not_empty=0
    }
} else {
    $global:ttf_not_empty=0
}
if ($global:ttf_not_empty) {
    $global:FontFamily_ttf__List = (Get-ChildItem -Path "$global:FontFamilyHome").name
    # Turn filename of ttf into Font Family Name use in VSCode
    $global:FontFamily_name_List = $global:FontFamily_ttf__List.Replace("-"," ").Replace(".ttf","")
}

function Remove_vsfont_GVar {
    Remove-Variable -Name "FontFamilyHome" -Scope "Global"
    Remove-Variable -Name "workbench_dir" -Scope "Global"
    if ($global:ttf_not_empty) {
        Remove-Variable -Name "FontFamily_ttf__List" -Scope "Global"
        Remove-Variable -Name "FontFamily_name_List" -Scope "Global"
    }
}

function ListTTFs {
    if ($global:ttf_not_empty -eq 0) {
        Write-Output "" "You don't have any TTF in $global:FontFamilyHome" ""
        return
    }
    Write-Output "" "TTF file are locate in $global:FontFamilyHome" ""
    if ($global:FontFamily_name_List.Count -eq 1) {
        Write-Output "" "(1) $($global:FontFamily_name_List)" ""
        return
    }
    Write-Output ""
    for ($i = 0; $i -lt $global:FontFamily_name_List.Count; $i++) {
        Write-Output "($($i+1)) $($global:FontFamily_name_List[$i])"
    }
    Write-Output ""
    return
}

function addTTF ($n){
    if ($global:ttf_not_empty -eq 0) {
        Write-Output "" "You don't have any TTF in $global:FontFamilyHome" ""
        return
    }
    if ($n -gt $global:FontFamily_name_List.Count) {
        Write-Output "" "Out of FontFamily List index" ""
        return
    }

    if ($global:FontFamily_name_List.Count -eq 1) {
        $FontName     = $global:FontFamily_name_List
        $FontFileName = $global:FontFamily_ttf__List
    } else {
        $FontName     = $global:FontFamily_name_List[$n-1]
        $FontFileName = $global:FontFamily_ttf__List[$n-1]
    }

    $ffhurl  = $global:FontFamilyHome.Replace("\","/")
    $ttfurl  = $FontFileName.Replace("\","/")

    $fullurl = "file:///" + $ffhurl + "/" + $ttfurl

    if (-Not (Test-Path -Path "$workbench_dir\original")) {
        New-Item -Path "$workbench_dir" -Name "original" -ItemType "directory" | Out-Null
        Copy-Item -Path "$workbench_dir\workbench.js" -Destination "$workbench_dir\original\workbench.js"
    }

    Write-Output `
"// $FontName by vsfont.ps1
var styleNode = document.createElement('style'); 
styleNode.type = `"text/css`";  
var styleText = document.createTextNode(``
    @font-face{
        font-family: '$FontName'; 
        src: url('$fullurl') format('truetype');
        font-weight: normal;
        font-style: normal;
    }``); 
styleNode.appendChild(styleText); 
document.getElementsByTagName('head')[0].appendChild(styleNode);" >> "$workbench_dir\workbench.js"

}

function restore_workbench {
    if ((Test-Path -Path "$global:workbench_dir\original\workbench.js")) {
        Move-Item -Path "$global:workbench_dir\original\workbench.js" -Destination "$global:workbench_dir\workbench.js" -Force
        Remove-Item -Path "$global:workbench_dir\original" -Recurse
    }
}

switch ($args[0]) {
    "-h"       { vsfont_help }
    "list"     { ListTTFs }
    "add"      { addTTF $args[1] }
    "restore"  { restore_workbench }
    Default    { Write-Output "" "    run `"vsfont -h`" for help" "" }
}

# Remove All Global Variables set in vsfont
Remove_vsfont_GVar

