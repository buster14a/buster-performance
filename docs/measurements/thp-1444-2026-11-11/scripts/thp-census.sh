#!/bin/sh
# #1444 item 3: where build NAME's placement 0 takes transparent huge pages, for each control: thp_fault_alloc and
# thp_fault_fallback over RUNS processes, and one run's anonymous huge-page faults (a kprobe on
# do_huge_pmd_anonymous_page, vmf->address at +24) attributed to the mappings of a strace of another run, both with the
# address space's randomization off, pinned to CPU 2. Each control is one hold of the 9700X's lock.
#   thp-census.sh NAME
set -e
d=~/buster-fast-bench/1444-claude-thp
. $d/env.sh
name=$1
C=$d/shifts-$name/compiler-0
T=$d/tree-$name
out=$d/results/thp-$name
mkdir -p $out
readelf -SW $C | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print $i, $(i+2), $(i+4); break } }' > $out/sections.txt
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cd $d/inputs
for control in syntax preprocess tiny hello mainc sqlite; do
    case $control in
        syntax) args="-fsyntax-only empty.c"; runs=100;;
        preprocess) args="-E -P empty.c -o /dev/null"; runs=100;;
        tiny) args="-c tiny.c -o /dev/null"; runs=100;;
        hello) args="-c hello.c -o /dev/null"; runs=100;;
        mainc) args="-fsyntax-only -march=native -I$T/src -fwrapv -funsigned-char $T/src/buster/compiler/main.c"; runs=10;;
        sqlite) args="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null"; runs=5;;
    esac
    $C $args > /dev/null 2>&1 || echo "$control failed" >> $out/errors.txt
    ~/buster-fast-bench/exclusive.sh sh -c "
        v() { awk '/^thp_fault_alloc /{a=\$2} /^thp_fault_fallback /{f=\$2} END{print a, f}' /proc/vmstat; }
        set -- \$(v); i=0; while [ \$i -lt $runs ]; do taskset -c 2 $C $args > /dev/null 2>&1; i=\$((i + 1)); done; a=\$1; f=\$2; set -- \$(v)
        echo \"thp_fault_alloc over $runs runs: \$((\$1 - a)), thp_fault_fallback: \$((\$2 - f))\" > $out/count-$control.txt
        taskset -c 2 setarch -R strace -f -k -e trace=mmap,munmap,mprotect,madvise,brk -o $out/strace-$control.txt $C $args > /dev/null 2>&1
        sudo perf probe -q -d probe:thp1444 2>/dev/null || true
        sudo perf probe -q -a 'thp1444=do_huge_pmd_anonymous_page addr=+24(%di):x64'
        sudo taskset -c 2 setarch -R perf record -q -e probe:thp1444 -o $out/probe-$control.data -- $C $args > /dev/null 2>&1
        sudo perf probe -q -d probe:thp1444
        sudo perf script -i $out/probe-$control.data -F trace 2>/dev/null | sed -n 's/.*addr=\(0x[0-9a-f]*\).*/\1 0 thp/p' > $out/thp-$control.txt
        sudo rm -f $out/probe-$control.data"
    python3 $d/attribute.py $out/strace-$control.txt $out/thp-$control.txt $out/sections.txt | sed -n '/^faults:/,$p' > $out/attribution-$control.txt
done
echo done > $out/done
