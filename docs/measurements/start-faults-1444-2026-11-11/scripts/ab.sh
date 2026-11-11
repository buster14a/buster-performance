#!/bin/sh
# #1444 items 1 and 2: time-runs over base, each head and base again (the A/A floor), each build's four placements of
# main_unit_checker.c's code (shifts-NAME/compiler-SHIFT), their runs rotated (a Williams design over the slots) so that
# each process starts after other builds' (a cold start; the files are in the page cache), pinned to CPU 2. Each
# time-runs process is one hold of the 9700X's lock.
#   ab.sh TAG HEAD...
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
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 30 --warmups 3 --copies 2 $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null --list -c hello.c -o /dev/null > $d/results/ab-$tag-small.txt 2>&1
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 20 --warmups 2 --copies 2 $builds --list -c medium.c -o /dev/null --list -c a.c b.c c.c d.c > $d/results/ab-$tag-medium.txt 2>&1
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 4 --warmups 1 --copies 1 $builds --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null > $d/results/ab-$tag-sqlite.txt 2>&1
echo done > $d/results/ab-$tag.done
