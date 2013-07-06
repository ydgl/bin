#!/bin/sh

. ./rsync.src

if [ "$1" = "" ]; then
    echo "usage : distClean.sh <sync.list> [distcacheprefix]"
    echo " remove link to <distcacheprefix>... following <sync.list>"
    echo " remove <distcacheprefix> if specified"
    echo " ex : ./distClean.sh ~/sync.list .distcache"
    echo " ex : ./distClean.sh ~/sync.list"
    exit 
fi

SYNC_LIST=$1
DISTMOUNTPREFIX=$2

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

	echo `date +"%H:%M:%S>"`remove link "$DST_DIR"
	./rml.sh "$DST_DIR"
	
        if [ "${DISTMOUNTPREFIX}" = "" ]; then
	    CACHE_DIR="${DISTMOUNTPREFIX}/${LOC_DIR}"

	    if [ -d "$CACHE_DIR" ]; then
		echo `date +"%H:%M:%S>"`remove directory $CACHE_DIR
		rmdir -r "$CACHE_DIR"
	    fi
	fi

    fi
done
