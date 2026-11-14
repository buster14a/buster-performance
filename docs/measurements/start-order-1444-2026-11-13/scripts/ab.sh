#!/bin/sh
# #1444's open items: time-runs over builds, each at four placements of main_unit_checker.c's code, their runs rotated
# (a Williams design over the slots) so that each process starts after other builds' (a cold start; the files are in the
# page cache), pinned to CPU 2. The last build, BASE-again, is the first one's executables again: the A/A floor. Each
# time-runs process is one hold of the 9700X's lock.
#   ab.sh TAG COPIES BUILD...
set -e
d=~/buster-fast-bench/1444-claude-rest
. $d/env.sh
cd $d/inputs
tag=$1
copies=$2
shift 2
shifts="0 1088 2112 3136"
builds=""
for name in "$@" "$1-again"; do
    for s in $shifts; do builds="$builds --build $name $d/shifts-${name%-again}/compiler-$s"; done
done
c=""
[ "$copies" -gt 0 ] && c="--copies $copies"
H=$d/shifts-$1/compiler-0
T=$d/tree-$1
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $d/results/ab-$tag-holds.txt; exec taskset -c 2 $H time-runs --runs 30 --warmups 3 $c $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null --list tiny.c -c -o /dev/null --list -c hello.c -o /dev/null" > $d/results/ab-$tag-small.txt 2>&1
~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $d/results/ab-$tag-holds.txt; exec taskset -c 2 $H time-runs --runs 20 --warmups 2 $c $builds --list -c medium.c -o /dev/null --list -c a.c b.c c.c d.c" > $d/results/ab-$tag-medium.txt 2>&1
~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $d/results/ab-$tag-holds.txt; exec taskset -c 2 $H time-runs --runs 4 --warmups 1 $c $builds --list -fsyntax-only -march=native -I$T/src -fwrapv -funsigned-char $T/src/buster/compiler/main.c --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null" > $d/results/ab-$tag-large.txt 2>&1
{ uname -a; lscpu | grep -E "Model name|^CPU\(s\)|On-line"; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag /proc/sys/vm/overcommit_memory /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor; clang --version | head -1; ld.lld --version; perf --version; strace -V | head -1; ldd --version | head -1; df -T $d | tail -1; sha256sum $d/shifts-*/compiler-* $d/*.patch $d/inputs/*.c; } > $d/results/hostinfo.txt 2>&1
echo done > $d/results/ab-$tag.done
