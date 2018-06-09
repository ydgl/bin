#! /usr/bin/gawk -f

function usage() {
  print "Usage  : ./formatSource.awk [--makelot [filename]] [--keeptab] [--nocvs] --mode t|p file "
  print "     format raw trigger or procedure source code to sql script"
  print "         makelot : generate lot file with filename, default filename is Lot_.sql"
  print "         nocvs   : cvs not added"
  print "         keeptab : by default tab are replaced by 4 space"
  print "         mode    : formatting mode t=triggers, p=procedures"
  print "         file    : 3 fields csv file of sql source, formatted as follow"
  print "           field1 = USER_SOURCE.NAME"
  print "           field2 = USER_SOURCE.TYPE"
  print "           field3 = USER_SOURCE.TEXT"
  print "Example for whole package of one user :"
  print "     ./getUserSource.sh \"'%PACKAGE%'\" acme/acme@devcdm2.world | ./formatSource.awk --mode p "
  print "Example for one package of one user :"
  print "     ./getUserSource.sh \"'%ALIM_CADRE%'\" acme/acme@devcdm2.world | ./formatSource.awk --mode p --makelot"
  print "Example for whole triggers of one user :"
  print "     ./getUserSource.sh \"'%TRIGGER%'\" acme/acme@devcdm2.world | ./formatSource.awk --mode t --makelot"
  print "WARNING"
  print "- gawk (gnu awk),or compatible, must be installed as /usr/bin/gawk"
  print "  if nawk installed (solaris case) : ln -s /usr/bin/gawk /usr/bin/nawk"
  print " "
  print "Version : $Id: formatSource.awk,v 1.6 2009/11/17 14:13:38 dglaurent Exp $"
}

# "file" handler will be changed ==> file must be close before calling this function
function cvsVersion(file) {
  tmpFile="."file".tmp"
  while ((getline newdata < file) > 0) {
    print newdata > tmpFile
    bInsert = 0
		iPattIdx = 1

		# identify if location to insert Id is reached based on previous line
		# and current line
		for (iPat in g_cvsPattern) {
      if ((newdata == g_cvsPattern[iPat]) && (previous_line ~ /CREATE OR REPLACE*/)) {
        bInsert = 1
      }

      if ((newdata ~ g_cvsPattern[iPat]) && (newdata ~ /CREATE OR REPLACE*/)) {
        bInsert = 1
      }

      if (g_mode == "t") {
        if (newdata ~ g_cvsPattern[iPat])  {
          # for triggers only we accept single occurence of BEGIN
          bInsert = 1
        }
      }
		}

    if (bInsert == 1) {
      insScript_Log = insScript_Log" added"
      # 1-do not retrieve "" to fool cvs (cvs will not change $""Id""$ on commit)
			# 2-store in newdata otherwise previous_line will be false on next loop
			newdata = "-- Version CVS : $""Id""$" 
      print newdata > tmpFile
    }
    previous_line=newdata
  }
  close(tmpFile)
  close(file)
  system("mv "tmpFile" "file)
}

# The 3 insScriptXXX function share globals that begin by insScript_

# insert create or replace
function insScriptCOR(line, file, bNewScript) {
  if (bNewScript != 0) {
    insScript_Log = " "file" \t "
		insScript_Corrupted = 0
  } 
	if (insScript_Corrupted == 0) {
    print "CREATE OR REPLACE",line > file 
	}
  
}

# insert line
function insScriptLine(line, file) {
	if (insScript_Corrupted == 0) {
    #check for cvs tag occurence
    if (line ~ /\$Id/) {
      insScript_CVS = 1
    }

    print line > file
  }
}

# finalize sql script
function insScriptEnd(file) {
	if (insScript_Corrupted == 0) {
    print "/" > file
    close(file)
    insScript_Log = insScript_Log" [saved]"
    if (insScript_CVS == 0) {
      insScript_Log = insScript_Log" [cvs version"
      cvsVersion(file)
      insScript_Log = insScript_Log"]"
    }
    if (g_makelot == 1) {
      print "PROMPT create or replace "file > g_lotFile
      print "@@"file > g_lotFile
      print "show error" > g_lotFile
      print "\n" > g_lotFile
      insScript_Log = insScript_Log" ["g_lotFile" call]"
    }
	}
  print insScript_Log
  insScript_Log=""
}

