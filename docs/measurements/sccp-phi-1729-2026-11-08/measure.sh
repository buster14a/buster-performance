#!/bin/bash
# #1729: -c --tier1 of the issue's inputs and sqlite3.c by main and the branch, one lock hold per point.
set -u
D=$HOME/buster-fast-bench/1729-opencode
C=$HOME/buster-fast-bench/corpus-391e729af658
cd "$D"
mkdir -p inputs out bin
cp base/build/compiler bin/base
cp head/build/compiler bin/head
sha256sum bin/base bin/head > binaries.sha256
for N in 1000 2000 4000 8000 16000; do
    { printf 'int g(int a) { return '; i=0; while [ $i -lt $N ]; do printf 'a == %d ? %d : ' $i $((i*2)); i=$((i+1)); done; printf '0; }\n'; } > inputs/ternary$N.c
    { printf 'int g(int a) {'; i=0; while [ $i -lt $N ]; do printf 'if (a > %d) { a += %d;' $i $i; i=$((i+1)); done
      i=0; while [ $i -lt $N ]; do printf '}'; i=$((i+1)); done; printf 'return a; }\n'; } > inputs/ifs$N.c
    { printf 'int g(int a) { return '; i=0; while [ $i -lt $N ]; do printf 'a == %d ? 7 : ' $i; i=$((i+1)); done; printf '7; }\n'; } > inputs/same$N.c
done
sha256sum inputs/*.c > inputs.sha256
lock() { EXCLUSIVE_OWNER=opencode-1729 EXCLUSIVE_TITLE="#1729 SCCP phi: measure $1" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1729 ~/buster-fast-bench/exclusive.sh "$D/point.sh" "$@" 2>&1 | grep -v '^exclusive.sh'; }
: > results.txt
for N in 1000 2000 4000 8000 16000; do
    for shape in ternary ifs same; do
        lock "$shape$N" 5 -c --tier1 "inputs/$shape$N.c" >> results.txt
        cmp -s "out/$shape$N.base.o" "out/$shape$N.head.o" && echo "$shape$N objects identical" >> results.txt || echo "$shape$N objects DIFFER" >> results.txt
    done
done
for N in 4000 16000; do
    lock "default-ternary$N" 5 -c "inputs/ternary$N.c" >> results.txt
done
lock sqlite-tier1 7 -c --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" >> results.txt
lock sqlite-default 7 -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" >> results.txt
for k in sqlite-tier1 sqlite-default; do cmp -s out/$k.base.o out/$k.head.o && echo "$k objects identical" >> results.txt || echo "$k objects DIFFER" >> results.txt; done
echo done >> results.txt
