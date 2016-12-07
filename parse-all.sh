#!/bin/bash

./parse-ground.py ruby-ground.txt > ruby.csv
./parse-ground.py php-ground.txt > php.csv
./parse-ground.py python-ground.txt > python.csv
./parse-ground.py java-ground.txt > java.csv
./parse-ground.py javascript-ground.txt > javascript.csv
./parse-ground.py shell-ground.txt > shell.csv

# TODO c, c++, csharp, objc
