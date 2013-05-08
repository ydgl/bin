#!/bin/sh

if [ "$1" = "" ]; then
  echo "usage : mkl.sh cible link_name"
  exit
fi

OS_NAME=`uname -o` 

if [ "$OS_NAME" = "Cygwin" ]; then
  #cmd /c mklink "tc-DG\\bin.master" toto
  # il faudra sans doute faire un cygdrive
  ARG1=`cygpath -w "$1"`
  ARG2=`cygpath -w "$2"`
  echo cmd mklink "$ARG2" "$ARG1"
  cmd /c mklink /D "$ARG2" "$ARG1"
  # pour parer des répertoire locké par cygwin eventuellement
  # On accorde tous les droits aux utilisateurs connectés
  #cmd /c cacls "$ARG1" /T /E /G Utilisateurs:C
else
  ln -s "$1" "$2"
fi
