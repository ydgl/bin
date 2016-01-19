#!/bin/bash


BACKUP_TMP_WORKDIR=$HOME/_running_backup
SRCDIR="$BACKUP_TMP_WORKDIR/src"
#DSTDIR="$BACKUP_TMP_WORKDIR/dst"
DSTDIR="/Volumes/PLASTIK_IV"
SRC_MOUNT_COMMAND="mount -t smbfs //guest:@mafreebox.free.fr/PLASTIK_III/"
DST_MOUNT_COMMAND="mount -t smbfs //guest:@nas-adg.local/Backup"


PATH=$PATH:/sbin

# Crontab :
# 0 4 * * * /Users/admin/bin/backup_Darwin.sh &> /Users/admin/backup_Darwin.log

# $1 : mount command
# $2 : mount point
function trymount {
  retval=0
  iMount=1


  mkdir -p $2

  while [ $iMount -le 2 ] && [ `ls $2 | wc -l` == 0 ]
  do
    echo $iMount try $2
    $1 $2
    retval=$?
    sleep 3
    (( iMount++ ))
  done

  if [ $retval -ne 0 ] 
  then
    echolog "unable to mount $2, return $retval"
  fi

  return $retval
}


function tryumount {
    umount $1
    echo "waiting for unmount ..."
    sleep 10
    rmdir $1
}



if [ `uname` != "Darwin" ] 
then
  echo "Current batch only runs correctly on Mac OS"
  echo "Locale must be set accordingly:"
  echo "> export LC_ALL=fr_FR.UTF-8"
  echo "> export LANG=fr_FR.UTF-8"
  exit
fi


# Init ______________________________________________________________________

echo "start batch at `date`"

# Check for backup already running and create mount point 
if [ ! -e "$BACKUP_TMP_WORKDIR" ]
then
    mkdir -p $BACKUP_TMP_WORKDIR
    #if [ $? -ne 0 ] then exit fi
else
    echo "Backup is already running"
    exit
fi


# Mount & and sync if mounts succeed ___________________________________

trymount "$SRC_MOUNT_COMMAND" "$SRCDIR"
s=$?
#trymount "$DST_MOUNT_COMMAND" "$DSTDIR"
d=$?


if [ $(( d + s )) -eq 0 ]
then
  echo "start sync at `date`"
  echo Sync $SRCDIR/DOC/Family
  rsync -a --progress --stats --delete $SRCDIR/DOC/Family $DSTDIR/DOC
  #echo Sync $SRCDIR/DOC/DG
  #rsync -a --progress --stats --delete $SRCDIR/DOC/DG $DSTDIR/DOC
  #echo Sync $SRCDIR/DOC/Arabelle
  #rsync -a --progress --stats --delete $SRCDIR/DOC/Arabelle $DSTDIR/DOC
  #echo Sync $SRCDIR/DOC/Partage
  #rsync -a --progress --stats --delete $SRCDIR/DOC/Partage $DSTDIR/DOC
  #echo Sync $SRCDIR/DOC/Partage_ext
  #rsync -a --progress --stats --delete $SRCDIR/DOC/Partage_ext $DSTDIR/DOC
  #echo Sync $SRCDIR/FILMS/1-DESSINS ANIMES
  #rsync -a --progress --stats --delete $SRCDIR/FILMS/1-DESSINS_ANIMES $DSTDIR/FILMS
  #echo "end sync at `date`"
else
  echo "No sync : fail to mount one of the two directories"
fi

# Unmount , clean and exit ___________________________________________
echo  "unmounting ..."
tryumount $SRCDIR
#tryumount $DSTDIR

rmdir $BACKUP_TMP_WORKDIR

echo  end batch at `date`
