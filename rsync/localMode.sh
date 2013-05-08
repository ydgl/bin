#!/bin/sh

. ./rsync.src

LOCALMOUNTPREFIX="$HOME/.localmount"

if [ "$1" = "" ]; then
    echo "usage : localMode.sh <start|stop> <sync-list> [mount-dir]" 
    echo "  Install local mount point as specified in <sync-list>"
    echo "options:"
    echo "  sync-list: list of diorectories to sync, check file for format"
    echo "  mount-dir: mounting point of remote directory,default = $LOCALMOUNTPREFIX"
    echo "examples:"
    echo "   ./localMode.sh start ~/sync.list"
    echo "   ./localMode.sh start ~/sync.list /cygwin"
    exit 
fi

RUNMODE=$1
DIRLIST=$2
if [ "$3" != "" ]; then
    LOCALMOUNTPREFIX=$3
fi

if [ "$RUNMODE" = "start" ]; then
    if ping -q -c 2 $HOST_LOCAL >> /dev/null; then
	echo `date +"%H:%M:%S>"` mount nas
	./localInit.sh "$DIRLIST" "$LOCALMOUNTPREFIX"
	echo `date +"%H:%M:%S>"` link directory in home
	./linkCache.sh "$DIRLIST" "$LOCALMOUNTPREFIX"
    fi
fi

if [ "$RUNMODE" = "stop" ]; then
    echo `date +"%H:%M:%S>"` un-mounting nas
    ./localClean.sh "$DIRLIST" "$LOCALMOUNTPREFIX"
fi




