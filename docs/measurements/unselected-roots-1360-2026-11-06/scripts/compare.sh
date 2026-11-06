#!/bin/bash
# Round 1's outputs: each workload's diagnostics (the stage clock's lines aside) and its object, base against head.
cd ~/buster-fast-bench/1360-opencode/out || exit 2
for base in first-*-base.stderr; do
    name=${base#first-}; name=${name%-base.stderr}
    head=first-$name-head.stderr
    d=$(diff <(grep -v -E '^(time-|worker-budget|lowering-nodes)' "$base") <(grep -v -E '^(time-|worker-budget|lowering-nodes)' "$head") > /dev/null && echo same || echo DIFFERENT)
    lines=$(grep -v -E '^(time-|worker-budget|lowering-nodes)' "$head" | wc -l)
    o=none
    if [[ -f first-$name-base.o && -f first-$name-head.o ]]; then
        o=$(cmp -s first-$name-base.o first-$name-head.o && echo identical || echo DIFFERENT)
    fi
    printf '%s\tdiagnostics %s (%s lines)\tobject %s\n' "$name" "$d" "$lines" "$o"
done
