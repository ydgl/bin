#!/bin/sh

. ./rsync.src

if [ "$1" = "" ]; then
    echo "usage : linkCache.sh <sync.list> <mount-dir-prefix>"
    echo " link dir mount in <mount-dir-prefix>... as specified <sync.list>"
    echo " ex : ./linkCache.sh ./sync.list \"/mnt/media/DATA_ASUS/.distcache\""
    echo " ex : ./linkCache.sh ./sync.list \"\$HOME/.localmount\""
    exit
fi

OS_NAME=`uname -o`

if [ "$OS_NAME" = "Cygwin" ]; then
    id | grep 544 >> /dev/null
    if [ $? -ne 0 ]; then
        echo `date +"%H:%M:%S>"` "il faut lancer la commande en admin sur windows"
        exit 1
    fi
fi

SYNC_LIST=$1
MOUNTPREFIX=`echo $2 | sed 's/\/$//g'`


cat $SYNC_LIST | while read i
do
    if  echo $i | egrep -qv '^#'
    then 
	SRC_USER=`echo "$i" | cut -d: -f1` 
	SRC_PATH=`echo "$i" | cut -d: -f2` 
	LOC_DIR=`echo "$i" | cut -d: -f3`
	SRC_DIR=`echo "$i" | cut -d: -f4`
	DST_DIR=`echo "$i" | cut -d: -f5`
	
        #echo $SRC_USER / $SRC_PATH / $LOC_DIR / $SRC_DIR / $DST_DIR

	eval DST_DIR="${DST_DIR}"
	echo linking $DST_DIR

	MOUNT_DIR="${MOUNTPREFIX}/${LOC_DIR}"

	./rml.sh "$DST_DIR"
	./mkl.sh "$MOUNT_DIR/$SRC_DIR" "$DST_DIR"
    fi
done



