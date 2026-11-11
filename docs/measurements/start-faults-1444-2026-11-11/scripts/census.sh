#!/bin/sh
# #1444 items 1 and 2: a startup census of build NAME's placement 0 (shifts-NAME/compiler-0), each control in turn,
# each measurement its own hold of the 9700X's lock, pinned to CPU 2. The controls: an empty file's -fsyntax-only and
# -E -P, tiny.c's -c, hello.c's -c (stdio.h) and sqlite3.c's -c. Cache conditions: the inputs and the executable are in
# the page cache (each is read or run before it is measured); every run is a fresh process; perf stat's runs follow
# each other (warm), and the faults' and system calls' runs are single processes after them.
#   census.sh NAME
set -e
d=~/buster-fast-bench/1444-claude-arenas
cd $d
export EXCLUSIVE_OWNER=claude-1444-arenas EXCLUSIVE_TITLE="Arenas' first commits and anonymous faults (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
name=$1
C=$d/shifts-$name/compiler-0
out=$d/results/census-$name
mkdir -p $out inputs
: > inputs/empty.c
printf 'int main(void){return 0;}\n' > inputs/tiny.c
printf '#include <stdio.h>\nint main(void){printf("%%d\\n", 1);return 0;}\n' > inputs/hello.c
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
readelf -SW $C | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print $i, $(i+2), $(i+4); break } }' > $out/sections.txt
cd inputs
for control in syntax preprocess tiny hello sqlite; do
    case $control in
        syntax) args="-fsyntax-only empty.c";;
        preprocess) args="-E -P empty.c -o /dev/null";;
        tiny) args="-c tiny.c -o /dev/null";;
        hello) args="-c hello.c -o /dev/null";;
        sqlite) args="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null";;
    esac
    runs=200
    [ $control = sqlite ] && runs=5
    $C $args > /dev/null 2>&1
    ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -r $runs -e task-clock,page-faults,cycles:u,cycles:k,instructions:u -o $out/stat-$control.txt $C $args > /dev/null 2>&1
    ~/buster-fast-bench/exclusive.sh taskset -c 2 $d/rusage $runs $C $args > $out/rusage-$control.txt
    ~/buster-fast-bench/exclusive.sh taskset -c 2 strace -f -c -o $out/syscalls-$control.txt $C $args > /dev/null 2>&1
    ~/buster-fast-bench/exclusive.sh sh -c "a=\$(awk '/^thp_fault_alloc /{print \$2}' /proc/vmstat); i=0; while [ \$i -lt $runs ]; do taskset -c 2 $C $args > /dev/null 2>&1; i=\$((i + 1)); done; b=\$(awk '/^thp_fault_alloc /{print \$2}' /proc/vmstat); echo \"thp_fault_alloc over $runs runs: \$((b - a))\"" > $out/thp-$control.txt
    if [ $control != sqlite ]; then
        ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 setarch -R strace -f -k -e trace=mmap,munmap,mprotect,madvise,brk -o $out/strace-$control.txt $C $args > /dev/null 2>&1; taskset -c 2 setarch -R perf record -q -e page-faults -c 1 -d -o $out/faults-$control.data -- $C $args > /dev/null 2>&1"
        perf script -i $out/faults-$control.data -F addr,ip,sym 2>/dev/null > $out/faults-$control.txt
        rm -f $out/faults-$control.data
        python3 $d/attribute.py $out/strace-$control.txt $out/faults-$control.txt $out/sections.txt > $out/attribution-$control.txt
    fi
done
echo done > $out/done
