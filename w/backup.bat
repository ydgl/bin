rem md "U:\20180802 - VPM2 - AAAAMMDD"
rem robocopy "D:\ApecBox\Espace Personnel\dlaurent (spsnas)\20180802 - VPM2 - AAAAMMDD" "U:\20180802 - VPM2 - AAAAMMDD" /MIR /dcopy:T
set time1=%date:~6,4%/%date:~3,2%/%date:~0,2%-%time:~0,8%
set time2=%time1: =0%

echo %time2%
REM time2 = date time formated as "YYYY/MM/DD-HH:MI:SS"

md "U:\20180802 - VPM2 - AAAAMMDD"