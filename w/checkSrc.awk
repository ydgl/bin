#! /usr/bin/awk -f
# Created : Denis-Gilles Laurent / 08/10/2002
# Usage : checkLinks.awk html_to_parse
# 				output XXX everytime [space]src="XXX"[space] found

{
	for ( i = 1; i < NF ; i++) {
		# if first word in line begins by : 
		#  (begin_of_line)+'V'+set of following character: 1234567890-
		if ($i ~ /^src=\"/) { 

			# if first word in line ends by : 
			#  ':'+(end_of_word)
			if ($i ~ /\"$/) {
				print substr($i,6,length($i)-6);
			}
		}
	}
}


