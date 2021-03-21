#!/bin/bash

if [ $# -lt 1 ]; then
	echo "update local with remote : rcu.sh pp/prj"
else
	echo rclone sync -P onedrive:"$1" "~/$1" --exclude ".git/**"
	rclone sync -P onedrive:"$1" "~/$1" --exclude ".git/**"
fi
