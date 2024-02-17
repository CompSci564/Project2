#!/bin/bash
rm -f *.dat
python3 skeleton_parser.py ebay_data/items-*.json

sqlite3 ebay.db < create.sql
sqlite3 ebay.db < load.txt