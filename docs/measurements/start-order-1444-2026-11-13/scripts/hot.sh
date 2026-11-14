#!/bin/sh
# #1444 item 4: the code small compiles run, by build NAME's placement 0: user instructions sampled every 499 (with
# their last branches, -b) over RUNS processes each of an empty file's -fsyntax-only and -E -P, tiny.c's -c and hello.c's
# -c, each control its own hold of the 9700X's lock, pinned to CPU 2. perf script's ips and branch targets, for
# layout.py to attribute to each function's copy by address.
#   hot.sh NAME [RUNS]
set -e
d=~/buster-fast-bench/1444-claude-rest
. $d/env.sh
name=$1
runs=${2:-300}
C=$d/shifts-$name/compiler-0
out=$d/results/hot-$name
mkdir -p $out
cd $d/inputs
for control in syntax preprocess tiny hello; do
    case $control in
        syntax) args="-fsyntax-only empty.c";;
        preprocess) args="-E -P empty.c -o /dev/null";;
        tiny) args="-c tiny.c -o /dev/null";;
        hello) args="-c hello.c -o /dev/null";;
    esac
    ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -b -e instructions:u -c 4999 -o $out/$control.data -- sh -c 'i=0; while [ \$i -lt $runs ]; do $C $args > /dev/null 2>&1; i=\$((i + 1)); done' > /dev/null 2>&1" || true
    perf script -i $out/$control.data --comm compiler-0 -F ip,brstack 2>/dev/null | gzip > $out/$control.txt.gz
    rm -f $out/$control.data
done
readelf -sW $C | gzip > $out/symbols.txt.gz
readelf -SW $C > $out/sections.txt
echo done > $out/done
