#!/usr/bin/env python3

import os
import Queue
import urllib2
from urllib2 import Request
from urllib2 import HTTPError
import json
import subprocess

# IMPORTANT:
# I switched the order of the queue to be in reverse by removing the negative!
# This makes it so the tests go faster by using smaller projects (in order of stars)
# Lines of Code must be tested and finished on a Unix/Linux machine
# The CLOC library referenced has output for blank lines, comments, and code lines
# Also, the language for C# is "csharp", so I have changed that

# Sorts the JSON files by stars in a Priority Queue
def sortStars(lang):
    for file in os.listdir("data/"):
        if file.startswith(lang) and file.endswith(".json"):
            jsondict = json.loads(open("data/" + file).read())
            for project in jsondict["items"]:
                # use negative stargazer count so we can sort in descending order
                projectsByStars.put((project["stargazers_count"], project["stargazers_count"], project["full_name"]))

# http://stackoverflow.com/questions/25022016/get-all-file-names-from-a-github-repo-through-the-github-api
# Recursive function
def getFileCountR(repo, sha):
    count = 0
    depths = [0]

    #print("Get tree structure")
    # Get the tree structure
    url = 'https://api.github.com'
    api = '/repos/' + repo + '/git/trees/' + sha
    token = '9bd17842ec481bc1c764c4e6709c8fc2c50809c9 '
    query = url + api
    req = Request(query)
    req.add_header("Authorization", "token " + token)
    response = urllib2.urlopen(req)
    s = response.read()
    
    jsondict = json.loads(s)

    # Search files
    for item in jsondict["tree"]:
        itemtype = item["type"]
        #print("Found " + itemtype)
        if (itemtype == "blob"):
            count = count + 1
        elif (itemtype == "tree"):
            depths[0] = depths[0] + 1
            a, b = getFileCountR(repo, item["sha"])
            count = count + a
            depths.extend(b)

    return count, depths
    
# Base function
def getFileCount(repo):
    count = 0
    depth = []

    #print("Getting SHA of commit")
    # Get the SHA of the latest commit
    url = 'https://api.github.com'
    api = '/repos/' + repo + '/commits'
    token = '9bd17842ec481bc1c764c4e6709c8fc2c50809c9 '
    query = url + api
    req = Request(query)
    req.add_header("Authorization", "token " + token)
    response = urllib2.urlopen(req)
    s = response.read()
    
    jsondict = json.loads(s)
    sha = jsondict[0]["sha"]
    #print("SHA: " + sha)

    #print("Getting SHA of root tree")
    # Get the SHA of the root tree
    url = 'https://api.github.com'
    api = '/repos/' + repo + '/git/commits/' + sha
    token = '9bd17842ec481bc1c764c4e6709c8fc2c50809c9 '
    query = url + api
    req = Request(query)
    req.add_header("Authorization", "token " + token)
    response = urllib2.urlopen(req)
    s = response.read()
    
    jsondict = json.loads(s)
    sha = jsondict["tree"]["sha"]
    #print("SHA: " + sha)

    #print("Recurse start")
    # Recursively search trees for blobs
    count, depth = getFileCountR(repo, sha)
    return count, depth

def getReadmeSize(repo):
    #print("Getting size of Readme.MD")
    # Get the readme file
    try:
        url = 'https://api.github.com'
        api = '/repos/' + repo + '/readme'
        token = '9bd17842ec481bc1c764c4e6709c8fc2c50809c9 '
        query = url + api
        req = Request(query)
        req.add_header("Authorization", "token " + token)
        response = urllib2.urlopen(req)
        s = response.read()
    
        jsondict = json.loads(s)
        size = jsondict["size"]
    except HTTPError:
        # Occurs when there is no Readme.MD file in the project
        size = 0
    
    return size
                  
if __name__ == '__main__':
    projectsByStars = Queue.PriorityQueue()
    
    for lang in ['csharp']:
        sortStars(lang)

    while not projectsByStars.empty():
        project = projectsByStars.get()
        print(str(project[1]) + ", " + project[2])
        
        # Get number of blank lines, comments, and code lines
        # TODO: Capture the output
        #repourl = "https://github.com/" + project[2]
        #subprocess.call(['./CountLOC.sh ' + str(repourl)])
        
        # Get size of the README.md
        # We can possibly assume that comments + size of README.md (+ Wiki) be the
        # input to a heuristic to score the documentation score as finding number
        # of Unit Tests will be very difficult and probably require machine learning
        readmeSize = getReadmeSize(project[2])
        print("Readme.MD Size (KB): " + str(readmeSize))

        # We can get the number of files via recursion and Github API
        fileCount, depths = getFileCount(project[2])
        print("File Count: " + str(fileCount))
        #averageFileLength = loc / fileCount
        #print("Average File Length: " + averageFileLength)
        averageDirectoryBranchingFactor = sum(depths)/float(len(depths))
        print("Average Directory Branching Factor: " + str(averageDirectoryBranchingFactor))
        print("All Directory Depths: " + str(depths))
