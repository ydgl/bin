

<#
.SYNOPSIS 
    Update portable app with a new version (without admin right) using custom recipes

    	
.DESCRIPTION
    As i have no admin right anymore, i develop a portable app updater script.
    Require a recent version of powershell (wich is also portable)
    nau : No Admin Updater

.PARAMETER INSTALL_URL
    URL where to download new portable application version

.PARAMETER PRODUCT_PATH
    Application is already locally available

.PARAMETER PRODUCT_NAME
    Define install recipe and destination in $DEVTOOLS

.PARAMETER NO_SWAP
    Do not replace current install version with downloaded one at the end.
    Instead print out required command.
    This is "required" when replacing powershell :-)

.EXAMPLE
     .\nau.ps1 -PRODUCT_NAME dbeaver -INSTALL_URL "https://dbeaver.io/files/dbeaver-ce-latest-win32.win32.x86_64.zip" 
     .\nau.ps1 -PRODUCT_NAME pwsh -INSTALL_URL "https://github.com/PowerShell/PowerShell/releases/download/v6.2.3/PowerShell-6.2.3-win-x64.zip"

#>

<# Notes 
 powershell : https://github.com/PowerShell/PowerShell/blob/master/README.md
 mklink /J .\pwsh .\PowerShell-6.2.3-win-x64

 TODO :

#>

param (
    [Parameter (mandatory = $true)]
    [string] $PRODUCT_NAME = $null,
    [string] $INSTALL_URL = $null,
    [string] $PRODUCT_PATH = $null,
    [switch] $NO_SWAP 
)

Set-StrictMode -Version Latest


function Test-FolderLocked
{
    param
    (
        [string]$FilePath
    )
    $retValue = $false

    # Path to Handle tool from MS sysinternals 
    $HANDLE_EXE="$Env:DEVTOOLS\handle64.exe"
    
    if (Test-Path $HANDLE_EXE) {
        # Handle.exe is about 10sec to process request (V4.22 on windows7 in 2019)
        $result = Invoke-Expression "$HANDLE_EXE /accepteula $FilePath /nobanner" 
        if (($result -like "*$FilePath*").Length -gt 0) {
            $retValue =  $true
        }
    } else {
        Write-Host "Unable to find $HANDLE_EXE" -f Red
        Write-Host "See https://docs.microsoft.com/en-us/sysinternals/downloads/handle" -f Red
        # User will handle situation
    }

    return $retValue
}



function installNewZip
{
    param([string] $product, [string]$zipfile, [string]$outpath, [string] $innerZipFolder)

    Write-Host "- Install zip to ..." -NoNewline
    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue "$env:Temp\$product.new"
    Expand-Archive -Path "$zipFile" -DestinationPath "$env:Temp\$product.new"
    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue "$outpath"
    Move-Item $env:Temp\$product.new\$innerZipFolder $outpath


    Write-Host " $outpath" -f Green
}

function dl($urlLink) {
    $targetFile = Split-Path $urlLink -Leaf

    Write-Host "- Download ..." -NoNewline
    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue "$($env:Temp)\$targetFile" 
    Invoke-WebRequest -URI $urlLink -OutFile "$($env:Temp)\$targetFile"
    Write-Host " File saved as $($env:Temp)\$targetFile" -f Green

    #$r = Get-ChildItem "$($env:Temp)\dbeaver*"
    #Write-Host $r

    return "$($env:Temp)\$targetFile"

}




