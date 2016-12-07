#!/usr/bin/env python3

"""
extract repo addresses from json files
Just run the script.
It will parse the file c-[1-10].json.
The output will be printed to the standard output.
Write it to a file.

Usage:
<script> /path/to/json /path/to/json ...
"""

import json
import sys
import os
import sqlite3

if __name__ == '__main__':
    # the 0 is the same as 1
    # the valid data is from 1 to 10
    # file names are from argv[1:]

    os.system("rm json.db")
    conn = sqlite3.connect('json.db')
    c = conn.cursor()
    c.execute('''create table data (
      key varchar(100),
      star integer,
      fork integer,
      hasdownload integer,
      hasissue integer,
      haswiki integer,
      haspage integer,
      openissue integer
    )
    ''')

    repofile=open("repo.txt", "w")
    # starfile=open("star.txt", "w")
    # forkfile=open("fork.txt", "w")
    for filename in sys.argv[1:]:
        j=json.load(open(filename))
        # https://github.com/lihebi/cs572-project/archive/master.zip
        prefix='https://github.com/'
        suffix='/archive/master.zip'
        for it in j['items']:
            # print(it['full_name'])
            fullname=it['full_name']
            star=it['stargazers_count']
            size=it['size']
            key=fullname.replace('/','--')
            repofile.write(
                prefix + fullname + suffix + ' -O ' + key + '.zip' + '\n')
            c.execute("insert into data values(?,?,?,?,?,?,?,?)", (
                key,
                it['stargazers_count'],
                it['forks_count'],
                it['has_downloads'],
                it['has_issues'],
                it['has_wiki'],
                it['has_pages'],
                it['open_issues_count']
            ))
    conn.commit()
    conn.close()
    repofile.close()
    print("outputed to repo.txt")
