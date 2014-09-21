#!/bin/sh

OSENV=`uname`
SRCDIR="$HOME/tmp/src"
DSTDIR="$HOME/tmp/dst"


echo create $SRCDIR
mkdir -p $SRCDIR

echo create $DSTDIR
mkdir -p $SRCDIR

# locale required to be set correctly :
# export LC_ALL=fr_FR.UTF-8  
# export LANG=fr_FR.UTF-8

if [ "$OSENV" = "Darwin" ]; then
  mount -t smbfs //guest:@mafreebox.free.fr/PLASTIK_III/ $SRCDIR
else
  sudo mount -t cifs //mafreebox.freebox.fr/PLASTIK_III/ $SRCDIR -o guest,iocharset=utf8,file_mode=0777,dir_mode=0777
fi

sudo mount -t nfs -o proto=tcp,port=2049 nas-adg.local:/nfs/Backup $DSTDIR

#rsync -a --progress --stats --delete $SRCDIR $DSTDIR

sudo umount $SRCDIR
sudo umount $DSTDIR

sleep 30

rmdir $DSTDIR
rmdir $SRCDIR
rmdir ~/tmp

