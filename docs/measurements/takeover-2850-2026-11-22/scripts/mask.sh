#!/bin/bash
# mask.sh TREE ROUNDS: --time-stages of -c of the preprocessed sqlite3.c and of the frozen sqlite3.c, ordinary and with
# every function body masked (BUSTER_EXPERIMENT_MASK_BODIES), one lane on CPU 2, each run under the lock, in turn.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
tree=$1; rounds=$2
cc="$dir/trees/$tree/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/mask-$tree"
rm -rf "$out"; mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850 redesign: the unit with every body masked" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
one()
{
    local name=$1 mask=$2; shift 2
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "
        cd '$out'
        $mask taskset -c 2 '$cc' --lanes 1 -c $* -o x.o > /dev/null 2>&1
        $mask taskset -c 2 '$cc' --lanes 1 -c $* -o x.o --time-stages 2> '$name.stages'
        ls -l x.o | awk '{print \$5}' > '$name.size'
        rm -f x.o
    " 2>> "$out/lock.log"
}
real="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c"
for i in $(seq 1 "$rounds"); do
    one "i-whole-$i" "" "$dir/bound/sqlite3.i"
    one "i-masked-$i" "BUSTER_EXPERIMENT_MASK_BODIES=1" "$dir/bound/sqlite3.i"
    one "c-masked-$i" "BUSTER_EXPERIMENT_MASK_BODIES=1" "$real"
    one "c-whole-$i" "" "$real"
done
echo done > "$out/complete"
