#!/bin/sh

if [ $# -lt 1 ]; then
  echo "usage   : cccp classpath"
  echo "          convert absolute unix classpath in windows absolute classpath to run on windows java within cygwin"
  echo "          Convert Cygwin ClassPath"
  echo "example : ./cccp.sh '/cygdrive/a/b/c/myjar.jar:/export/d/b/c/my2jar.jar'"
  echo 'example : java -cp `cccp.sh $CLASSPATH` ...'
  exit 1
fi 

uname | grep "CYGWIN" >/dev/null
PLT=$?

if [ $PLT -eq 0 ]; then
  # CYGWIN
  echo $1 | sed 's/jar:/jar;/g' | sed 's/\/cygdrive\/\(.\)/\1:/g' | sed 's/\//\\/g' | sed 's/:\(.\):/;\1:/g'
else
  echo $1
fi



