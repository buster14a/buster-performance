#!/bin/bash
# facts.sh LABEL SUFFIX RUNS [shadow options]: measure-node-machine --shadow --facts on sqlite3.c, Lua and musl (the 9700X
# corpora, the node machine records' options) by results/LABEL/compiler, CPU 2, each corpus's each run its own hold of the
# lock, with what else ran. Files results/LABEL/facts-<corpus><SUFFIX>-N.txt.
set -u
cd "$(dirname "$0")"
label=$1; suffix=$2; runs=$3
shift 3
options="$*"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
musl=$corpus/libc/musl
export LC_ALL=C
out=$PWD/results/$label
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
moptions=$(printf '%q ' -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
list=$(printf '%q ' "${files[@]}")
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
for n in $(seq 1 $runs); do
    f=$out/facts-sqlite3$suffix-$n.txt
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c; echo status \$?; $busy" > $f 2>&1
    f=$out/facts-lua$suffix-$n.txt
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options $lua/*.c; echo status \$?; $busy" > $f 2>&1
    f=$out/facts-musl$suffix-$n.txt
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options $moptions $list; echo status \$?; $busy" > $f 2>&1
done
echo done
