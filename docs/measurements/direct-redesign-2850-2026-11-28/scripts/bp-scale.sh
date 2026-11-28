#!/bin/bash
# Today's direct path on N cores at once: N copies of the harness, each pinned to a core of its own and compiling
# sqlite3.c 30 times in its process. The batch's wall time gives the aggregate rate (N x 30 compiles), and each
# worker's own median the cost of a compile beside the others. One hold of the lock a count.
cd /tmp/2850-fermat
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
S=$C/sqlite/sqlite3.c
H=(--predefines $C/provenance/gnu17-pinned-predefines.txt -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $S)
export FEATURES=/tmp/2850-fermat/features.txt
export H_STR="${H[*]}"
run() {
  name=$1; shift
  env EXCLUSIVE_OWNER=claude-fermat-16yme8 EXCLUSIVE_TITLE="Direct path performance redesign: $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850 \
    timeout -k 5 300 ~/buster-fast-bench/exclusive.sh bash -c 'H=($H_STR); n=$1; shift; start=$(date +%s%N); for cpu in "$@"; do taskset -c $cpu ./direct-main "${H[@]}" --repeat 30 --summary -o /dev/shm/2850-fermat-scale-$cpu.o > scale-$n-$cpu.out 2>&1 & done; wait; end=$(date +%s%N); echo "workers $n cpus $* wall-ns $((end - start)) compiles $((30 * $#))"; for cpu in "$@"; do echo "workers $n cpu $cpu: $(grep -a median-ms scale-$n-$cpu.out)"; done; rm -f /dev/shm/2850-fermat-scale-*.o scale-$n-*.out' _ "$@" 2>&1 | grep -a "^workers"
}
lscpu -e=CPU,CORE | head -20 > scale-topology.txt
{
run "one core" 1 2
run "two cores" 2 2 4
run "four cores" 4 2 3 4 5
run "eight cores" 8 0 1 2 3 4 5 6 7
run "fifteen threads" 15 0 1 2 3 4 5 6 7 8 9 11 12 13 14 15
run "eight cores" 8b 0 1 2 3 4 5 6 7
} > scale.out 2>&1
touch scale.done
