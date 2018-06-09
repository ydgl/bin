#!/bin/sh


RET_VAL=0
MOVE_TO=./log
TEST_MODE=0
DROP_MODE=0
DEBUG_MODE=0
RUNSQLPLUS=runsqlplus.sh
VERIFYLOT=verify_lot.sh
DROPSCHEMA=drop_schema.sh
CHECK_ERROR_PATTERN='ORA- ERROR ERREUR'
BREAK_FLAG="BREAK_ON_LIVRAISON_ERROR_FOUND"
if [ "$ULENV" = "" ]; then
  ULENV=REC1
fi



# echo or run if test mode on
eor() {
  if [ $TEST_MODE -eq 0 ]; then
    $*
  else 
   echo $*
  fi
  return $?
}

# echo if test mode on 
echot() {
  if [ $TEST_MODE -ne 0 ]; then
   echo $*
  fi
}


# Arg processing ______________________________________________________________

while getopts tdx OPT 
do
  case $OPT in
    t) TEST_MODE=1;;
    d) DROP_MODE=1;;
    x) DEBUG_MODE=1;;
  esac
done

shift `expr $OPTIND - 1`
LOT=$1
MOVE_TO=$2

if [ "$1" = "" ]; then
  echo "Usage : deploy_sql.sh [-tdx] lot_name move_to"
  echo "  Deploy SQL lot in directory \"lot_name\""
  echo "  login = lot_name/lot_name @ORACLE_SID"
  echo '  si $lot_name_DB_PASSWORD est defini il remplace le password'
  echo "  move_to error lot are stored in $move_error_ok/ERROR, successful lor are moved to $move_to/SUCCESS"
  echo "Arguments :"
  echo "  lot_name : lot to run (used for login)"
  echo "  move_to  : destination folder when success or error"
  echo "Options :"
  echo "  -t : echo command, does nothing"
  echo "  -d : drop tables in schema"
  echo "  -x : debug mode"
  echo "Exit :"
  echo "  !=0   : error"
  echo ""
  exit 1
fi

if [ "$ORACLE_SID" = "" ]; then
  echo "Instance oracle non definie"
  RET_VAL=1 
fi

if [ "$MOVE_TO" = "" ]; then
  echo "move_to parameter is missing"
  RET_VAL=1 
fi

if [ $DEBUG_MODE -ne 0 ]; then
  echo "\n"
  echo "TEST MODE = $TEST_MODE (1=ON)" 
  echo "DROP MODE = $DROP_MODE (1=ON)" 
  echo "LOT = $LOT"
  echo "MOVE TO = $MOVE_TO/SUCCESS ou $MOVE_TO/ERROR"
  echo "ENV =  $ULENV"
  echo "\n"
fi

# Check Lot Format _____________________________________________________________

$VERIFYLOT $LOT
RET_VAL=$?

# Deploy Lot ___________________________________________________________________

if [ $RET_VAL -ne 0 ]; then
  echo "ERROR exiting"
  exit $RET_VAL
fi


if [ ! -d $MOVE_TO/SUCCESS ]; then
  eor mkdir $MOVE_TO/SUCCESS
fi

if [ ! -d $MOVE_TO/ERROR ]; then
  eor mkdir $MOVE_TO/ERROR
fi

if [ $DROP_MODE -ne 0 ]; then
  eor $DROPSCHEMA $LOT
fi

eor cd "$LOT"

SQL_LOGIN=`echo $ULENV_$LOT | tr [A-Z]`
SQL_PASS=$SQL_LOGIN

 
# Check if password is defined locally in $APPLICATION_DB_PASSWORD
EXPORTED_SQL_PASS_VAR=`echo "$SQL_LOGIN" |  sed 's/-/_/g'`"_DB_PASSWORD"
echot EXPORTED_SQL_PASS_VAR=\$$EXPORTED_SQL_PASS_VAR

eval EXPORTED_SQL_PASS_VALUE=\$$EXPORTED_SQL_PASS_VAR
if [ "$EXPORTED_SQL_PASS_VALUE" != "" ]; then
  echo "var \$$EXPORTED_SQL_PASS_VAR superseed $SQL_PASS default password"
  SQL_PASS=$EXPORTED_SQL_PASS_VALUE;
fi

eor $RUNSQLPLUS $ULENV"_"$SQL_LOGIN/$ULENV"_"$SQL_PASS Lot_.sql

eor cd ..

for i in $CHECK_ERROR_PATTERN 
do
  if [ "$CHECK_ERROR_PATTERN" != "$BREAK_FLAG" ]; then
    echot check error on pattern $i
    grep "$i" $LOT/*.log >> /dev/null
    if [ $? -eq 0 ]; then
      eor mv $LOT $MOVE_TO/ERROR
      CHECK_ERROR_PATTERN=$BREAK_FLAG
    fi
  fi
done

# No error was found
if [ "$CHECK_ERROR_PATTERN" != "$BREAK_FLAG" ]; then
  eor mv $LOT $MOVE_TO/SUCCESS
fi

exit $RET_VAL

