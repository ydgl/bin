#!/bin/sh

. ./rsync.src

if [ "$2" = "" ]; then
    echo "usage : localInit.sh <sync.list> <mount-dir-prefix>"
    echo "  mount src path in <sync.list> as <mount-dir-prefix>/<src path>"
    echo "option:"
    echo "  <sync.list> : list of directory to mount"
    echo "  <mount-dir-prefix> : prefix for local-folder mount point"
    echo " examples"
    echo "   ./localInit.sh ./sync.list .localmount"
    echo "   ./localInit.sh ~/sync.list /cygdrive"
    exit 
fi

SYNC_LIST=$1
LOCALMOUNTPREFIX="$2"
OS_NAME=`uname -o`

# src_path contient "/shares/", mais src_path n'est pas exposé
# comme par exemple dans /shares/Doc_DG ... c Doc_DG qui est le nom de partage
# pour l'intant on le vire du fichier sync.list
i=""
file_line_iterator $SYNC_LIST i
while next_line ; do
    SRC_USER=`echo "$i" | cut -d: -f1` 
    SRC_PATH=`echo "$i" | cut -d: -f2` 
    LOC_DIR=`echo "$i" | cut -d: -f3`
    SRC_DIR=`echo "$i" | cut -d: -f4`
    DST_DIR=`echo "$i" | cut -d: -f5`


    echo $SRC_USER / $SRC_PATH / $LOC_DIR / $SRC_DIR / $DST_DIR
    
    MOUNT_DIR="${LOCALMOUNTPREFIX}/${LOC_DIR}"
    
    if [ "$OS_NAME" = "Cygwin" ]; then

	SOURCE_DIR="//$HOST_LOCAL/$SRC_PATH"

	AR1=`echo "$SOURCE_DIR" | sed 's/\.local//g' | sed 's/\\//\\\\/g'`
	AR2=`cygpath -w "$MOUNT_DIR" | sed 's/\\\\$//g'` 
	
        cmd /c net use "$AR2" &> /dev/null

	if [ $? -ne 0 ]; then
	    echo `date +"%H:%M:%S>"` use "$AR1 --> $AR2 as $SRC_USER"
	    echo `date +"%H:%M:%S>"`" enter password for $SRC_USER :" 

	    if read SMB_PASS
	    then
                #cmd /c net use "$AR2" /DELETE
		cmd /c net use "$AR2" "$AR1" $SMB_PASS /USER:$SRC_USER
		echo ici
	    fi
	fi

    else
        # If mount directory is not mounted
	mount -l | grep "$MOUNT_DIR" >> /dev/null
	if [ $? -ne 0 ]; then
	    # If mount target does not exists
	    if [ ! -d "$MOUNT_DIR" ]; then
		echo `date +"%H:%M:%S>"`create directory $MOUNT_DIR
		mkdir "$MOUNT_DIR"
	    fi
	    echo `date +"%H:%M:%S>"` mount "//$HOST_LOCAL/$SRC_PATH --> $MOUNT_DIR as $SRC_USER"
	    sudo smbmount //$HOST_LOCAL/$SRC_PATH "$MOUNT_DIR" -o username=$SRC_USER
	fi
    fi
done




