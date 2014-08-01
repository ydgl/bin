#!/bin/sh

if [ "$1" = "" ]; then
  echo "Usage updateMasterDir.sh master slave1 slave2 ..."
  echo "update master directory from slaves directories"
  echo "  slaves directories are left untouched"
  echo "Example : "
  echo "./updateMasterDir.sh AllMyPhotos import2010 import2011"

  exit 1
fi


for i ; do

  if [ "$MASTER" == "" ]; then
    MASTER=$i
    echo "mkdir $MASTER"
    mkdir -p $MASTER
  else
    echo "$i --> $MASTER"
    rsync -urt --progress "$i/" $MASTER
    
  fi


done
