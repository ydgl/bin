#!/bin/bash


BACKUP_TMP_WORKDIR=$HOME/_running_backup
SRCDIR="$BACKUP_TMP_WORKDIR/src"
DSTDIR="$BACKUP_TMP_WORKDIR/dst"

echo $PATH
PATH=$PATH:/sbin



# $1 : mount command
# $2 : mount point
function trymount {
  retval=0
  iMount=1


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
fi

echo "create mount dir ..."
mkdir -p $SRCDIR
mkdir -p $DSTDIR



# Mount & and sync if mounts succeed ___________________________________

trymount "mount -t smbfs //guest:@mafreebox.free.fr/PLASTIK_III/" "$SRCDIR"
s=$?
trymount "mount -t smbfs //guest:@nas-adg.local/Backup" "$DSTDIR"
d=$?

if [ $(( d + s )) -eq 0 ]
then
  echo "start sync at `date`"
  rsync -a --progress --stats --delete $SRCDIR/DOC/Family $DSTDIR/DOC
  rsync -a --progress --stats --delete $SRCDIR/DOC/DG $DSTDIR/DOC
  rsync -a --progress --stats --delete $SRCDIR/DOC/Arabelle $DSTDIR/DOC
  rsync -a --progress --stats --delete $SRCDIR/DOC/Partage $DSTDIR/DOC
  rsync -a --progress --stats --delete $SRCDIR/DOC/Partage_ext $DSTDIR/DOC
  echo "end sync at `date`"
else
  echo "No sync : fail to mount one of the two directories"
fi

# Unmount , clean and exit ___________________________________________
echo  "unmounting ..."
umount $SRCDIR
umount $DSTDIR

echo "waiting for unmount ..."
sleep 10
  
echo "cleaning ..."
rmdir $DSTDIR
rmdir $SRCDIR
rmdir $BACKUP_TMP_WORKDIR

echo  end batch at `date`
