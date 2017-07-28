#! /bin/sh

if [ $# -lt 2 ]; then
  echo "Usage   : ./getUserSource.sh connexion_string type [pattern]"
  echo "            Retrieve source from USER_SOURCE table with matching 'pattern' passed within connecting user "
  echo "            type = t (trigger) or p (procedure)"
  echo "Example : ./getUserSource.sh acme/acme@devcdm2.world p "
  echo "            Retrieve source of procedure within acme user"
  echo "Example : ./getUserSource.sh acme/acme@devcdm2.world t "
  echo "            Retrieve source of triggers within acme user"
  echo "Example2: ./getUserSource.sh acme/acme@devcdm2.world p \"'%ALIM_CADRE%'\" "
  echo "            Retrieve source of ACME_ALIM_CADRE_PKG package within acme user"
  echo "Version : $Id: getUserSource.sh,v 1.4 2007/07/27 12:09:34 dglaurent Exp $"
  exit 1
fi
if [ "$2" = "t" ]; then
  TYPE="'%TRIGGER%'"
else
  TYPE="'%PACKAGE%'"
fi

if [ "$3" != "" ]; then
  SEARCH_PATTERN="and name like '${3}'"
fi

sqlplus -s $1 << EOF
set newpage 0
set space 0
set linesize 512
set pagesize 0
set echo off
set feedback off
set heading off
select name||','||type||','||text from user_source where type like $TYPE ${SEARCH_PATTERN} order by name,type,line;
EOF

