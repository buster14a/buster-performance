#!/bin/sh
# #1444, the checker's section: sqlite3.c's -c alone, more runs than ab.sh's large group, over base, head2 and base
# again (the floor), each at four placements with two copies, a Williams design; one hold of the 9700X's lock.
#   ab-sqlite.sh TAG RUNS
set -eu
d=~/buster-fast-bench/1444-claude-checker
. $d/env.sh
cd $d/inputs
tag=$1
runs=$2
shifts="0 1088 2112 3136"
builds=""
for name in base head2 base-again; do
    for s in $shifts; do builds="$builds --build $name $d/shifts-${name%-again}/compiler-$s"; done
done
H=$d/shifts-base/compiler-0
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $d/results/ab-$tag-holds.txt; exec taskset -c 2 $H time-runs --runs $runs --warmups 1 --copies 2 $builds --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null" > $d/results/ab-$tag.txt 2>&1
echo done > $d/results/ab-$tag.done
