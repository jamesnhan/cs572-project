#!/bin/bash

# Usage
# <this script> /path/to/dir/containing/zip/files

for file in $1/*.zip; do
    echo "== $file"
    ./ground.sh $file
done
