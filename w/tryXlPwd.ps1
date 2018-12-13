$ErrorActionPreference = 'silentlycontinue'

# XLS Filename to crack
$xFile = 'd:\crackit\reg.xlsx'

# dictionnary of digits to try
$rangeDigits = "acep"

# if usefull starting wording (help to decrease complexity because we often use a root)
$rootPwd = ""

# Max number of digit to try after the root
$maxPosition = 4



# Try the password in the form $rootPwd$startPwd to open an excel file
# with $startPwd = all occurrence possible with digits in $rangeDigits for $maxPosition number of digit
# Usage : $0 "" "password"
# If $rangeDigits="bA" and $maxPosition=2 try :
#     - passwordA
#     - passwordb
#     - passwordAA
#     - passwordAb
#     - passwordbA
#     - passwordbb
$startPwd = $Args[0]
$rootPwd = $Args[1]


function nextDigit([char[]] $digits, [char] $digit, [int] $iCarry) {
    $iSize = $digits.Count;
    $retDigit =  $digit;
    
    # Write-Host $digits $digit $iCarry 
    if ($iCarry -gt 0) { 
        $retDigit = $digits[0];
        for ($i=0; $i -lt $iSize; $i++) {
            if ($digits[$i] -eq $digit) {
                if ($i -le $iSize-2) {
                    $retDigit = $digits[$i+1];
                    $i = $iSize;
                }
            }
        }
     
    }
     return $retDigit;
 }

function incPwdDigit([string] $currentPwd, [string] $allDigits, [int] $maxDigits)
{ 
    [string] $newPwd = " "

    # Write-Host $currentPwd
    # Write-Host $allDigits

    $digits = $allDigits.toCharArray()
    $firstDigit = $allDigits.substring(0,1)

    $cPwdArray = $currentPwd.toCharArray()
    [array]::Reverse($cPwdArray)
    $cPwdArraySize = $cPwdArray.Count
    $nPwdArray = @()

<#     Write-Host $digits
    Write-Host $firstDigit
    Write-Host "cPwdArray: " $cPwdArray
    Write-Host $nPwdArray
    Write-Host $maxDigits #>

    $i=0;
    $iCarry=1;

	while ($i -lt $maxDigits) {
        $cDigit = " "
        
        if ($i -lt $cPwdArraySize) {
            $cDigit = $cPwdArray[$i]
        }

        # Write-Host $cDigit $cPwdArray[$i] $i
        
        $nDigit = nextDigit -digits $digits -digit $cDigit -iCarry $iCarry
        $nPwdArray+= $nDigit;
        
       # If next digit is not first digit, we don't have to increment next order
        if ($nDigit -ne $firstDigit) {
            $iCarry=0;
       }
       
       # It we have a carry and next order is a new digit order they is no carry anymore
        if (($iCarry -eq 1) -and (" " -eq $cDigit) ) {
            $iCarry =0;
        }
        
        #Write-Host "Inc(carry): " $i " (" $iCarry ") - old: " $cDigit " - new: " $nPwdArray[$i]
        
        $i++;
    }

    if ($iCarry -eq 0) {
        [array]::Reverse($nPwdArray)
        #$nPwdArray = $nPwdArray | Where-Object { $null -eq $_ }
        $newPwd = -join $nPwdArray
        $newPwd = $newPwd.Trim()
    } 

    return $newPwd
}


$excel = New-Object -ComObject excel.application
$excel.Visible = $false
$excel.DisplayAlerts = $false


do {
    $testPwd=$rootPwd + $startPwd

    # BEGIN test zone with password = $testPwd
    $excel.Workbooks.Open($xFile,0,$true,5,$testPwd,$testPwd)
    $name = $excel.Workbooks | Select-Object -Property 'Name'
    if ($name) {
        &Write-Host "-----------Password Found---------------"
        &Write-Host $testPwd
        break
    } else {
        &Write-Host $testPwd "(FAIL)"
    }
    # END test zone

    $startPwd = incPwdDigit -currentPwd $startPwd -allDigits $rangeDigits  -maxDigits $maxPosition
} while (" " -ne $startPwd)






