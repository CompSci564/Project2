#!/bin/bash
rm -f *.dat
python3 skeleton_parser.py ebay_data/items-*.json

input_file="users.dat"
temp_file="${input_file}.tmp"

# Use awk to remove duplicate lines based on the first field
sort -k1,1 -k2,2 $input_file | awk '!seen[$1]++' $input_file > $temp_file

# Move the temporary file back to the original file
mv $temp_file $input_file

input_file="categories.dat"
temp_file="${input_file}.tmp"

# Use awk to remove duplicate lines based on the first and second fields
sort -k1,1 -k2,2 $input_file | awk -F'|' '!seen[$1, $2]++' $input_file > $temp_file

# Move the temporary file back to the original file
mv $temp_file $input_file

rm *.db
sqlite3 ebay.db < create.sql
sqlite3 ebay.db < load.txt

sqlite3 ebay.db < query1.sql
sqlite3 ebay.db < query2.sql
sqlite3 ebay.db < query3.sql
sqlite3 ebay.db < query4.sql
sqlite3 ebay.db < query5.sql
sqlite3 ebay.db < query6.sql
sqlite3 ebay.db < query7.sql