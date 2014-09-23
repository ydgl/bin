#!/bin/bash


# mount directory
OSENV=`uname`
SRCDIR="$HOME/tmp/src"
DSTDIR="$HOME/tmp/dst"

# get admin privileges
sudo ls >> /dev/null

echo create mount dir ...
mkdir -p $SRCDIR
mkdir -p $DSTDIR

# locale required to be set correctly :
# export LC_ALL=fr_FR.UTF-8  
# export LANG=fr_FR.UTF-8

iMount=1
while [ $iMount -le 2 ] && [ `ls $SRCDIR | wc -l` == 0 ] 
do
  echo mount $SRCDIR try $iMount
  if [ "$OSENV" = "Darwin" ]; then
    mount -t smbfs //guest:@mafreebox.free.fr/PLASTIK_III/ $SRCDIR
  else
    sudo mount -t cifs //mafreebox.freebox.fr/PLASTIK_III/ $SRCDIR -o guest,iocharset=utf8,file_mode=0777,dir_mode=0777
  fi
  sleep 3
  (( iMount++ ))
done


iMount=1
while [ $iMount -le 2 ] && [ `ls $DSTDIR | wc -l` == 0 ] 
do
  echo mount $DSTDIR try $iMount
  # On mac os NFS mount often fail first time,and workaround did not work for me
  sudo mount -t nfs -o proto=tcp,port=2049 nas-adg.local:/nfs/Backup $DSTDIR
  sleep 3
  (( iMount++ ))
done

rsync -a --progress --stats --delete $SRCDIR/DOC $DSTDIR
#rsync -a --progress --stats --delete $SRCDIR $DSTDIR
#rsync -a --progress --stats --delete $SRCDIR $DSTDIR


echo unmounting ...
sudo umount $SRCDIR
sudo umount $DSTDIR

echo waiting for unmount ...
sleep 10

echo cleaning ...
rmdir $DSTDIR
rmdir $SRCDIR
rmdir "$HOME/tmp"

date
