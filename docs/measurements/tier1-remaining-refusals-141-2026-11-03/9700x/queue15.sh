#!/usr/bin/env bash
# queue15.sh: commit 15 (b6d9570c, the wide split's 64-bit counts) against c5f4863a: its build, perf stat of --tier1 -c of
# the frozen sqlite3.c (bisect.sh, bisect15/) and whether the two trees' sqlite3.o are byte-identical (bisect15/cmp.txt);
# then, once #142's campaign at c5f4863a is done (queue14.sh), its programs compiled again by both (equal15.sh).
. ~/buster-fast-bench/claude-141-wide/common.sh
rm -rf head-b6d9570c && tar xzf head-b6d9570c.tgz && rm head-b6d9570c.tgz
./build.sh head-b6d9570c
BISECT_OUT=bisect15 ./bisect.sh head-c5f4863a head-b6d9570c
{ cmp $RUNDIR/bisect-head-c5f4863a.o $RUNDIR/bisect-head-b6d9570c.o && echo "sqlite3.o: c5f4863a's and b6d9570c's are identical"; } > bisect15/cmp.txt 2>&1
until [ -f campaign14.done ]; do sleep 60; done
./equal15.sh
touch queue15.done
