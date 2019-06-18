@echo off

rem usage : bat dir_to_backup src_home_dir dst_home_dir
rem ex    : bat "my local work directory to backup" "D:\my local work home folder" "U:\my backups"
rem copy dir_to_backup to dst_home_dir/lbk (shortcut for last backup)
rem   and
rem copy changed files in dir_to_backup since 2 days to dst_home_dir/<current day number> (which perform a monthly rolling backup)

REM TO INSTALL
REM   1-OPEN WINDOWS TASK PLANNIFIER
REM   2-CREATE FOLDER FOR YOUR OWN TASK ON THE LEFT
REM   3-CLICK CREATE TASK AND FOLLOW WIZARD

rem becareful with trailing space !!!
set dirtobackup=%~1
set srchomedir=%~2
set dsthomedir=%~3
set today=%date:~0,2%


call :backupDIR

goto :end



:backupDIR 

@echo BGN backupDIR %srchomedir%%dirtobackup% to %dsthomedir%


md "%dsthomedir%%dirtobackup%\lbk"
robocopy "%srchomedir%%dirtobackup%" "%dsthomedir%%dirtobackup%\lbk" /MIR


del /FS "%dsthomedir%%dirtobackup%\%today%"
md "%dsthomedir%%dirtobackup%\%today%"
robocopy "%srchomedir%%dirtobackup%" "%dsthomedir%%dirtobackup%\%today%" /S /MAXAGE:2

set time1=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,8%
set time2=%time1: =0%
set time2=%time1::=-%
echo %time2% > "%dsthomedir%%dirtobackup%\%time2%.txt"

@echo END backupDIR %srchomedir%%dirtobackup% to %dsthomedir%
goto :eof


:end
