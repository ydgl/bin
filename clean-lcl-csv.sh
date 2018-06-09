#!/usr/bin/bash


newfile="${1%.*}.csv"
echo "clean $1 to $newfile"

# Convert to UTF-8 and clean
iconv -f ISO-8859-1 -t UTF-8 $1 | clean-lcl-csv.awk > $newfile

# Remove last line
sed -i '$ d' $newfile
