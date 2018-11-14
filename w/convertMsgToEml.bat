@echo off
REM convert msg to eml
REM Usage : select file(s) right clic and select this bat file in sendto menu


REM installation
REM 1- Clic on windows start menu
REM 2- Enter "shell:sendto", folder sendto will open in an explorer window
REM 3- copy this BAT file in the sendto folder (check MRMAPI var is OK)
REM done



set MRMAPI="%HOME%\bin\w\Mrmapi.exe"



FOR %%A IN (%*) DO (
    echo Traite : %1 ...
    copy %%A tmp.msg
    call %MRMAPI% -MIME -Input tmp.msg -Output tmp.eml
    copy tmp.eml "%%~nA.eml"
    echo ... FIN
)

del tmp.msg
del tmp.eml

pause 

