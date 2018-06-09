#! /usr/bin/awk -f
# Retrieve de ARV[2] first word and ARGV[3] last words of each line
BEGIN {
	if (ARGC > 2) {
		endWord = ARGV[3];
		ARGC --;
	} else {
		endWord = 0;
	}
	if (ARGC > 1) {
		beginWord = ARGV[2];
		ARGC --;
	} else {
		beginWord = 0;
	}
	if (ARGC <= 1) {
		print("Usage : delEndWord.awk fileToParse numFormerWord numTrailingWord");
		exit 1
	}
	printf("remove %d first word and %d last word\n",beginWord, endWord);
}

{
	if (beginWord <= NF-endWord) {
		for ( i = beginWord ; i <= NF-endWord ; i++) {
			printf ("%s ",$i);
		}
		printf("\n");
	} else {
		printf("#LINE TOO SHORT : %s\n",$0);
	}
}


