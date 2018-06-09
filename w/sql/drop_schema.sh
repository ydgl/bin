#!/usr/bin/sh

# Test des parametres__________________________________________________Debut___
USAGE='$1 USER $2 PASSWORD '
ULENV=REC1
USER=$ULENV"_"$1
PASSWD=$2
if [ "$USER" = "" ] # chaine connexion  non saisie
then
        echo $USAGE
        exit 1
fi
if [ "$PASSWD" = "" ] # chaine connexion  non saisie
then
        PASSWD=$USER
fi

sqlplus -s /nolog << FIN
SET verify off  feedback off  heading off echo off  pagesize 0 linesize 300
connect $USER/$PASSWD

SPOOL drop_schema_$USER.sql
prompt spool drop_schema_$USER.log
SELECT      'alter table '
         || table_name
         || ' drop constraint '
         || constraint_name
         || ' cascade;'
    FROM user_constraints
   WHERE (constraint_type = 'R')
ORDER BY table_name, constraint_name;

SELECT DISTINCT    'DROP '
                || object_type
                || ' '
                || object_name
                || ';'
           FROM user_objects
          WHERE (object_type NOT IN ('TRIGGER','INDEX','LOB'));
          
         
SPOOL off
prompt spool off
SET newpage 1

@"drop_schema_$USER.sql"

exit;
FIN

rm drop_schema_$USER.*
exit
