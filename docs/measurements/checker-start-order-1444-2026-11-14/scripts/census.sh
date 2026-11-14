#!/bin/sh
# #1444, the checker's section: build NAME's placement 0, each control in one hold of the 9700X's lock, pinned to CPU 2:
# perf stat over RUNS processes, and one run's faults attributed to one strace -k run's mappings and to the executable's
# sections (randomization off). The inputs and executable are in the page cache (each control runs once before it is
# measured); every run is a fresh process.
#   census.sh NAME [CONTROL...]
set -eu
d=~/buster-fast-bench/1444-claude-checker
. $d/env.sh
name=$1
shift
controls=${*:-syntax preprocess tiny hello tinyfirst check parse}
C=$d/shifts-$name/compiler-0
test -x $C
out=$d/results/census-$name
mkdir -p $out
readelf -SW $C | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print $i, $(i+2), $(i+4); break } }' > $out/sections.txt
cd $d/inputs
for control in $controls; do
    runs=200
    case $control in
        syntax) args="-fsyntax-only empty.c";;
        preprocess) args="-E -P empty.c -o /dev/null";;
        tiny) args="-c tiny.c -o /dev/null";;
        hello) args="-c hello.c -o /dev/null";;
        tinyfirst) args="tiny.c -c -o /dev/null";;
        check) args="check empty.c";;
        parse) args="parse empty.c";;
    esac
    $C $args > /dev/null 2>&1 || echo "$control: status $?" >> $out/errors.txt
    ~/buster-fast-bench/exclusive.sh sh -c "
        head -1 /var/lib/buster-9700x/owner >> $out/holds.txt
        taskset -c 2 perf stat -r $runs -e task-clock,page-faults,cycles:u,cycles:k,instructions:u,iTLB-load-misses -o $out/stat-$control.txt $C $args > /dev/null 2>&1
        taskset -c 2 setarch -R strace -f -k -e trace=mmap,munmap,mprotect,madvise,brk -o $out/strace-$control.txt $C $args > /dev/null 2>&1
        taskset -c 2 setarch -R perf record -q -e page-faults -c 1 -d -o $out/faults-$control.data -- $C $args > /dev/null 2>&1" || true
    perf script -i $out/faults-$control.data -F addr,ip,sym 2>/dev/null > $out/faults-$control.txt
    rm -f $out/faults-$control.data
    python3 $d/attribute.py $out/strace-$control.txt $out/faults-$control.txt $out/sections.txt > $out/attribution-$control.txt
    gzip -f $out/faults-$control.txt $out/strace-$control.txt
done
echo done > $out/done
