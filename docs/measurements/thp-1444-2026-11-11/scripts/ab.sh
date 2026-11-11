#!/bin/sh
# #1444 item 3: time-runs over builds, each at four placements of main_unit_checker.c's code, their runs rotated (a
# Williams design over the slots) so that each process starts after other builds' (a cold start; the files are in the
# page cache), pinned to CPU 2. The last build named BUILD-again is the first one's executables again: the A/A floor.
# Each time-runs process is one hold of the 9700X's lock.
#   ab.sh TAG COPIES NAME=PREFIX...   (PREFIX-SHIFT is each placement's executable)
set -e
d=~/buster-fast-bench/1444-claude-thp
. $d/env.sh
cd $d/inputs
tag=$1
copies=$2
shift 2
shifts="0 1088 2112 3136"
builds=""
for spec in "$@"; do
    name=${spec%%=*}
    prefix=${spec#*=}
    for s in $shifts; do builds="$builds --build $name $prefix-$s"; done
done
c=""
[ "$copies" -gt 0 ] && c="--copies $copies"
H=$d/shifts-base/compiler-0
T=$d/tree-base
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 30 --warmups 3 $c $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null --list -c hello.c -o /dev/null > $d/results/ab-$tag-small.txt 2>&1
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 20 --warmups 2 $c $builds --list -c medium.c -o /dev/null --list -c a.c b.c c.c d.c > $d/results/ab-$tag-medium.txt 2>&1
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 4 --warmups 1 $c $builds --list -fsyntax-only -march=native -I$T/src -fwrapv -funsigned-char $T/src/buster/compiler/main.c --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null > $d/results/ab-$tag-large.txt 2>&1
echo done > $d/results/ab-$tag.done
