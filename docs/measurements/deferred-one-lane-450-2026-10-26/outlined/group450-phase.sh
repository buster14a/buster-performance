#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
mode=$1
number=$2
test "${BUSTER_9700X_HELD:-}" = 1
inputs=/home/david/buster-fast-bench/deferred-lanes-claude/c-testsuite/tests/single-exec
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
run_pair()
{
    local name=$1 unit=$2 order=$3 file tree alias
    file="$inputs/$unit"
    if [[ $unit == sqlite ]]; then file=$sqlite; fi
    local trees=(base450-final head450-phase)
    if ((order % 2 != 0)); then trees=(head450-phase base450-final); fi
    for tree in "${trees[@]}"; do
        alias=base
        if [[ $tree == head450-phase ]]; then alias=head450; fi
        # Each invocation remains an independent process. held.sh only records the inherited actual lock.
        bash held.sh taskset -c 0-7 bash commands450.sh "$tree" "$file" > "logs/450-phase/$name-$alias.log" 2>&1
    done
}
case "$mode" in
    paired)
        units=(00001.c 00169.c 00213.c 00200.c 00182.c 00204.c sqlite 00066.c 00038.c 00075.c 00062.c)
        for unit in "${units[@]}"; do
            run_pair "paired-$number-$unit" "$unit" "$((number + 1))"
        done
        ;;
    sweep)
        mapfile -t files < <(find "$inputs" -type f -name '*.c' | sort)
        test "${#files[@]}" -eq 220
        index=0
        for file in "${files[@]}"; do
            unit=${file##*/}
            if [[ $unit == 00078.c ]]; then continue; fi
            if ((index / 80 == number)); then run_pair "sweep-$unit" "$unit" "$index"; fi
            index=$((index + 1))
        done
        test "$index" -eq 219
        ;;
    *) exit 2 ;;
esac
