#!/bin/bash
# 786-claude: benchmark-ir-source's verify, verify-scalar and promote on the frozen sqlite3.c, with the 9700X workflow's
# options, for each tree's shifted builds, pinned to CPU 2. One hold of the 9700X's lock per placement and round runs
# every tree there, the trees' order turning.
#   ./source.sh OUT ROUNDS TREE...   (shifts-TREE/compiler-SHIFT for SHIFT in $SHIFTS)
set -u
cd ~/buster-fast-bench/786-claude
export EXCLUSIVE_OWNER=claude-786 EXCLUSIVE_TITLE="Solve 786 (IR verifier/CFG/optimizer placements)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/786
if [ "$1" = --one ]; then
    # Under the lock: OUT ROUND SHIFT TREE...
    out=$2 round=$3 bytes=$4
    shift 4
    unset CPATH C_INCLUDE_PATH
    export SOURCE_DATE_EPOCH=1792454400
    corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
    source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
    for tree in "$@"; do
        for only in verify verify-scalar promote; do
            taskset -c 2 "shifts-$tree/compiler-$bytes" benchmark-ir-source --only "$only" "${source[@]}" > "$out/$tree-$bytes-$round-$only.txt" 2>&1
            echo "$(date +%T) round $round shift $bytes $tree $only status $?"
        done
    done
    exit 0
fi
out=$1 rounds=$2
shift 2
trees=("$@")
mkdir -p "$out"
for ((round = 0; round < rounds; round += 1)); do
    s=0
    for bytes in ${SHIFTS:-0 1344}; do
        order=()
        for ((t = 0; t < ${#trees[@]}; t += 1)); do
            order+=("${trees[$(((t + s + round) % ${#trees[@]}))]}")
        done
        ~/buster-fast-bench/exclusive.sh ./source.sh --one "$out" "$round" "$bytes" "${order[@]}"
        s=$((s + 1))
    done
done
echo source-done
