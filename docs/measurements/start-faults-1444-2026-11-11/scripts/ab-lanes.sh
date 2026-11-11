#!/bin/sh
# #1444 items 1 and 2: ab.sh's builds and placements on every CPU (no taskset), where a compile's session starts its
# lanes (8 on the 9700X): sqlite3.c's -c, medium.c's -c and the four units' -c. Each time-runs process is one hold of
# the 9700X's lock.
#   ab-lanes.sh TAG HEAD...
set -e
d=~/buster-fast-bench/1444-claude-arenas
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-arenas EXCLUSIVE_TITLE="Arenas' first commits and anonymous faults (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
shift
shifts="0 1088 2112 3136"
builds=""
for build in base "$@" base-again; do
    directory=$build
    [ $build = base-again ] && directory=base
    for shift in $shifts; do builds="$builds --build $build $d/shifts-$directory/compiler-$shift"; done
done
H=$d/shifts-base/compiler-0
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh $H time-runs --runs 10 --warmups 1 --copies 1 $builds --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null > $d/results/ab-lanes-$tag-sqlite.txt 2>&1
~/buster-fast-bench/exclusive.sh $H time-runs --runs 20 --warmups 2 --copies 2 $builds --list -c medium.c -o /dev/null --list -c a.c b.c c.c d.c --list -c tiny.c -o /dev/null > $d/results/ab-lanes-$tag-small.txt 2>&1
echo done > $d/results/ab-lanes-$tag.done
