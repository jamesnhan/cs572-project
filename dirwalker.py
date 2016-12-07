#!/usr/bin/env python3

import os

# every depth of the file structure
# get average branching factor of directories

depth=0
filect=0
branching=0
dirct=0
for root,dirs,files in os.walk("/tmp/cs572"):
    dep=root.count('/')
    depth+=dep*len(dirs)
    branching+=len(dirs)+len(files)
    filect+=len(files)
    dirct+=len(dirs)


print("TotalFileDepth=",depth)
print("TotalFileCt=",filect)
print("TotalDirBranching=",branching)
print("TotalDirCt=",dirct)
# print (depth, filect, branching, dirct)
