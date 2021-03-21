#!/bin/bash

if [ $# -lt 1 ]; then
	echo "commit to remote : rcc.sh pp/prj"
else
	echo rclone sync -P ~/$1 onedrive:"$1" --exclude ".git/**"
 	rclone sync -P ~/$1 onedrive:"$1" --exclude ".git/**"
fi
