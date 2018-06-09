RED=`tput setaf 1` 
GREEN=`tput setaf 2`
#WHITE=`tput setaf 7`
ResetColor=`tput sgr0`

echo ""
echo -e "\033[4mIP Address      Status          Server Name \033[0m"

for i in {1..253}
do

	echo -en "10.1.10.$i \t"
	result_ping=`ping -c 1 10.1.10.$i`

	if [ $? = 0 ]; then
		echo -en "${GREEN}Reacheable \t${ResetColor}"
	else
		echo -en "${RED}Not reacheable\t${ResetColor}"
	fi

	result_nslookup=`nslookup 10.1.10.$i | tail -2 | head -1`
	result_ns=`echo "$result_nslookup" | cut -d' ' -f 1`

	if [ "$result_ns" = "**" ]; then
	        echo "${RED}Unknown ${ResetColor}"
	else
		server_name=`echo "$result_nslookup" | cut -d' ' -f 3`
		echo `expr $server_name : "\(.*\).$"`

	fi

done

