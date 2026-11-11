#!/bin/sh
# #1444 items 1 and 2: page faults by region and by mapping, for each build's four placements: 20 processes of each
# control under perf record (every fault, with its address), the address space's randomization off (setarch -R) so that
# one strace run's mappings, and the code that made each, hold for every process. Each build, placement and control is
# one hold of the 9700X's lock.
#   faults.sh TAG BUILD...
set -e
d=~/buster-fast-bench/1444-claude-arenas
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-arenas EXCLUSIVE_TITLE="Arenas' first commits and anonymous faults (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
shift
out=$d/results/faults-$tag
mkdir -p $out
for build in "$@"; do
    for shift in 0 1088 2112 3136; do
        C=$d/shifts-$build/compiler-$shift
        readelf -SW $C | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print $i, $(i+2), $(i+4); break } }' > $out/sections-$build-$shift.txt
        for control in syntax preprocess tiny hello; do
            case $control in
                syntax) args="-fsyntax-only empty.c";;
                preprocess) args="-E -P empty.c -o /dev/null";;
                tiny) args="-c tiny.c -o /dev/null";;
                hello) args="-c hello.c -o /dev/null";;
            esac
            name=$build-$shift-$control
            ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 setarch -R strace -f -k -e trace=mmap,munmap,mprotect,madvise,brk -o $out/strace-$name.txt $C $args > /dev/null 2>&1; taskset -c 2 setarch -R perf record -q -e page-faults -c 1 -d -o $out/$name.data -- sh -c 'i=0; while [ \$i -lt 20 ]; do $C $args > /dev/null 2>&1; i=\$((i + 1)); done'"
            perf script -i $out/$name.data --comm compiler-$shift -F addr,ip,sym 2>/dev/null > $out/faults-$name.txt
            rm -f $out/$name.data
            python3 $d/attribute.py $out/strace-$name.txt $out/faults-$name.txt $out/sections-$build-$shift.txt > $out/attribution-$name.txt
            gzip -f $out/faults-$name.txt $out/strace-$name.txt
        done
    done
done
echo done > $out/done
