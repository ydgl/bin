#!/bin/bash



BACKUP_TMP_WORKDIR=$HOME/_running_backup
SRCDIR="$BACKUP_TMP_WORKDIR/src"
DSTDIR="$BACKUP_TMP_WORKDIR/dst"

PATH=$PATH:/sbin

# Crontab :
# 0 4 * * * /Users/admin/bin/backup_Darwin.sh &> /Users/admin/backup_Darwin.log

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


if [ `uname` != "Linux" ] 
then
  echo "Current batch only runs correctly on Linux"
  echo "Sudo is required"
  exit
fi





# Init ______________________________________________________________________

echo "start batch at `date`"

# get admin privileges
echo "Require sudo privilege at start"
sudo ls >> /dev/null


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

#sudo mount -t cifs -o guest,iocharset=utf8,file_mode=0777,dir_mode=0777 //mafreebox.freebox.fr/PLASTIK_III/ $SRCDIR 
trymount "sudo mount -t cifs -o guest //mafreebox.freebox.fr/PLASTIK_III/" "$SRCDIR"
s=$?
#sudo mount -t nfs -o proto=tcp,port=2049 nas-adg.local:/nfs/Backup $DSTDIR
trymount "sudo mount -t cifs -o guest //nas-adg.local/Backup" "$DSTDIR"
d=$?

if [ $(( d + s )) -eq 0 ]
then
  echo "start sync at `date`"
  echo Sync $SRCDIR/DOC/Family
  rsync -a --progress --stats --delete $SRCDIR/DOC/Family $DSTDIR/DOC
  echo Sync $SRCDIR/DOC/DG
  rsync -a --progress --stats --delete $SRCDIR/DOC/DG $DSTDIR/DOC
  echo Sync $SRCDIR/DOC/Arabelle
  rsync -a --progress --stats --delete $SRCDIR/DOC/Arabelle $DSTDIR/DOC
  echo Sync $SRCDIR/DOC/Partage
  rsync -a --progress --stats --delete $SRCDIR/DOC/Partage $DSTDIR/DOC
  echo Sync $SRCDIR/DOC/Partage_ext
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
