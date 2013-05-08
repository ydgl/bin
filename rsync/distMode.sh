#!/bin/sh

. ./rsync.src

DISTCACHEPREFIX="/media/DATA_ASUS/distcache"
REFRESHDELAY="/media/DATA_ASUS/distcache"
RNB=300
DELMODE=""


while getopts "dn:t:" opt; do
    case $opt in
        d) 
            DELMODE="del"
            echo "Delete is ON"
            ;;
        t) 
            REFRESHDELAY=$OPTARG
            ;;
        n) 
            RNB=$OPTARG
            ;;
    esac
done

shift $((OPTIND-1))

DIRLIST=$1
DISTCACHEPREFIX=$2


if [ "$DIRLIST" = "" ]; then
    echo "usage : distMode.sh [options] <sync-list> <cache-prefix>"
    echo "  Run distant synchronization following sync-list"
    echo "  Start synchronizing local with server and then refresh x times to server"
    echo "arguments:"
    echo "  sync-list    : list of directories to sync, see file for format"
    echo "  cache-prefix : dir location where local cache reside, default=$DISTCACHEPREFIX"
    echo "options:"
    echo "  n refresh nb : Default refresh nb = $RNB, "
    echo "                 0 never refresh server (only sync local cache),"
    echo "                 <0 only refresh server (no local refresh)"
    echo "  d            : delete file in local cache and then on the server"
    echo "  t delay      : delay between two refresh from local to server"
    echo "                 default value = $REFRESHDELAY"
    echo "Examples :"
    echo "  ./distMode.sh ~/sync.list /media/DATA_ASUS/distcache "
    echo "  ./distMode.sh -d -n 0 ~/sync.list /media/DATA_ASUS/distcache "
    echo "  ./distMode.sh -n 30 -d -t 300 ~/sync.list /media/DATA_ASUS/distcache"
    echo "  ./distMode.sh ~/sync.list /cygdrive/d/distcache"
    exit 
fi


if [ $RNB -ge 0 ]; then
    echo `date +"%H:%M:%S>"`init synchronization
    ./distSync.sh "$DIRLIST" "$DISTCACHEPREFIX" "master" $DELMODE
    echo `date +"%H:%M:%S>"`link directory in home
    ./linkCache.sh "$DIRLIST" "$DISTCACHEPREFIX"
fi

RNB=`echo "$RNB" | awk '{ print ($1 >= 0) ? $1 : 0 - $1}'`

# May seems ugly but avoid cron and moreover cron destruction on
# computer close.
while [ $RNB -gt 0 ]; do
    RNB=$(expr $RNB - 1)
    echo `date +"%H:%M:%S>"`push synchronization
    ./distSync.sh "$DIRLIST" "$DISTCACHEPREFIX" "local" $DELMODE
    sleep $REFRESHDELAY
done

