#!/bin/bash

# Project Rating Groud Truth
# a) download times
# b) lifetime length
# c) commit number
# d) a rating system: e.g. github star
# e) number of contributors
# f) number of watchers.

# IMPORTANT Now only using d) github star number

# Features

# 1) number of tests
# 2) number of documentation
# 3) number of source files
# 4) total source line of code
# 5) total source line of code in source directory (excluding libraries)
# 6) average length of source files
# 7) every depth of the file structure
# 8) average branching factor of the directories.


# How to get them
# 1) number of tests: Heuristic for test file name?? Files in root level "test" folder
# 2) number of documentation: Heuristic for document file name? Files in root level "doc" folder
# 3) number of source files: source file suffix. cloc can output the number of source files. TODO Need to enumerate the language name
# 4) total source line of code: using cloc and parse the data
# 5) total source line of code in source directory (excluding libraries): Heuristic: check if there's "src" "lib" folders
# 6) average length of source files: loc/filecount
# 7) every depth of the file structure: all depth / all files
# 8) average branching factor of the directories. all branching / all directory






# Usage:
# <this script> /path/to/benchmark.zip

# it will output key=value format
# additional parsing into a table is needed

TMPDIR="/tmp/cs572"

# unzip the benchmark
rm -rf $TMPDIR
mkdir $TMPDIR
unzip $1 -d $TMPDIR >/dev/null 2>&1
mv $TMPDIR/* $TMPDIR/proj
mv $TMPDIR/proj/* $TMPDIR
rm -r $TMPDIR/proj

# size of the project
echo -n "size="
du -s $TMPDIR | awk '{print $1}'

# get number of test files
echo -n "NumOfTestFile="
if [ -d "$TMPDIR/test" ]; then
    find $TMPDIR/test | wc -l
else
    echo 0
fi

# get number of ducment files
echo -n "NumOfDocFile="
if [ -d "$TMPDIR/doc" ]; then
    find $TMPDIR/doc | wc -l
else
    echo 0
fi


clocoutput=`cloc $TMPDIR | grep SUM`

# get number of source files
echo -n "NumOfSrcFile="
echo $clocoutput | awk '{print $2}'
echo ''

# get loc
echo -n "LOC="
echo $clocoutput | awk '{print $5}'
# cloc $TMPDIR | grep SUM | awk '{print $5}'
echo ''

echo -n "comment="
echo $clocoutput | awk '{print $4}'
echo ''


# average depth of the file structure
# total depth of files
# total file count
# get average branching factor of directories
./dirwalker.py $TMPDIR
