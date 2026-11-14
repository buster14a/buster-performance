#!/bin/bash
# gauge.sh COMPILER OUT: step 0's gauge (counted, then sampled, one hold of the lock each) on sqlite3.c, then the tables.
# Extra compiler options follow in $GAUGE_OPTIONS.
set -u
compiler=$1
out=$2
cd ~/buster-fast-bench/2536-step1-claude
export EXCLUSIVE_OWNER=claude-2536-step1 EXCLUSIVE_TITLE="Problem 2536 (step 1)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
[ -x allcore ] || cc -std=c17 -O2 -Wall -Wextra -Werror -o allcore main/tools/allcore/allcore.c
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p "$out"
command=("$PWD/$compiler" --time-stages --lanes 1 ${GAUGE_OPTIONS:-} -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$out/%l.w%w.o")
for part in counted sampled; do
    timeout 600 ~/buster-fast-bench/exclusive.sh ./allcore $part --out "$out" -- "${command[@]}" > "$out/$part.log" 2>&1
    echo "$part status $?" >> "$out/status.txt"
done
./allcore table --out "$out" --bytes 9507037 > "$out/table.log" 2>&1
echo "table status $?" >> "$out/status.txt"
