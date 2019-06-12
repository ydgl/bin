@echo off

rem usage : bat dir_to_backup src_home_dir dst_home_dir
rem ex    : bat "20180514 - Affinite Recruteurs 2018 - AAAAMMDD" "D:\ApecBox\Espace Personnel\dlaurent (spsnas)\" "U:\"

REM TO INSTALL
REM   1-OPEN WINDOWS TASK PLANNIFIER
REM   2-CREATE FOLDER FOR YOUR OWN TASK ON THE LEFT
REM   3-CLICK CREATE TASK AND FOLLOW WIZARD

rem becareful with trailing space !!!
set dirtobackup=%~1
set srchomedir=%~2
set dsthomedir=%~3
set today=%date:~0,2%


rem call function
call :backupDIR

goto :end



REM backupDIR backup directory %dirtobackup%
:backupDIR 

@echo BGN %srchomedir%%dirtobackup% to %dsthomedir%%dirtobackup%


md "%dsthomedir%%dirtobackup%\%today%"


robocopy "%srchomedir%%dirtobackup%" "%dsthomedir%%dirtobackup%\%today%" /MIR
set time1=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,8%
set time2=%time1: =0%
set time2=%time1::=-%
echo %time2% > "%dsthomedir%%dirtobackup%\%time2%.txt"

echo END %srchomedir%%dirtobackup% to %dsthomedir%
rem return from function
goto :eof


:end
