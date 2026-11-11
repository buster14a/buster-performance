#!/bin/sh
# #1444 item 5: base against head, each at four placements of main_unit_checker.c's code (build.sh), base's placements
# again as the floor (base-again), whole fresh processes from two fresh copies of each executable (time-runs --copies),
# their order rotated (a Williams design), pinned to CPU 2 as #1444's records are. Every list is one time-runs process
# under the 9700X's lock, one hold each.
#   run.sh TAG
set -e
d=~/buster-fast-bench/1444-claude-options
mkdir -p $d/inputs $d/results
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-options EXCLUSIVE_TITLE="Table-driven option matching for compiles (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
shifts="0 1088 2112 3136"
H=$d/shifts-head/compiler-0
builds=""
for build in base:base head:head base-again:base; do
    for shift in $shifts; do builds="$builds --build ${build%%:*} $d/shifts-${build#*:}/compiler-$shift"; done
done
: > empty.c
printf 'int main(void){return 0;}\n' > tiny.c
printf '#include <stdio.h>\nint main(void){printf("%%d\\n", 1);return 0;}\n' > hello.c
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
# The small units: an empty file's -fsyntax-only and -E -P, the one-line and stdio.h -c.
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 40 --warmups 3 --copies 2 $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null --list -c hello.c -o /dev/null > $d/results/ab-small-$tag.txt 2>&1
# The large control: sqlite3.c's object, with the options of #1444's records.
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 11 --warmups 1 --copies 1 $builds --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o $d/sqlite.o > $d/results/ab-sqlite-$tag.txt 2>&1
echo done > $d/results/run-$tag.done
