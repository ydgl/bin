if [ $# -lt 2 ]
then
  echo "usage   : $0 last_file_version file_to_resurect"
  echo "example : $0 1.3 JdAlaUne.jsp "
	echo "process to find last version :"
	echo " 1- cvs update -r 1.1 file"
	echo " 2- cvs log file (identifiy last version in log)"
	echo " 3- run this tool"
  exit 1
fi


cvs update -r $1 $2
cp $2 $2.to_resurect
cvs update -A $2
mv $2.to_resurect $2
cvs add $2
cvs commit -m "resurected by $HOME" $2

