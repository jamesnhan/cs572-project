#!/bin/bash

# concatenate csvs into a whole one

# remove the headers

head -1 c.csv > whole.csv

for file in c.csv java.csv javascript.csv shell.csv python.csv ruby.csv php.csv; do
    cat $file | awk 'NR!=1 {print}' >> whole.csv
done
