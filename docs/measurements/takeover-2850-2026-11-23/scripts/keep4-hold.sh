#!/bin/bash
# keep4-hold.sh OUT: every workload in one hold; trees/keep4, BUSTER_EXPERIMENT_KEEP_UNITS 0 and 1, ABBA a round.
# place of a hold a position). One executable (trees/keep3), BUSTER_EXPERIMENT_KEEP_PAGES 0, 2 and 1 in turn, ABCCBA a
# round; each position one counted run (perf stat: user and kernel cycles, user instructions, faults, wall) after one
# warm-up a workload. Objects hashed by setting.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
out=$1
cc="$dir/trees/keep4/build/compiler"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$dir/inputs/lua-5.4.8/src
export LC_ALL=C BUSTER_EXPERIMENT_FRESH_LIST="$dir/zero26.list"
mkdir -p "$out/scratch"
cd "$out/scratch"
sq=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
manifest() { find . -maxdepth 1 -name '*.o' -print0 | sort -z | xargs -0 -r sha256sum | sha256sum | cut -c1-16; }
one()
{
    local workload=$1 round=$2 position=$3 setting=$4; shift 4
    rm -f ./*.o
    BUSTER_EXPERIMENT_KEEP_UNITS=$setting taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,duration_time -o "$out/$workload.r$round.p$position.s$setting.perf" -- "$cc" --lanes 1 -c "$@" > /dev/null 2> "$out/$workload.r$round.p$position.s$setting.err"
    echo "$? $(manifest) $(sha256sum < "$out/$workload.r$round.p$position.s$setting.err" | cut -c1-16)" > "$out/$workload.r$round.p$position.s$setting.sha"
}
workload()
{
    local name=$1 rounds=$2; shift 2
    rm -f ./*.o
    taskset -c 2 "$cc" --lanes 1 -c "$@" > /dev/null 2>&1
    for round in $(seq 1 "$rounds"); do
        position=0
        for setting in 0 1 1 0; do
            one "$name" "$round" "$position" "$setting" "$@"
            position=$((position + 1))
        done
    done
}
cat /proc/loadavg > "$out/load-before.txt"
workload twice 5 "${sq[@]}" "$sqlite/sqlite3.c" "$dir/inputs/sqlite3b.c"
workload sqlite 5 "${sq[@]}" "$sqlite/sqlite3.c"
workload mixed 5 "${sq[@]}" "$sqlite/sqlite3.c" "$sqlite/shell.c" "$lua/lapi.c" "$lua/lvm.c"
workload lua 5 "$lua"/*.c
workload musl 5 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}"
cat /proc/loadavg > "$out/load-after.txt"
rm -f ./*.o
echo done > "$out/complete"
