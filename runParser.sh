#!/bin/bash
rm -f *.dat
python3 skeleton_parser.py ebay_data/items-*.json

# input_file="users.dat"
# temp_file="${input_file}.tmp"

# # Use awk to remove duplicate lines based on the first field
# awk -F '|' '!seen[$1]++' $input_file > $temp_file

# # Move the temporary file back to the original file
# mv $temp_file $input_file

# input_file="categories.dat"
# temp_file="${input_file}.tmp"

# # Use awk to remove duplicate lines based on the first and second fields
# awk -F'|' '!seen[$1, $2]++' $input_file > $temp_file

# # Move the temporary file back to the original file
# mv $temp_file $input_file

remove_duplicates() {
  local input_file="$1"
  local temp_file="${input_file}.tmp"

  # Use awk to remove duplicate lines based on the first and second fields
  awk -F'|' '!seen[$1, $2]++' "$input_file" > "$temp_file"

  # Move the temporary file back to the original file
  mv "$temp_file" "$input_file"
}

# Process each specified file
for file in "users.dat" "categories.dat";
do
  remove_duplicates "$file"
done

rm *.db
sqlite3 ebay.db < create.sql
sqlite3 ebay.db < load.txt

rm *.dat

for i in {1..7}
do
    sqlite3 ebay.db  ".read query$i.sql"
done

rm *.db