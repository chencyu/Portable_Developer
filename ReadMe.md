
# PDev - Portable Developer

## 移動開發環境 ver_1.0_beta-6

<!-- TOC -->

- [PDev - Portable Developer](#pdev---portable-developer)
  - [移動開發環境 ver_1.0_beta-6](#移動開發環境-ver_10_beta-6)
    - [簡介](#簡介)
      - [都沒有人回報Bug嗚嗚嗚](#都沒有人回報bug嗚嗚嗚)
    - [what's news in ver_1.0](#whats-news-in-ver_10)
      - [beta-1](#beta-1)
      - [beta-2](#beta-2)
      - [beta-3](#beta-3)
      - [beta-4](#beta-4)
      - [beta-5](#beta-5)
      - [beta-6](#beta-6)
      - [beta-7](#beta-7)
      - [beta-8](#beta-8)
    - [_**注意**_](#注意)
    - [使用說明](#使用說明)
    - [額外內建CLI工具](#額外內建cli工具)
      - [所有工具都要在啟動__PowerShell.cmd後才能正常運作](#所有工具都要在啟動__powershellcmd後才能正常運作)
    - [Bug report](#bug-report)

<!-- /TOC -->

### 簡介

一碟在手，扣橫著走  
無論你是借用別人的電腦，還是圖書館、學校的公用電腦，都能爽爽寫扣，沒有Adin權限也無所謂內附Powershell、Mingw、Python，其中Python更是可以做到讓虛擬環境可以在換到其他電腦後依然正常運作  

尤其適合程式初學者、學生、沒有筆電可以帶著跑的人  

CopyTo.cmd到隨身碟中即可運作，或者存放到硬碟中做為綠色版程式也行  

#### 都沒有人回報Bug嗚嗚嗚

1.0 版打算要讓功能盡量完善，目前已經差不多了但還有一些小地方要補上，所以先做為 beta 版，
另外就是看有沒有別人回報一些我不知道的問題，不過信箱全空.......

### what's news in ver_1.0

#### beta-1

 1. 新增PDevUser資料夾，並將其作為UserProfile、AppData的儲存空間，以利於Portable Program的資料存放，此外也有利於Portable Python使用Jupyter Notebook時，將Kernel Setting等資料存放於PDev中，而非本機的AppData
 2. 修正venv.ps1，使其正常運作
 3. 新增py.ps1，Portable版的Python並無內建Win Python所附帶的Python Launcher(py.exe -version *.py)以此做為替代方案，pyw.ps1以內建但尚未支援
 4. 新增vsfont.ps1，可以對VSCode進行修改，使其無須安裝就能支援第三方字體
 5. CopyTo.cmd 增加防呆機制，避免錯誤複製

#### beta-2

 1. set_PATH\basic.cmd 不再嘗試新增%HOMEPATH%，避免新增額外的無用資料夾
 2. 改良 venv.ps1，優化防呆機制，並增加數個提示訊息來幫助使用者更簡易的使用工具
 3. 改良 linked_pwd.ps1，使其可以正確地將非連結後、中文路徑的檔案總管視窗關閉，並啟動連結後新視窗
 4. VSCode的data與tmp會使用PDevProfile下的，而非原先所設的VSCode\data.....

#### beta-3

 1. 增加一些額外的小型 Command Line 指令工具，包括：wget、ASCII、sleep、zip/unzip ，並附上來源或原始碼

#### beta-4

 1. 用PS2EXE將內建之ps1腳本轉換為exe執行檔，藉此使禁用腳本執行的電腦可以直接透過內建PowerShell執行PDev工具，而無需使用移動版 PowerShell，這樣可以使PDev減少224MB的大小，未來將不再內建 PowerShell 7 移動版
 2. 修復一個問題：當本機電腦有配置Autorun腳本來設置環境變數時，由於set_PATH等配置腳本執行順序較本機Autorun腳本來的早，導致重複名稱的指令其優先權被本機Autorun壓過。在此版本中確保set_PATH於最後時間執行
 3. 不再預先內建 Portable_VSCode，啟動__PowerShell.cmd後執行 `upgrade vscode` 即可自動安裝Portable_VSCode

#### beta-5

 1. 取消[beta-4 (1.)]的變更，並以`powershell -ExecutionPolicy UnRestricted` 作為替代，可以僅限當前Shell允許任何腳本執行
 2. 啟動PowerShell時會自動更改Shell介面為黑底白字
 3. 最近去學了Markdown語法，趁勢把說明文件改成Markdown格式，省的用一大堆符號去排版....Orz

#### beta-6

 1. 把每一Beta版的更新內容區分開來
 2. 將`upgrade.ps1`更名為`install.ps1`
 3. 優化CopyTo.cmd，當目的路徑不存在時顯示錯誤訊息
 4. 移除無用的程式碼：每個ps1腳本中的`$PSDefaultParameterValues['*:Encoding'] = 'utf8'`
 5. 簡化__PowerShell.cmd呼叫powershell.exe時的指令長度，以避免出錯
 6. 修正whexe.ps1，使其功能可以相容PowerShell 2.0 (Win 7)
 7. 補上Junction的說明與來源
 8. 將所有ps1腳本由UTF-8改為UTF-8 with BOM，以利於PowerShell 5.1以前執行
 9. 對__PowerShell.cmd、Laundh_VSCode.cmd 做出修正，使其「先啟動連結後目錄」、「再啟動PowerShell 或 VSCode」，有利於用戶體驗
10. 不再內建 Portable Python，但支援以指令更新安裝。請以 `install python x.x` 安裝更新
11. 改為以 ps1 腳本實作zip、unzip功能，不再內建zip.exe、unzip.exe
12. 以PowerShell提供的 `Invoke-WebRequest` 取代wget.exe，不再內建wget.exe
13. 修改預設 Prompt為 `PDev $(Get-Location)`，並每次都在Prompt下方輸入指令
14. 改為使用本機的TMP/TEMP位置而非PDev的以增進效能
15. 更改 Portable Python 的預設安裝路徑為 `C:/PDEVHOME/USER/AppData/Local/Programs/Python/PythonXX` 以利於未來移植一般Python的功能
16. 不再內建 MinGW-W64，但支援以指令更新安裝。請以 `install mingw [win32|posix]` 安裝更新
17. 新增 7zip CLI Tools

#### beta-7

 1. zip.ps1、unzip.ps1的通用性不如預期，修改為在腳本執行失敗時自動呼叫zip.exe、unzip.exe
 2. 統一`.ps1`腳本為 **UTF-8 with BOM**、`.cmd/.bat`腳本為 **UTF-8**
 3. 修改install.ps1，在偵測到.NET使用的並非新版的TLSv1.2時自動修改為使用新版，以確保能正確從網站下載檔案
 4. 修復Launch_VSCode.cmd不會自動將檔案總管切換到連結後目錄的問題

#### beta-8

 1. 增加UTF8NoBom.psm1模組，內部提供將文本轉換成UTF8-No-Bom的格式
 2. 增加對浮動IP的SSH Server的支持
    - 需自行在Server上設定自動上傳目前IP到Google雲端硬碟的服務
    - 啟動`__PowerShell.cmd`後執行`dipssh -AddHost`來設定新Host
    - 啟動`__PowerShell.cmd`後執行`dipssh -Update <Host>`來更新Host的IP
 3. VSCode的環境變數PATH改為`C:/PDEVHOME/DevelopTools/VSCode_Program_File/bin`而非`C:/PDEVHOME/DevelopTools/VSCode_Program_File/`，使`code`指令更符合原生VSCode的用法
 4. 修復SSH Config所設定的Host無法連線的問題，必須要在VSCode設定中手動指定config路徑，不能用預設的變數($HOME/.ssh)引導
 5. 修復`Launch_VSCode.cmd`啟動VSCode以後不會自己關閉CMD視窗的問題
 6. 發現`mklink /J`不像`mklink /D`那樣需要管理員權限，因此不再用`Junction`而是使用`mklink /J`
 7. 用`Profile.ps1`取代`pdev.ps1`的作用

### _**注意**_

|                                        |
| :------------------------------------: |
|          目前僅優先支援Win10           |
|          待功能齊全完備穩定後          |
|       才會考慮向下相容Win8、Win7       |
| -------------------------------------- |
|       目前並未處理跨版本相容問題       |
|     新版本直接覆蓋不一定能正常運作     |
| -------------------------------------- |
|  使用4K隨機讀寫較快的隨身碟或行動硬碟  |
|        可以享有較良好的使用體驗        |
| -------------------------------------- |
|   隨身碟建議將配置單位大小以8K格式化   |
|              比較節約空間              |
| -------------------------------------- |

### 使用說明

 1. CopyTo
    - 如果要複製到隨身碟上建議點擊"CopyTo"並輸入目的位置來複製整個PDev，會比較快一些，零碎小檔案眾多，複製到一般隨身碟上較為耗時，敬請耐心等候。
 2. VSCode
    - [Source](https://code.visualstudio.com/download)
    - 並未內建，首次使用請啟動__PowerShell.cmd並以 `install vscode` 安裝更新
    - 欲啟動VSCode時，請點擊Launch_VSCode.cmd，會自動設定環境變數後啟動VSCode。不建議進入VSCode_Program_File開啟Code.exe，這樣VSCode無法使用移動開發工具
    - 。若要在Python venv中開啟VSCode，直接在venv啟動後的Command line下"code"指令即可
    - VSCode會認得所有的移動開發工具，並優先使用移動版而非本機自帶的工具
 3. PowerShell
    - 直接點擊"__PowerShell.cmd"
    - 會自動將開發工具加入環境變數，並於該路徑啟動PowerShell。請勿原本的方法直接啟動本機電腦的CMD / PowerShell，他們不會自動設置環境變數
    - 若要在PDev下其他的資料夾中啟動PowerShell，請將__PowerShell.cmd複製到該資料夾再啟動即可
    - 為了使部分工具正常運作，本工具透過junction將C:\PDEVHOME連結到Portable_Developer的位置，使其在每一台電腦的路徑固定。因此PowerShell所顯示的路徑會是C:\PDEVHOME\my_path\my_path，此為正常現象。
    - 注意：任何工具都需要在Portable_Developer底下才能正常運作，請勿更改此資料夾名稱
    - 預設變數：
      - `$env:PDEVROOT     = "C:\PDEVHOME"`
      - `$env:USERPROFILE  = "C:\PDEVHOME\PDevUser"`
      - `$env:APPDATA      = "$env:USERPROFILE\AppData"`
      - `$env:USERNAME     = "PDevUser"`
      - `$env:USERPROFILE  = "$env:PDEVHOME\$env:USERNAME"`
      - `$env:HOMEPATH     = "$env:PDEVHOME.Substring(2)\PDevUser"`
      - `$env:APPDATA      = "$env:USERPROFILE\AppData\Roaming"`
      - `$env:LOCALAPPDATA = "$env:USERPROFILE\AppData\Local"`
      - `$env:TEMP         = "$env:USERPROFILE\AppData\Local\Temp"`
      - `$env:TMP          = "$env:USERPROFILE\AppData\Local\Temp"`
 4. mingw-w64
    - [Source](https://sourceforge.net/projects/mingw-w64/)
    - 直接以__PowerShell.cmd啟動後就可以用指令gcc/g++
 5. Python
    - [Source](https://sourceforge.net/projects/portable-python/)
    - 並未內建，請以 `install python x.x` 安裝更新
    - 啟動"__PowerShell.cmd"後，用 py -pyver 來使用
    - Example: py -3.7 hello_world.py

### 額外內建CLI工具

#### 所有工具都要在啟動__PowerShell.cmd後才能正常運作

 1. whexe
    - 與CMD的where作用相同，查詢程式所在位置
 2. venv
    - 簡易性的使用python -m venv，使用方法類同conda
    - 請啟動 __PowerShell.cmd，並使用 venv -h 查看說明或是直接使用 python -m venv，若是使用 python -m venv, 請務必將虛擬環境建置於C:\PDEVHOME\底下的某位置，以利於不同電腦中運作
 3. vsfont
    - 用來竄改VSCode的內部workbench.js，使其可以在不必安裝.ttf 的前提下支援第三方字體包， vsfont -h 查看說明
    - 請將字體包放在PDev\FontFamily
 4. install
    - 用來自動更新PDev內的開發工具，目前支援更新VSCode
    - 執行`update vscode`來更新VSCode
 5. sleep、zip/unzip
    - Source:
      - sleep
        - 自己用C寫的，source code跟執行檔放在一起
      - zip/unzip
        - 用ps1腳本實作
    - 用法與 Linux 裡同名稱的指令相同
 6. ASCII
    - 在 Command Line 下執行 `ascii [single char]` 來顯示該字元的 ASCII 碼，適合初學C/C++者一些字元處理相關的題目
 7. Junction
    - [Source](https://docs.microsoft.com/zh-tw/sysinternals/downloads/junction)
    - 用以建立目錄的連結點，類似Symbolic Link
 8. 7za
    - [Source](https://www.7-zip.org/download.html)
    - 用法詳見官網

### Bug report

請寄到chencyu.pdev@gmail.com  
標題 "PDev Bug Report"，並註明版本，謝謝你的回報
