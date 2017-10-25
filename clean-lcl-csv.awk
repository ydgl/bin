#! /usr/bin/awk -f
# Created : Denis-Gilles Laurent / 24/10/2017
# Usage : tr.awk cc.xls
# 
BEGIN {
 FS = "\t"
} ;

{
    printf "date valeur : %s", $1;
    printf " / montant : %s", $2;
    printf " / carte/chèque/virement : %s", $3;
    printf " / #chèque : %s", $4;
    printf " / beneficiaire : %s\n", $5;
    
# # 	# for ( i = 1; i < NF ; i++) {
# # 	# 	# if first word in line begins by : 
# # 	# 	#  (begin_of_line)+'V'+set of following character: 1234567890-
# # 	#     printf $i;
# # #        if ($i ~ /^src=\"/) { 
# # #
# # 		# 	# if first word in line ends by : 
# # 		# 	#  ':'+(end_of_word)
# # 		# 	if ($i ~ /\"$/) {
# # 		# 		print substr($i,6,length($i)-6);
# # 		# 	}
# # 		# }
	# }
}


