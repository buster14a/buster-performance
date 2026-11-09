#!/usr/bin/env bash
# #1340: a cycles profile (user and kernel) of 10 sqlite3.c -c compiles of a build, on CPU 2, in one hold of the
# 9700X's lock: prof1340.sh BIN OUT.data. Appends the hold's receipt to OUT.holds.txt.
set -u
cd ~/buster-fast-bench/1340-opencode || exit 2
bin=$1; out=$2
EXCLUSIVE_OWNER=opencode-1340 EXCLUSIVE_TITLE="opencode #1340 profile" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
~/buster-fast-bench/exclusive.sh bash -c '
head -1 /var/lib/buster-9700x/owner >> '"$out"'.holds.txt
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
args=(-c --lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" -o /tmp/opencode1340p.o)
taskset -c 2 perf record -q -e cycles -c 50003 -o '"$out"' -- bash -c "for i in 1 2 3 4 5 6 7 8 9 10; do '"$bin"' \"\$@\" > /dev/null 2>&1 || exit 1; done" x "${args[@]}"
echo "status=$?" >> '"$out"'.holds.txt
'
