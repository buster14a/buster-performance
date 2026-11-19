#!/bin/bash
# startsec.sh EXE: the functions in .text.buster_start
idx=$(readelf -SW "$1" | sed -n 's/^ *\[ *\([0-9]*\)\] \.text\.buster_start .*/\1/p')
readelf -sW "$1" | awk -v i="$idx" '$4 == "FUNC" && $7 == i {print $8}' | sort -u
