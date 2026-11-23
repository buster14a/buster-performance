#!/bin/bash
# #3375 end to end: main (c7809112) against head2, real compiles, one time-runs per comparison under the lock; and
# whether the objects are the same bytes (old, main and head2).
set -e
D=~/buster-fast-bench/3375-claude
cd $D
L="EXCLUSIVE_OWNER=claude-3375 EXCLUSIVE_TITLE=issue-3375-end-to-end EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3375"
X="env $L $HOME/buster-fast-bench/exclusive.sh"
mkdir -p inputs out e2e
[ -d inputs/sqlite ] || cp -r ~/buster-fast-bench/2958-claude/inputs/sqlite inputs/
CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin | head -1)/clang
$CLANG -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > out/predefines.h
sha256sum inputs/sqlite/sqlite3.c main/src/buster/compiler/main.c out/predefines.h > e2e/inputs.sha256
SQ=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -Iinputs/sqlite inputs/sqlite/sqlite3.c)
MC=(-march=native -Imain/src -fwrapv -funsigned-char --predefines out/predefines.h main/src/buster/compiler/main.c)
$X bash -c "cat /proc/loadavg; taskset -c 2 head2/build/compiler time-runs --runs 21 --build main main/build/compiler --build head head2/build/compiler --list -c ${MC[*]} -o out/mc.o; cat /proc/loadavg" > e2e/ab-main-c.log 2>&1
$X bash -c "cat /proc/loadavg; taskset -c 2 head2/build/compiler time-runs --runs 21 --build main main/build/compiler --build head head2/build/compiler --list -c ${SQ[*]} -o out/sq.o; cat /proc/loadavg" > e2e/ab-sqlite-t0.log 2>&1
$X bash -c "for C in old main head2; do \$C/build/compiler -c ${SQ[*]} -o out/sq-\$C.o; \$C/build/compiler --tier1 -c ${SQ[*]} -o out/sq1-\$C.o; \$C/build/compiler -c ${MC[*]} -o out/mc-\$C.o; \$C/build/compiler --tier1 -c ${MC[*]} -o out/mc1-\$C.o; done" > e2e/objects.log 2>&1 || true
for o in sq sq1 mc mc1; do for C in old main; do cmp out/$o-$C.o out/$o-head2.o > /dev/null && echo "$o: $C and head2 same" || echo "$o: $C and head2 differ"; done; done >> e2e/objects.log
$X bash -c "cd head2 && gcc --version | head -1 && $CLANG --version | head -1 && ./build/compiler test-calling-convention --cross-check --clang $CLANG" > e2e/cross-check.log 2>&1 || true
echo done > e2e/done
