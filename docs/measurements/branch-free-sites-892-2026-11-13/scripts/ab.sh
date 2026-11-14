#!/bin/bash
# ab.sh NAME A B [ROUNDS]: for #892, on the 9700X pinned to CPU 2, -c sqlite3.c --lanes 1 by executables
# bin/compiler-A and bin/compiler-B, alternating their order each round:
#   hold 1: ROUNDS rounds of perf stat -r 3 each (user cycles, instructions, branches, mispredicted branches);
#   hold 2: ROUNDS rounds of one --time-stages run each.
# Raw outputs go to results/ab-NAME/.
set -u
name=${1:?name} a=${2:?a} b=${3:?b} rounds=${4:-10}
base=~/buster-fast-bench/892-claude
out=$base/results/ab-$name
mkdir -p "$out"
cd "$base/run" || exit 2
corpus=corpus
ARGS=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17
    -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
    -isystem "$corpus/headers/usr/include"
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c"
    -c -o "$base/scratch/ab-sq.o" --lanes 1)
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
export LC_ALL=C
sha256sum "$base/bin/compiler-$a" "$base/bin/compiler-$b" > "$out/sha256.txt"
if [ "${3:-}" != "" ] && [ -z "${AB_STEP:-}" ]; then
    ~/buster-fast-bench/exclusive.sh timeout 600 env AB_STEP=stat "$base/ab.sh" "$@" 2> "$out/stat.hold.log"
    ~/buster-fast-bench/exclusive.sh timeout 600 env AB_STEP=stages "$base/ab.sh" "$@" 2> "$out/stages.hold.log"
    echo done > "$out/done"
    exit 0
fi
case $AB_STEP in
    stat)
        for ((r = 0; r < rounds; r++)); do
            if ((r % 2 == 0)); then order=("$a" "$b"); else order=("$b" "$a"); fi
            for t in "${order[@]}"; do
                taskset -c 2 perf stat -x, -r 3 -o "$out/stat.r$r.$t.csv" \
                    -e '{cycles:u,instructions:u,ex_ret_brn:u,ex_ret_brn_misp:u,task-clock}' -- "$base/bin/compiler-$t" "${ARGS[@]}" > /dev/null 2>&1
            done
        done ;;
    stages)
        for ((r = 0; r < rounds; r++)); do
            if ((r % 2 == 0)); then order=("$a" "$b"); else order=("$b" "$a"); fi
            for t in "${order[@]}"; do
                taskset -c 2 "$base/bin/compiler-$t" "${ARGS[@]}" --time-stages > /dev/null 2> "$out/stages.r$r.$t.txt"
            done
        done ;;
esac
