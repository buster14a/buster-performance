#!/bin/sh
# #1444's open items: a startup census of build NAME's placement 0 (shifts-NAME/compiler-0), each control in turn, each
# measurement its own hold of the 9700X's lock, pinned to CPU 2:
# - perf stat over RUNS processes (task clock, faults, user and kernel cycles, user instructions, iTLB misses);
# - strace -c's system calls;
# - thp_fault_alloc over RUNS processes;
# - one run's page faults (perf record -d, every fault) attributed to one strace -k run's mappings and to the sections,
#   both with the address space's randomization off (setarch -R);
# - one run's huge-page allocations (a kprobe on vma_alloc_anon_folio_pmd) with their user stacks.
# Cache conditions: the inputs and the executable are in the page cache (each control runs once before it is measured);
# every run is a fresh process.
#   census.sh NAME [CONTROL...]
set -e
d=~/buster-fast-bench/1444-claude-rest
. $d/env.sh
name=$1
shift
controls=${*:-syntax preprocess tiny hello tinyfirst check parse sqlite}
C=$d/shifts-$name/compiler-0
T=$d/tree-$name
out=$d/results/census-$name
mkdir -p $out
readelf -SW $C | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print $i, $(i+2), $(i+4); break } }' > $out/sections.txt
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
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
        sqlite) args="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null"; runs=5;;
    esac
    $C $args > /dev/null 2>&1 || echo "$control: status $?" >> $out/errors.txt
    ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -r $runs -e task-clock,page-faults,cycles:u,cycles:k,instructions:u,iTLB-load-misses -o $out/stat-$control.txt $C $args > /dev/null 2>&1 || true
    ~/buster-fast-bench/exclusive.sh taskset -c 2 strace -f -c -o $out/syscalls-$control.txt $C $args > /dev/null 2>&1 || true
    ~/buster-fast-bench/exclusive.sh sh -c "a=\$(awk '/^thp_fault_alloc /{print \$2}' /proc/vmstat); i=0; while [ \$i -lt $runs ]; do taskset -c 2 $C $args > /dev/null 2>&1; i=\$((i + 1)); done; b=\$(awk '/^thp_fault_alloc /{print \$2}' /proc/vmstat); echo \"thp_fault_alloc over $runs runs: \$((b - a))\"" > $out/thp-$control.txt
    if [ $control != sqlite ]; then
        ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 setarch -R strace -f -k -e trace=mmap,munmap,mprotect,madvise,brk -o $out/strace-$control.txt $C $args > /dev/null 2>&1; taskset -c 2 setarch -R perf record -q -e page-faults -c 1 -d -o $out/faults-$control.data -- $C $args > /dev/null 2>&1" || true
        perf script -i $out/faults-$control.data -F addr,ip,sym 2>/dev/null > $out/faults-$control.txt
        rm -f $out/faults-$control.data
        python3 $d/attribute.py $out/strace-$control.txt $out/faults-$control.txt $out/sections.txt > $out/attribution-$control.txt
        ~/buster-fast-bench/exclusive.sh sh -c "
            sudo perf probe -q -d probe:thp1444r 2>/dev/null || true
            sudo perf probe -q -a 'thp1444r=vma_alloc_anon_folio_pmd addr=%si:x64'
            sudo taskset -c 2 setarch -R perf record -q -g -e probe:thp1444r -o $out/who-$control.data -- $C $args > /dev/null 2>&1
            sudo perf probe -q -d probe:thp1444r
            sudo perf script -i $out/who-$control.data -F trace,ip,sym 2>/dev/null > $out/who-$control.txt
            sudo rm -f $out/who-$control.data" || true
        sed -n 's/.*addr=\(0x[0-9a-f]*\).*/\1 0 thp/p' $out/who-$control.txt > $out/who-addresses-$control.txt
        python3 $d/attribute.py $out/strace-$control.txt $out/who-addresses-$control.txt $out/sections.txt | sed -n '/^faults:/,$p' > $out/who-attribution-$control.txt
    fi
done
echo done > $out/done
