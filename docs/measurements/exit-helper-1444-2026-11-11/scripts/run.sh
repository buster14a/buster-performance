#!/bin/sh
# #1444's exit helper: main (base), the on-demand lanes alone (lanes) and the head with its exit helper (head), each at
# four placements, base's again as the floor (base-again), whole fresh processes from two fresh copies of each
# executable (time-runs --copies), a Williams design's order. Every list is one time-runs process, one hold each. The
# processes run on every CPU (no taskset), with the host's default environment: the head's helper on (systemd reaps).
#   run.sh TAG
set -e
. ~/buster-fast-bench/1444-claude-exit/env.sh
cd $d/inputs
tag=$1
shifts="0 1088 2112 3136"
H=$d/shifts-head/compiler-0
builds=""
for build in base:base lanes:lanes head:head base-again:base; do
    for shift in $shifts; do builds="$builds --build ${build%%:*} $d/shifts-${build#*:}/compiler-$shift"; done
done
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p $d/results
~/buster-fast-bench/exclusive.sh $H time-runs --runs 30 --warmups 3 --copies 2 $builds --list -fsyntax-only empty.c --list -c tiny.c -o /dev/null --list -c two.c -o /dev/null --list -c hello.c -o /dev/null > $d/results/ab-small-$tag.txt 2>&1
~/buster-fast-bench/exclusive.sh $H time-runs --runs 20 --warmups 2 --copies 2 $builds --list -c medium.c -o /dev/null --list -c a.c b.c c.c d.c > $d/results/ab-medium-$tag.txt 2>&1
~/buster-fast-bench/exclusive.sh $H time-runs --runs 11 --warmups 1 --copies 1 $builds --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o $d/sqlite.o > $d/results/ab-sqlite-$tag.txt 2>&1
echo done > $d/results/run-$tag.done
