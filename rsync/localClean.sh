#!/bin/sh
. ./rsync.src

if [ "$2" = "" ]; then
    echo "usage : localClean.sh <sync.list> <mount-dir-prefix>"
    echo " unmount src path in <sync.list> as <mount-dir-prefix>-<src path>"
    echo " ex : ./localClean.sh ./sync.list .localmount"
    exit 
fi

SYNC_LIST=$1
LOCALMOUNTPREFIX=`echo $2 | sed 's/\/$//g'`

# src_path contient "/shares/", mais src_path n'est pas exposé
# comme par exemple dans /shares/Doc_DG ... c Doc_DG qui est le nom de partage
# pour l'intant on le vire du fichier sync.list


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

	MOUNT_DIR="${LOCALMOUNTPREFIX}/${LOC_DIR}"
        
        if [ "$OS_NAME" = "Cygwin" ]; then
            echo "ne fonctionne pas sous cygwin"
        else
        # If mount directory is not mounted
	    mount -l | grep "$MOUNT_DIR" >> /dev/null
	    if [ $? -eq 0 ]; then
	        echo `date +"%H:%M:%S>"`unmount "$MOUNT_DIR"
	        sudo umount "$MOUNT_DIR"
	    fi

	    eval DST_DIR="${DST_DIR}"
	    echo `date +"%H:%M:%S>"`clean "$DST_DIR"
	    rm -f $DST_DIR

        fi
    fi
done




