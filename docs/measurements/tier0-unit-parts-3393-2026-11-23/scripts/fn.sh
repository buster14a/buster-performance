#!/bin/bash
# fn.sh FILE FUNCTION [INDENT]: FILE:START:END[:INDENT] of the function's body.
f=$1; n=$2; i=${3:-4}
s=$(grep -n "^static[^;]*[ *]$n(" $f | grep -v ";$" | tail -1 | cut -d: -f1)
# the body's opening brace line
b=$(awk -v s=$s 'NR>=s && /^\{/ {print NR; exit}' $f)
e=$(awk -v s=$b 'NR>s && /^\}/ {print NR; exit}' $f)
echo "$f:$((b+1)):$((e-1)):$i"
