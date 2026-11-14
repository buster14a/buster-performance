#!/bin/sh
# #1444: the anonymous pages each control touches in base pages (BUSTER_HUGE_PAGES=0), by 2 MB stretch of each mapping,
# randomization off, one hold of the 9700X's lock per control.
#   base-pages.sh NAME
set -e
d=~/buster-fast-bench/1444-claude-rest
. $d/env.sh
name=$1
C=$d/shifts-$name/compiler-0
out=$d/results/base-pages-$name
mkdir -p $out
cd $d/inputs
for control in syntax tiny hello medium; do
    case $control in
        syntax) args="-fsyntax-only empty.c";;
        tiny) args="-c tiny.c -o /dev/null";;
        hello) args="-c hello.c -o /dev/null";;
        medium) args="-c medium.c -o /dev/null";;
    esac
    for pages in 0 default; do
        e=""
        [ $pages = 0 ] && e="BUSTER_HUGE_PAGES=0"
        ~/buster-fast-bench/exclusive.sh sh -c "env $e taskset -c 2 setarch -R strace -f -k -e trace=mmap,munmap,mprotect,madvise,brk -o $out/strace-$control-$pages.txt $C $args > /dev/null 2>&1; env $e taskset -c 2 setarch -R perf record -q -e page-faults -c 1 -d -o $out/faults-$control-$pages.data -- $C $args > /dev/null 2>&1" || true
        perf script -i $out/faults-$control-$pages.data -F addr 2>/dev/null > $out/faults-$control-$pages.txt
        rm -f $out/faults-$control-$pages.data
        python3 $d/stretches.py $out/strace-$control-$pages.txt $out/faults-$control-$pages.txt > $out/stretches-$control-$pages.txt
    done
done
echo done > $out/done
