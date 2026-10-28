#!/bin/bash
# One job's runs (batch.sh runs it inside a lock hold): benchmark-checker-deferred on one unit, a process per run, each
# run's heading, output and exit status appended to the log. Arguments: LOG ROUND UNIT FILE PASSES then one or more runs,
# each TREE:LANES[:every[:TAKE]] (the tree's build/compiler under the work directory, --lanes, --every-lane with
# `every`, and --take TAKE when given, which only the `variants` tree takes).
D=~/buster-fast-bench/deferred-first-claude
L="$1"
round="$2"
unit="$3"
file="$4"
passes="$5"
shift 5
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
for run in "$@"; do
    IFS=: read -r tree lanes every take <<< "$run"
    extra=()
    name="$tree"
    if [ "$every" = every ]; then
        extra+=(--every-lane)
        name="$name-every"
    fi
    if [ -n "$take" ]; then
        extra+=(--take "$take")
        name="$name-$take"
    fi
    echo "== round $round $name $unit lanes $lanes" >> "$L"
    "$D/$tree/build/compiler" benchmark-checker-deferred --passes "$passes" --lanes "$lanes" --cpus 2,0,1,3,4,5,6,7 "${extra[@]}" "${options[@]}" "$file" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
done
