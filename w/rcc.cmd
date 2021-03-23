@echo off

if "%1"=="" (
	echo "commit to remote : rcc.sh pp/prj"
	goto :end
)

@echo rclone sync -P "%HOME%\%1" onedrive:"%1" --exclude ".git/**"
rclone sync -P "%HOME%\%1" onedrive:"%1" --exclude ".git/**"

:end

