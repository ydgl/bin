#!/bin/sh


# mount directory
OSENV=`uname`
SRCDIR="$HOME/tmp/src"
DSTDIR="$HOME/tmp/dst"


echo create mount dir ...
mkdir -p $SRCDIR
mkdir -p $DSTDIR

# locale required to be set correctly :
# export LC_ALL=fr_FR.UTF-8  
# export LANG=fr_FR.UTF-8

echo mounting dir ...
if [ "$OSENV" = "Darwin" ]; then
  mount -t smbfs //guest:@mafreebox.free.fr/PLASTIK_III/ $SRCDIR
else
  sudo mount -t cifs //mafreebox.freebox.fr/PLASTIK_III/ $SRCDIR -o guest,iocharset=utf8,file_mode=0777,dir_mode=0777
fi

sudo mount -t nfs -o proto=tcp,port=2049 nas-adg.local:/nfs/Backup $DSTDIR

# waiting for mount OK
echo waiting for mount ...
sleep 10

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

