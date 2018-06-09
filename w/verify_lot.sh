#!/bin/sh

RET_VAL=0

LOT=$1

if [ "$LOT" = "" ]; then
  echo "usage : verify_lot.sh lot_name"
  exit 2;
fi

echo "\nVERIFY LOT : $LOT"

# Check that Lot_.sql contain line "SPOOL APP.log"
grep "SPOOL $LOT.log" $LOT/Lot_* >> /dev/null
if [ $? -ne 0 ]; then
  echo "Wrong format : no \"SPOOL $LOT.log\" line in Lot_.sql file"
  RET_VAL=1 
fi


Liste_Lots=`grep @@ $LOT/Lot_.sql`
for lot in $Liste_Lots
do
  # WARNING $lot contain "\r" (not \n), check position of " in the two line below
  # echo LOT = \"$lot\"
  # echo LOT = \"$lot\" | tr -d '\r'

  SUBFILE=`echo $lot | tr -d '\r' | sed 's/@@//g'`

  if [ ! -s ./$LOT/$SUBFILE ]; then
    echo le fichier ./${LOT}/${SUBFILE} indique\' dans Lot_.sql nexiste pas 
    RET_VAL=1
  fi

done
 

# on gnu sed : COMPLY_APP=`echo "$LOT" | sed 's/^[a-zA-Z_]\+[a-zA-Z0-9]*$/OK/g'`
COMPLY_APP=`echo "$LOT" | sed 's/^[a-zA-Z_][a-zA-Z0-9_-]*$/OK/g'`
if [ "$COMPLY_APP" != "OK" ]; then
  echo $LOT : 'application name does not comply with ^[a-zA-Z_]\+[a-zA-Z0-9]*$ pattern'
  RET_VAL=1
fi

if [ $RET_VAL -eq 0 ]; then
  echo FORMAT OK
else
  echo ERREUR DE FORMAT 
fi

exit $RET_VAL

