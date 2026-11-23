#!/bin/bash
# twin.sh LIST: each file compiled -c whole and by parser tiles of 1 and 64 tokens; objects, stderr and status compared.
out=$1.out; mkdir -p $out; n=0; bad=0
while read -r f; do
    n=$((n+1))
    ./build/compiler --lanes 1 -c -Wall -Wextra "$f" -o $out/w.o > $out/w.txt 2>&1; ws=$?
    [ -f $out/w.o ] || : > $out/w.o
    for t in 1 64; do
        ./build/compiler --lanes 1 --parse-tile=$t -c -Wall -Wextra "$f" -o $out/t.o > $out/t.txt 2>&1; ts=$?
        [ -f $out/t.o ] || : > $out/t.o
        if [ $ws != $ts ] || ! cmp -s $out/w.o $out/t.o || ! cmp -s $out/w.txt $out/t.txt; then bad=$((bad+1)); echo "DIFFER tile=$t $f (status $ws/$ts)"; fi
        rm -f $out/t.o
    done
    rm -f $out/w.o
done < $1
echo "files $n differing $bad"
