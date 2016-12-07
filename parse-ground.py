#!/usr/bin/env python3

# parse the gound output
# look up the star.txt
# output a csv file

# read star.txt

# usage: <parse> /path/to/ground.txt


# stardict=dict()
# with open("star.txt", "r") as f:
#     for line in f:
#         a,b = line.split();
#         stardict[a]=b

# print(stardict)
# print(stardict['libgit2--pygit2'])
# print(stardict['answer-huang--dSYMTools'])
# print('answer-huang--dSYMTools' in stardict)

import sys
import sqlite3
conn = sqlite3.connect('json.db')
c = conn.cursor()

# header

# print('key,star,size,numoftestfile,numofdocfile,numofsrcfile,loc,totalfiledepth,totalfilect,totaldirbranching,totaldirct',end='')

            # print(key, end=',')
            # key varchar(100),
            # star integer,
            # fork integer,
            # hasdownload integer,
            # hasissue integer,
            # haswiki integer,
            # haspage integer,
            # openissue integer

header=[
    'key',
    # by json
    'star',
    'fork',
    'hasdownload',
    'hasissue',
    'haswiki',
    'haspage',
    'openissue',
    # by analyzing
    'size',
    'testfile',
    'docfile',
    'srcfile',
    'loc',
    'comment',
    'filedepth',
    'filect',
    'dirbranching',
    'dirct'
]
print(','.join(header))

# parse ground output
row=[]
with open(sys.argv[1], "r") as f:
    for line in f:
        if line.startswith("=="):
            print(','.join(row))
            row.clear()
            row=[]
            # get the key
            line=line[line.rfind('/')+1:]
            line=line[0:line.rfind(".zip")]
            key=line
            # row.append(key)
            c.execute("select * from data where key = ?", (key,))
            record = c.fetchone()
            row.extend((
                str(record[0]),
                str(record[1]),
                str(record[2]),
                str(record[3]),
                str(record[4]),
                str(record[5]),
                str(record[6]),
                str(record[7])
            ))
        else:
            if "=" in line:
                row.append(line.split('=')[1].strip())
    print(",".join(row))
