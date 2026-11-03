#!/usr/bin/env bash
# queue16.sh: replaces queue15.sh's wait (bisect15/ done) once the head moved to 1b073842 (commits 16 to 19: the vectors'
# native gates, the fixture's unsigned hash, the outgoing area's alignment, the x87 copies' records). The head's build;
# perf stat of --tier1 -c of the frozen sqlite3.c against main 730eea0a and c5f4863a (bisect.sh, bisect16/), and whether
# its sqlite3.o is c5f4863a's (bisect16/cmp.txt); ab against main, 5 rounds of 21 runs (ab16/); then, once #142's
# campaign at c5f4863a is done (queue14.sh), each of its programs compiled again by c5f4863a's and the head's builds
# (equal15.py, equal16/).
. ~/buster-fast-bench/claude-141-wide/common.sh
rm -rf head-1b073842 && tar xzf head-1b073842.tgz && rm head-1b073842.tgz
./build.sh head-1b073842
BISECT_OUT=bisect16 ./bisect.sh main-730eea0a head-c5f4863a head-1b073842
{ cmp $RUNDIR/bisect-head-c5f4863a.o $RUNDIR/bisect-head-1b073842.o && echo "sqlite3.o: c5f4863a's and 1b073842's are identical"; } > bisect16/cmp.txt 2>&1
mkdir -p ab16
head-1b073842/build/compiler ab --rounds 5 --cpu 2 --lock $lock main-730eea0a head-1b073842 -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/ab16.o $Q/sqlite3.c > ab16/compile-tier1-ab.log 2>&1
echo "exit $?" >> ab16/compile-tier1-ab.log
touch ab16/done
until [ -f campaign14.done ]; do sleep 60; done
mkdir -p equal16
for d in diff-head-c5f4863a diff-scalar-head-c5f4863a; do
    rm -f equal16/$d.tsv
    for chunk in $d/chunk-*/; do
        "$lock" taskset -c 2 python3 $PWD/equal15.py $PWD/$chunk $PWD/equal16/$d.tsv head-1b073842
    done
done
touch equal16/done queue16.done
