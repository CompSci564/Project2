
"""
FILE: skeleton_parser.py
------------------
Author: Firas Abuzaid (fabuzaid@stanford.edu)
Author: Perth Charernwattanagul (puch@stanford.edu)
Modified: 04/21/2014

Skeleton parser for CS564 programming project 1. Has useful imports and
functions for parsing, including:

1) Directory handling -- the parser takes a list of eBay json files
and opens each file inside of a loop. You just need to fill in the rest.
2) Dollar value conversions -- the json files store dollar value amounts in
a string like $3,453.23 -- we provide a function to convert it to a string
like XXXXX.xx.
3) Date/time conversions -- the json files store dates/ times in the form
Mon-DD-YY HH:MM:SS -- we wrote a function (transformDttm) that converts to the
for YYYY-MM-DD HH:MM:SS, which will sort chronologically in SQL.

Your job is to implement the parseJson function, which is invoked on each file by
the main function. We create the initial Python dictionary object of items for
you; the rest is up to you!
Happy parsing!
"""

import sys
from json import loads
from re import sub

columnSeparator = "|"

# Dictionary of months used for date transformation
MONTHS = {'Jan':'01','Feb':'02','Mar':'03','Apr':'04','May':'05','Jun':'06',\
        'Jul':'07','Aug':'08','Sep':'09','Oct':'10','Nov':'11','Dec':'12'}

"""
Returns true if a file ends in .json
"""
def isJson(f):
    return len(f) > 5 and f[-5:] == '.json'

"""
Converts month to a number, e.g. 'Dec' to '12'
"""
def transformMonth(mon):
    if mon in MONTHS:
        return MONTHS[mon]
    else:
        return mon

"""
Transforms a timestamp from Mon-DD-YY HH:MM:SS to YYYY-MM-DD HH:MM:SS
"""
def transformDttm(dttm):
    dttm = dttm.strip().split(' ')
    dt = dttm[0].split('-')
    date = '20' + dt[2] + '-'
    date += transformMonth(dt[0]) + '-' + dt[1]
    return date + ' ' + dttm[1]

"""
Transform a dollar value amount from a string like $3,453.23 to XXXXX.xx
"""

def transformDollar(money):
    if money == None or len(money) == 0:
        return money
    return sub(r'[^\d.]', '', money)

def escape_quotes(s):
    return s.replace('"', '""') if s else s

def parseJson(json_file):
    existing_users = set()

    try:
        with open('users.dat', 'r') as f:
            for line in f:
                parts = line.strip().split('|')
                user_id = parts[0]
                existing_users.add(user_id)
    except FileNotFoundError:
        pass

    with open(json_file, 'r') as f:
        items = loads(f.read())['Items']
        for item in items:
            item_id = str(item['ItemID'])
            name = escape_quotes(item['Name'])
            categories = item['Category']
            currently = transformDollar(item['Currently'])
            buy_price = transformDollar(item.get('Buy_Price', 'NULL')) if 'Buy_Price' in item else 'NULL'
            first_bid = transformDollar(item['First_Bid'])
            number_of_bids = str(item['Number_of_Bids'])
            started = transformDttm(item['Started'])
            ends = transformDttm(item['Ends'])
            description = escape_quotes(item.get('Description', 'NULL'))
            location = escape_quotes(item.get('Location','NULL')) if 'Location' in item else 'NULL'
            country = escape_quotes(item.get('Country','NULL')) if 'Country' in item else 'NULL'

            with open('categories.dat', 'a') as cat_file:
                for category in categories:
                    cat_file.write(f"\"{category}\"{columnSeparator}{item_id}\n")

            seller_id = escape_quotes(item['Seller']['UserID'])
            seller_rating = str(item['Seller']['Rating'])
            if seller_id not in existing_users:
                with open('users.dat', 'a') as user_file:
                    user_file.write(f"{seller_id}{columnSeparator}{seller_rating}{columnSeparator}\"{location}\"{columnSeparator}\"{country}\"\n")
                    existing_users.add(seller_id)

            with open('items.dat', 'a') as items_file:
                items_file.write(f"{item_id}{columnSeparator}\"{name}\"{columnSeparator}{currently}{columnSeparator}\"{description}\"{columnSeparator}{number_of_bids}{columnSeparator}{first_bid}{columnSeparator}{buy_price}{columnSeparator}{started}{columnSeparator}{ends}{columnSeparator}{seller_id}{columnSeparator}{categories}\n")

            bids = item.get('Bids', [])
            if bids:
                for bid_package in bids:
                    bid = bid_package.get('Bid', {})
                    bid_amount = transformDollar(bid.get('Amount', 'NULL'))
                    bid_time = transformDttm(bid.get('Time', 'NULL'))
                    bidder = bid.get('Bidder', {})
                    bidder_id = escape_quotes(bidder.get('UserID', 'NULL'))
                    bidder_location = escape_quotes(bidder.get('Location', 'NULL'))
                    bidder_country = escape_quotes(bidder.get('Country', 'NULL'))
                    bidder_rating = str(bidder.get('Rating', 'NULL'))

                    # Add bidder to users.dat if not already existing
                    if bidder_id not in existing_users:
                        with open('users.dat', 'a') as user_file:
                            user_file.write(f"{bidder_id}{columnSeparator}{bidder_rating}{columnSeparator}\"{bidder_location}\"{columnSeparator}\"{bidder_country}\"\n")
                            existing_users.add(bidder_id)

                    # Write bid information to bids.dat
                    with open('bids.dat', 'a') as bids_file:
                        bids_file.write(f"{item_id}{columnSeparator}\"{bidder_id}\"{columnSeparator}{bid_amount}{columnSeparator}{bid_time}\n")
        
def writeToFile(fileName, data):
    with open(f'{fileName}.dat', 'a') as f:
        f.write('|'.join(map(str, data)) + '\n')
def writeToFile(fileName, data):
    with open(f'{fileName}.dat', 'a') as f:
        f.write('|'.join(map(str, data)) + '\n')

"""
Loops through each json files provided on the command line and passes each file
to the parser
"""
def main(argv):
    if len(argv) < 2:
        print >> sys.stderr, 'Usage: python skeleton_json_parser.py <path to json files>'
        sys.exit(1)
    # loops over all .json files in the argument
    for f in argv[1:]:
        if isJson(f):
            parseJson(f)
            print (f"Success parsing {f}")

if __name__ == '__main__':
    main(sys.argv)
