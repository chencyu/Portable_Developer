# $PSDefaultParameterValues['*:Encoding'] = 'utf8'

$Script:sw = $args[0]

$Script:cur_path=$pwd.path
$Script:not_linked_path=$pwd.path
$Script:cur_dir= split-path -leaf $Script:cur_path

function linked_path_func {
    # 如果用選項 -o 則將根目錄輸出到txt
    # 否則回傳連結後的PDev目錄
    if ($args[0] -eq "-o") {
        "$Env:PDEVROOT$Script:link_suffix" > tmp.txt
    } else {
        Write-Output "$Env:PDEVROOT$Script:link_suffix"
        # Set-Location "$env:pdevhome$Script:link_suffix"
    }
}

function Jump_to_link {
    # Close file explorer which path is not linked
    $shell = New-Object -ComObject Shell.Application
    $window = $shell.Windows() | Where-Object { $_.LocationURL -like "$([uri]"$Script:not_linked_path")" }
    $window | ForEach-Object { $_.Quit() }

    # Open new file explorer with linked path
    Start-Process -FilePath "explorer.exe" -ArgumentList "$Env:PDEVROOT$Script:link_suffix" -Wait
}

# 取得此處路徑後綴(Portable_Developer後面的路徑字串)
$Script:link_suffix = ""
while(($Script:cur_dir) -ne "Portable_Developer") {
    if(($Script:cur_dir) -eq "PDEVHOME") {
        # Already linked, so just exit
        # Write-Output ".\"
        return
    }
    $Script:link_suffix=($Script:link_suffix).insert(0, "\$Script:cur_dir")
    # 把當前路徑往上一層
    $Script:cur_path=split-path -parent $Script:cur_path
    # 取得當前路徑所在的資料夾名稱
    $Script:cur_dir= split-path -leaf $Script:cur_path
}

# Shell return linked here path
switch ($Script:sw) {
    "jump" { Jump_to_link }
    "retrpath" { linked_path_func }
    Default {}
}
