#!/bin/sh

if [ "$1" = "" ]; then
  echo "usage : rml.sh link_name"
  exit
fi

OS_NAME=`uname -o` 

if [ "$OS_NAME" = "Cygwin" ]; then
  ARG1=`cygpath -w $1`
  cmd /c rd "$ARG1"
else
  eval ARG1=$1
  rm -f "$ARG1" 
fi
