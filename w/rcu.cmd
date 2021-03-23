@echo off

if "%1"=="" (
	@echo "update local with remote : rcu.sh pp/prj"
	goto :end
)

@echo rclone sync -P onedrive:"%1" "%HOME%\%1" --exclude ".git/**"
rclone sync -P onedrive:"%1" "%HOME%\%1" --exclude ".git/**"

:end