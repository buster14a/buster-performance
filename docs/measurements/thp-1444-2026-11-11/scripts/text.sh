#!/bin/sh
# #1444 item 3: the executable's text in huge pages. Two fresh copies of build NAME's placement 0 (linked with 2 MB
# segment alignment); MADV_COLLAPSE (collapse) on the second's text puts its page cache in 2 MB folios. Then perf stat
# of both over each control, pinned to CPU 2, one hold of the 9700X's lock.
#   text.sh NAME TAG
set -e
d=~/buster-fast-bench/1444-claude-thp
. $d/env.sh
name=$1
tag=$2
out=$d/results/text-$tag
mkdir -p $out $d/copies
cp $d/shifts-$name/compiler-0 $d/copies/$tag-plain
cp $d/shifts-$name/compiler-0 $d/copies/$tag-huge
sync
cd $d/inputs
~/buster-fast-bench/exclusive.sh sh -c "
    $d/collapse $d/copies/$tag-huge > $out/collapse.txt 2>&1 || true
    $d/collapse $d/copies/$tag-huge >> $out/collapse.txt 2>&1 || true
    for c in plain huge; do
        C=$d/copies/$tag-\$c
        \$C -fsyntax-only empty.c
        taskset -c 2 perf stat -r 200 -e task-clock,page-faults,minor-faults,iTLB-load-misses,dTLB-load-misses,cycles:u,cycles:k -o $out/\$c-syntax.txt \$C -fsyntax-only empty.c > /dev/null 2>&1
        taskset -c 2 perf stat -r 200 -e task-clock,page-faults,minor-faults,iTLB-load-misses,dTLB-load-misses,cycles:u,cycles:k -o $out/\$c-hello.txt \$C -c hello.c -o /dev/null > /dev/null 2>&1
        taskset -c 2 perf stat -r 10 -e task-clock,page-faults,minor-faults,iTLB-load-misses,dTLB-load-misses,cycles:u,cycles:k -o $out/\$c-mainc.txt \$C -fsyntax-only -march=native -I$d/tree-base/src -fwrapv -funsigned-char $d/tree-base/src/buster/compiler/main.c > /dev/null 2>&1
    done"
grep -h -E "task-clock|faults|TLB|cycles|elapsed" $out/*.txt > /dev/null
echo done > $out/done