function insScriptBreak(message) {
	if (insScript_Corrupted == 0) {
	  insScript_Log = insScript_Log"\n\t###################\n\t !!"message"!!\n\t###################\n"
	  insScript_Corrupted = 1
	}
}

BEGIN {
  
  # Init ______________________________________________________________________
  g_makelot = 0;
  g_lotFile = "Lot_.sql"
  g_mode = "" # Formatting mode (p or t)
  keeptab = 0;
  isUsage = 0;
  FS=","
  currentSqlFile = ""
  oldTO = ""
	g_debugMode = 0;

    # insScript Globals ____________________
    insScript_new = 1  # indicate if new script entered
    insScript_CVS = 0  # indicate if CVS version is present in script
    insScript_Log = "" # log message relative to current script to write
		insScript_Corrupted = 0 # Script is corrupted
    # insScript Globals end ________________
  
  # Argument handling ____________________________________________________
  i = 1
  if (ARGC < 2) {
    usage();
    isUsage=1;
    exit 1;
  }
  while (ARGV[i] != null) {

    if (ARGV[i] == "--makelot") {
      g_makelot = 1;
      ARGV[i]=""
      # g_lotFile already initialized
      if (ARGV[i+1] !~ /\-\-*/) {
				g_lotFile = ARGV[i+1]
        ARGV[i+1]= ""
        i++
      } 
    }

    if (ARGV[i] == "--nocvs") {
      insScript_CVS = 1;
      ARGV[i]=""
    }

    if (ARGV[i] == "--keeptab") {
      keeptab = 1;
      ARGV[i]=""
    }
    
    if (ARGV[i] == "--mode") {

      if (ARGV[i+1] == "p") {
        g_cvsPattern[1] = "IS"
        g_cvsPattern[2] = "AS"
        g_mode = ARGV[i+1]
        ARGV[i]="";
      }

      if (ARGV[i+1] == "t") {
        g_cvsPattern[1] = "BEGIN"
        g_mode = ARGV[i+1]
        ARGV[i]="";
      }
      if (g_mode != "") {
        ARGV[i+1]="";
        i++;
      }
    }

    if (ARGV[i] == "--debug") {
			g_debugMode = 1;
      ARGV[i]="";
    }

    i++;
  }

  print " "
}

{
  obj_name = $1
  type = $2
  end_of_line=$3

  # merge $3-->$*
  i = 3
  while (i++ < NF) {
    end_of_line = end_of_line","$i
  }

  if (keeptab == 0) {
    # replace tabs by 4 spaces
    gsub(/\t/,"    ",end_of_line)
  }

	# Field validation _________________________________________________________
	if (g_debugMode > 0) {
	  print "1: "$1
	  print "2: "$2
	  print "3: "$3
	}

	fieldValid = 0
	switch(g_mode) {
		case "t" :
      if (type ~ /TRIGGER/) fieldValid=1
		case "p" :
      if (type ~ /PACKAGE*/) fieldValid=1
  }		

	if (fieldValid != 0) {
		#print "process"
	  # Process fields _________________________________________________________
		newTO = type obj_name
		
		if (newTO != oldTO) {
      newSqlFile = ""

			if (currentSqlFile != "") {
				# finalize old script
				insScriptEnd(currentSqlFile)
			}

			# Identify output filename depending on object type
			switch (type) {
				case "PACKAGE" :
				  newSqlFile = tolower(obj_name)".pks"
					break
				case "PACKAGE BODY" :
				  newSqlFile = tolower(obj_name)".pkb"
       		break
				case "TRIGGER" :
				  newSqlFile = tolower(obj_name)".trg"
          break
				default :
				  newSqlFile = tolower(obj_name)".unknown_sql_type"

			}


			currentSqlFile = newSqlFile

			insScriptCOR(end_of_line,currentSqlFile,insScript_Log == "")

			oldTO = newTO

		} else {

			insScriptLine(end_of_line,currentSqlFile)

		} 
	} else {
	  # Indicate error
	  insScriptBreak("input format is corrupted");
  }
}

END {
  if (isUsage == 0) {
    insScriptEnd(currentSqlFile)
    print " "
    if (g_makelot == 1) {
      print g_lotFile" file generated"
    }
    print "\nTo update a object use :"
    print "sqlplus user/login@connect_string @file.sql"
  }
}

