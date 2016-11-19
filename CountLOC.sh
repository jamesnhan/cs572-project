#!/usr/bin/env bash

# Uses https://github.com/AlDanial/cloc

git clone --depth 1 "$1" temp-linecount-repo &&
	printf cloc temp-linecount-repo &&
	rm -rf temp-linecount-repo