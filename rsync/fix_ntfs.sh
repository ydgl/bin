#!/bin/sh 

if [ "$1" = "" ]; then
    echo "fix_ntfs.sh directory [fix]"
    echo "parse filename and suppress as follow"
    echo "     ? --> (nothing)"
    echo "     \" --> '"
    echo "     : --> (space)"
    echo "     < --> ("
    echo "     > --> )"
    exit 
fi

PARSE_DIR="$1"

if [ "$2" = "fix" ]; then
    echo "Fix : ? --> ''"
    find "$PARSE_DIR" -name "*\?*" -exec rename -v "s/\?//g" {} \;
    echo "Fix : \" --> '"
    find "$PARSE_DIR" -name "*\"*" -exec rename -v "s/\"/\'/g" {} \;
    echo "Fix : : -->  "
    find "$PARSE_DIR" -name "*\:*" -exec rename -v "s/\:/\ /g" {} \;
    echo "Fix : < --> ("
    find "$PARSE_DIR" -name "*<*" -exec rename -v "s/</\(/g" {} \;
    echo "Fix : > --> )"
    find "$PARSE_DIR" -name "*>*" -exec rename -v "s/>/\)/g" {} \;
else
    echo -n "parse $PARSE_DIR, nb files approx: "; ls -R1 "$PARSE_DIR" | wc -l
    echo -n "Fix : ? --> '' : "
    find "$PARSE_DIR" -name "*\?*" -print | wc -l
    echo -n "Fix : \" --> ' : "
    find "$PARSE_DIR" -name "*\"*" -print | wc -l
    echo -n "Fix : : -->  : "
    find "$PARSE_DIR" -name "*\:*" -print | wc -l
    echo -n "Fix : < --> ( : "
    find "$PARSE_DIR" -name "*<*" -print | wc -l
    echo -n "Fix : > --> ) : "
    find "$PARSE_DIR" -name "*>*" -print | wc -l
fi
