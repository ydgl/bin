#!/bin/sh

. ./rsync.src

if [ "$1" = "" ]; then
    echo "usage : synCache.sh <synclist> <distcacheprefix> <master|local> [del]"
    echo " synchronize list of directories with rsync in two ways "
    echo "     local cache --> master server"
    echo "  or local cache <-- master server"
    echo " options : synclist list of directory to sync"
    echo "           distcacheprefix local cache directory"
    echo "           master source is master (master --> local)"
    echo "           local source is local (local --> master)"
    echo "           del : file removed in source are deleted in destination"
    echo " examples :"
    echo "    ./synCache ~/sync.list /media/DATA_ASUS/distcache master del"
    echo "    ./synCache ~/sync.list /media/DATA_ASUS/distcache local del"
    echo "    ./synCache ~/sync.list /cygdrive/d/distcache local del"
    exit 
fi

SYNC_LIST=$1
DISTMOUNTPREFIX=$2
SYNCDIRECTION=$3

if [ "$4" = "del" ]; then
    DELMODE="--del"
else
    DELMODE=""
fi

if [ ! -e "$DIST_SYNCHRO_LOCK" ]; then
    touch "$DIST_SYNCHRO_LOCK"

    i=""
    file_line_iterator $SYNC_LIST i
    while next_line ; do
	if  echo $i | egrep -qv '^#'
	then 
	    SRC_USER=`echo "$i" | cut -d: -f1` 
	    SRC_PATH=`echo "$i" | cut -d: -f2` 
	    LOC_DIR=`echo "$i" | cut -d: -f3`
	    SRC_DIR=`echo "$i" | cut -d: -f4`
	    DST_DIR=`echo "$i" | cut -d: -f5`

            #echo $SRC_USER / $SRC_PATH / $LOC_DIR / $SRC_DIR / $DST_DIR
	    
	    CACHE_DIR="${DISTMOUNTPREFIX}/${LOC_DIR}"

            if [ ! -e $CACHE_DIR ]; then
                mkdir $CACHE_DIR
            fi


	    if [ "$SYNCDIRECTION" = "local" ]; then
		echo `date +"%H:%M:%S>"`"pushing $DST_DIR --> $SRC_DIR"
		rsync -urt $DELMODE --progress --rsh=ssh """${CACHE_DIR}/${SRC_DIR}""" "$SRC_USER@$HOST_DIST:\"$SRC_PATH/\""
	    fi

	    if [ "$SYNCDIRECTION" = "master" ]; then
		echo `date +"%H:%M:%S>"`"pulling $SRC_DIR --> $DST_DIR"
		rsync -urt $DELMODE --progress --rsh=ssh "$SRC_USER@$HOST_DIST:\"$SRC_PATH/$SRC_DIR\"" "$CACHE_DIR"  
	    fi
	fi
    done
    rm "$DIST_SYNCHRO_LOCK"
else
    echo `date +"%H:%M:%S>"`"Synchro already running see lock file : $DIST_SYNCHRO_LOCK"
fi
