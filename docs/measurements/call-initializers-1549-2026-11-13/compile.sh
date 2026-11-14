#!/bin/bash
# sqlite3.c's -c by base and head as whole processes: three time-runs invocations (it rotates their order), each its
# own hold, then one hold for the two objects' shapes.
set -euo pipefail
cd ~/buster-fast-bench/1549-claude
out=results/compile-$(date +%s)
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
defines="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
for i in 1 2 3; do
    ./lock.sh "$out/time-runs-$i" taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head head/build/compiler \
        --list -c --lanes 1 $defines "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/1549-claude-sqlite.o > "$out/time-runs-$i.txt" 2>&1
done
./lock.sh "$out/shape" bash -c "for t in base head; do \$t/build/compiler -c --lanes 1 $defines -I$sqlite $sqlite/sqlite3.c -o $out/sqlite-\$t.o; done" > "$out/shape-receipt.txt"
for t in base head; do echo "$t text=$(size -A "$out"/sqlite-$t.o | awk '/^\.text /{print $2}') memmove=$(objdump -dr "$out"/sqlite-$t.o | grep -c 'R_X86_64_PLT32	memmove')"; done | tee "$out/shape.txt"
sha256sum "$out"/*.o > "$out/sha256.txt"
echo "$out"
