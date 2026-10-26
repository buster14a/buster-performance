#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
test "${BUSTER_9700X_HELD:-}" = 1
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
inputs=/home/david/buster-fast-bench/deferred-lanes-claude/c-testsuite/tests/single-exec
bash held.sh bash provenance450-cold.sh > logs/450-cold-corpus/provenance-before.log 2>&1
mapfile -t files < <(find "$inputs" -type f -name '*.c' | sort)
test "${#files[@]}" -eq 220
for round in 1 2 3 4 5; do
    index=0
    for file in "${files[@]}"; do
        unit=${file##*/}
        if [[ $unit == 00078.c ]]; then continue; fi
        trees=(base450-cold head450-cold)
        if (((round + index + 1) % 2 != 0)); then trees=(head450-cold base450-cold); fi
        for tree in "${trees[@]}"; do
            alias=base
            if [[ $tree == head450-cold ]]; then alias=head450; fi
            bash held.sh taskset -c 0-7 bash commands450.sh "$tree" "$file" > "logs/450-cold-corpus/paired-$round-$unit-$alias.log" 2>&1
        done
        index=$((index + 1))
    done
    test "$index" -eq 219
done
bash held.sh bash provenance450-cold.sh > logs/450-cold-corpus/provenance-after.log 2>&1
