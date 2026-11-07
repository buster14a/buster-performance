#!/bin/bash
# #590's closing qualification on a Xeon VM: the same executables as close.sh (baked, and the same link with
# BUSTER_BAKE=0), pinned to CPU 2. On a VM the compiler turns huge pages off for itself (lane.c's arena_page_policy);
# BUSTER_HUGE_PAGES=1 leaves them as the kernel has them, here madvise and then always.
set -u
S=$(dirname "$0")
cd /home/user/buster
work=build/m590
log=$S/vm-logs
obj=$S/vm-objects
mkdir -p $log $obj $work/inputs
printf '' > $work/inputs/empty.c
printf 'int main(void) { return 0; }\n' > $work/inputs/tiny.c
printf '#include <stdio.h>\nint main(void) { puts("hello"); return 0; }\n' > $work/inputs/hello.c
sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt > $log/subset.list
{
    date -u; uname -a; grep -m1 "model name" /proc/cpuinfo; nproc
    sha256sum /usr/bin/tcc $work/compiler-baked $work/compiler-unbaked $work/inputs/*.c
    tcc -v; clang --version | head -1; git log -1 --format='%H %s'
    $work/compiler-baked test-baked-tables; $work/compiler-unbaked test-baked-tables
} > $log/host.txt 2>&1
d=0; n=0
while read f; do
    id=$(basename $f .c)
    $work/compiler-unbaked -c -o $obj/$id.unbaked.o $f 2>/dev/null; a=$?
    $work/compiler-baked -c -o $obj/$id.baked.o $f 2>/dev/null; b=$?
    n=$((n+1))
    { [ $a = 0 ] && [ $b = 0 ] && cmp -s $obj/$id.unbaked.o $obj/$id.baked.o; } || { d=$((d+1)); echo "differs: $f ($a/$b)" >> $log/objects.txt; }
done < <(cat $log/subset.list; ls $work/inputs/*.c)
echo "objects: $n files (c-testsuite's subset, empty.c, tiny.c, hello.c), $d differ" >> $log/objects.txt
for thp in madvise always; do
    echo $thp > /sys/kernel/mm/transparent_hugepage/enabled
    for round in 1 2; do
        if [ $round = 1 ]; then order="unbaked baked"; else order="baked unbaked"; fi
        for input in empty tiny hello; do
            for cond in vm-off system; do
                for t in $order; do
                    if [ $cond = system ]; then pages=1; else pages=; fi
                    BUSTER_HUGE_PAGES=$pages taskset -c 2 $work/compiler-$t measure-compile --runs 41 --reference /usr/bin/tcc -- -c $work/inputs/$input.c > $log/$input-$thp-$cond-$t-$round.txt 2>&1
                done
            done
        done
    done
    BUSTER_HUGE_PAGES=1 taskset -c 2 $S/best_of $obj/best_of.o 3 $(pwd)/$work/compiler-unbaked $(pwd)/$work/compiler-baked /usr/bin/tcc < $log/subset.list > $log/c-testsuite-$thp-system.txt 2>&1
    taskset -c 2 $S/best_of $obj/best_of.o 3 $(pwd)/$work/compiler-unbaked $(pwd)/$work/compiler-baked /usr/bin/tcc < $log/subset.list > $log/c-testsuite-$thp-vm-off.txt 2>&1
done
echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
echo done > $log/DONE
