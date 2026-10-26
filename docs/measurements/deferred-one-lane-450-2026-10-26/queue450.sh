#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_TITLE='FIFO campaign 2: #450 deferred one-lane dispatch'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/450
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/450
run()
{
    local name=$1
    shift
    "$lock" bash held.sh taskset -c 0-7 bash commands450.sh "$@" > "logs/450/$name.log" 2>&1
    printf '%s passed\n' "$name"
}
inputs=/home/david/buster-fast-bench/deferred-lanes-claude/inputs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
units=(00001.c 00169.c 00213.c 00200.c 00182.c 00204.c sqlite)
for round in 1 2 3 4 5; do
    trees=(base head450)
    if ((round % 2 == 0)); then trees=(head450 base); fi
    for unit in "${units[@]}"; do
        file="$inputs/$unit"
        if [[ $unit == sqlite ]]; then file=$sqlite; fi
        for tree in "${trees[@]}"; do
            run "paired-$round-$unit-$tree" "$tree" "$file"
        done
    done
done
mapfile -t sources < <(find /home/david/buster-fast-bench/deferred-lanes-claude/c-testsuite/tests/single-exec -name '*.c' -type f | sort)
test "${#sources[@]}" -eq 220
index=0
for file in "${sources[@]}"; do
    # This program declares linkage inside a body: both revisions correctly leave it to source order, so the
    # benchmark deliberately refuses it. All 220 programs remain in the correctness corpus comparison.
    if [[ ${file##*/} == 00078.c ]]; then
        printf 'excluded 00078.c: pre-existing source-order fallback for a declaration with linkage\n'
        continue
    fi
    trees=(base head450)
    if ((index % 2 != 0)); then trees=(head450 base); fi
    unit=${file##*/}
    for tree in "${trees[@]}"; do
        run "sweep-$unit-$tree" "$tree" "$file"
    done
    index=$((index + 1))
done