function dbeaver($zipFileNamePath, $destFolder) {
    $CURRENT_FUNCTION = $MyInvocation.MyCommand
    #Write-Host "Install $CURRENT_FUNCTION from $zipFileNamePath to $destFolder"

    installNewZip $CURRENT_FUNCTION "$zipFileNamePath" "$destFolder\$CURRENT_FUNCTION.new" $CURRENT_FUNCTION

    Write-Host "- Configure $CURRENT_FUNCTION dbeaver.ini ..." -NoNewline
    Copy-Item "$destFolder\$CURRENT_FUNCTION.new\dbeaver.ini" "$destFolder\$CURRENT_FUNCTION.new\dbeaver.ini.orig"
    (Get-Content -Path "$destFolder\$CURRENT_FUNCTION.new\dbeaver.ini.orig") |
        ForEach-Object {$_ -Replace '-vmargs', "-vm`r`nD:\java\jdk1.8.0_181\bin\javaw.exe`r`n-vmargs"} |
        Set-Content -Path "$destFolder\$CURRENT_FUNCTION.new\dbeaver.ini"
    #Copy-Item "$destFolder\$CURRENT_FUNCTION\dbeaver.ini" "$destFolder\$CURRENT_FUNCTION.new\dbeaver.ini"
    Copy-Item "$destFolder\$CURRENT_FUNCTION\ojdbc6.jar" "$destFolder\$CURRENT_FUNCTION.new\"
    Copy-Item "$destFolder\$CURRENT_FUNCTION\ojdbc6dms.jar" "$destFolder\$CURRENT_FUNCTION.new\"
    Copy-Item "$destFolder\$CURRENT_FUNCTION\orai18n.jar" "$destFolder\$CURRENT_FUNCTION.new\"
    Copy-Item "$destFolder\$CURRENT_FUNCTION\xdb6.jar" "$destFolder\$CURRENT_FUNCTION.new\"
    Write-Host " OK" -f Green
    
    Write-Host "- Remove $CURRENT_FUNCTION.old ..." -NoNewline
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$destFolder\$CURRENT_FUNCTION.old"
    Write-Host " OK" -f Green


}

function vsc($zipFileNamePath, $destFolder) {
    $CURRENT_FUNCTION = $MyInvocation.MyCommand
    #Write-Host "Install $CURRENT_FUNCTION from $zipFileNamePath to $destFolder"

    installNewZip $CURRENT_FUNCTION "$zipFileNamePath" "$destFolder\$CURRENT_FUNCTION.new" 

    
    Write-Host "- Remove $CURRENT_FUNCTION.old ..." -NoNewline
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$destFolder\$CURRENT_FUNCTION.old"
    Write-Host " OK" -f Green


}


$DEVTOOLS_HOME = [Environment]::GetEnvironmentVariable("DEVTOOLS","User")
if (-not $DEVTOOLS_HOME){
    $DEVTOOLS_HOME = [Environment]::GetEnvironmentVariable("DEVTOOLS","Machine")
    if (-not $DEVTOOLS_HOME){
        Write-Host "DEVTOOLS environment variable is not defined (user ou system level"
        Exit
    }
}


If ($PRODUCT_PATH -eq $null) {
    Write-Host "$INSTALL_URL --> $DEVTOOLS_HOME\$PRODUCT_NAME"
} else {
    Write-Host "$PRODUCT_PATH --> $DEVTOOLS_HOME\$PRODUCT_NAME"
}



if (Test-FolderLocked "$DEVTOOLS_HOME\$PRODUCT_NAME") {
    Write-Host "$DEVTOOLS_HOME\$PRODUCT_NAME is LOCKED, install ABORTED"  -f Red
} else {

    if (Get-Command $PRODUCT_NAME -ErrorAction SilentlyContinue) {
        if ($PRODUCT_PATH -eq $null) {
            $installFile = dl($INSTALL_URL)
        } else {
            $installFile = $PRODUCT_PATH
        }

        Invoke-Expression "$PRODUCT_NAME $installFile $DEVTOOLS_HOME"

        if ($NO_SWAP) {
            Write-Host "- NO_SWAP Request, run the following statements :" -f Red
            Write-Host "Move-Item ""$DEVTOOLS_HOME\$PRODUCT_NAME"" ""$DEVTOOLS_HOME\$PRODUCT_NAME.old"""
            Write-Host "Move-Item ""$DEVTOOLS_HOME\$PRODUCT_NAME.new"" ""$DEVTOOLS_HOME\$PRODUCT_NAME"""
        } else {
            Write-Host "- Swapping $PRODUCT_NAME.new -->  $PRODUCT_NAME ..." -NoNewline
            Move-Item "$DEVTOOLS_HOME\$PRODUCT_NAME" "$DEVTOOLS_HOME\$PRODUCT_NAME.old"
            Move-Item "$DEVTOOLS_HOME\$PRODUCT_NAME.new" "$DEVTOOLS_HOME\$PRODUCT_NAME"
            Write-Host " OK" -f Green
        }
    } else {
        Write-Host "Product $PRODUCT_NAME is not known / not handled" -f Red
    }
    
}






