#!/bin/bash
# alone.sh TREE ROUNDS: measure-node-machine --shadow --front-alone-split on the frozen sqlite3.c, Lua and musl, CPU 2, each run
# under the lock: the machine with no node of the walk's, its reports and its ticks.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
tree=$1; rounds=$2
cc="$dir/trees/$tree/build/compiler"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sq=$corpus/sqlite
musl=$corpus/libc/musl
lua=$dir/inputs/lua-5.4.8/src
out="$dir/results/alone-split-$tree"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: the machine with no node of the walk's, in the shadow" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
for i in $(seq 1 "$rounds"); do
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "taskset -c 2 '$cc' measure-node-machine --shadow --front-alone-split -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c > '$out/sqlite-$i.txt' 2>&1; echo \$? > '$out/sqlite-$i.status'" 2>> "$out/lock.log"
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "taskset -c 2 '$cc' measure-node-machine --shadow --front-alone-split $lua/*.c > '$out/lua-$i.txt' 2>&1; echo \$? > '$out/lua-$i.status'" 2>> "$out/lock.log"
done
printf '%q ' "${files[@]}" > "$out/musl-files.txt"
for i in 1 2 3; do
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "taskset -c 2 '$cc' measure-node-machine --shadow --front-alone-split -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include $(cat $out/musl-files.txt) > '$out/musl-$i.txt' 2>&1; echo \$? > '$out/musl-$i.status'" 2>> "$out/lock.log"
done
grep -h 'alone bodies\|alone compared' "$out"/*.txt > "$out/summary.txt"
cat "$out"/*.status | sort | uniq -c >> "$out/summary.txt"
echo done > "$out/complete"
