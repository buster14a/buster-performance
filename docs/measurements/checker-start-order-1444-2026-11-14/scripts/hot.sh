#!/bin/sh
# #1444, the checker's section: samples for `compiler start-order` from build NAME's placement 0, one hold of the 9700X's
# lock per control, pinned to CPU 2: RUNS processes each under its own `perf record -b -e instructions:u -c PERIOD`, the
# period 4999 + 2i for the i-th, so that the deterministic compile is sampled at a different phase each time (one
# period samples about the same instructions in every process, and misses short functions every time); then `perf
# script -F ip,brstack` of them all, and the executable's `readelf -sW`.
#   hot.sh NAME [RUNS]
set -eu
d=~/buster-fast-bench/1444-claude-checker
. $d/env.sh
name=$1
runs=${2:-300}
C=$d/shifts-$name/compiler-0
test -x $C
out=$d/results/hot-$name
mkdir -p $out/data
cd $d/inputs
for control in syntax preprocess tiny hello; do
    case $control in
        syntax) args="-fsyntax-only empty.c";;
        preprocess) args="-E -P empty.c -o /dev/null";;
        tiny) args="-c tiny.c -o /dev/null";;
        hello) args="-c hello.c -o /dev/null";;
    esac
    ~/buster-fast-bench/exclusive.sh sh -c "
        head -1 /var/lib/buster-9700x/owner >> $out/holds.txt
        i=0
        while [ \$i -lt $runs ]; do
            taskset -c 2 perf record -q -b -e instructions:u -c \$((4999 + 2 * i)) -o $out/data/$control-\$i.data -- $C $args > /dev/null 2>&1 || echo \"$control \$i: status \$?\" >> $out/errors.txt
            i=\$((i + 1))
        done"
    i=0
    : > $out/$control.txt
    while [ $i -lt $runs ]; do
        perf script -i $out/data/$control-$i.data -F ip,brstack 2>/dev/null >> $out/$control.txt
        i=$((i + 1))
    done
    rm -f $out/data/$control-*.data
    gzip -f $out/$control.txt
done
readelf -sW $C | gzip > $out/symbols.txt.gz
readelf -SW $C > $out/sections.txt
echo done > $out/done
