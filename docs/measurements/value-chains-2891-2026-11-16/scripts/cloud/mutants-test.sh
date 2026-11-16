#!/bin/bash
# Runs test-checker with each built #2891 mutant, after the builds, and records whether it failed and on which checks.
S=/root/.cache/claude-2891
M=$S/mutants
until grep -q "^done" "$M/summary.txt" 2>/dev/null; do sleep 30; done
export BUSTER_CORPUS=/home/user/buster/build/corpus
: > "$M/results.txt"
for name in value sense conditional machine; do
    if grep -q "^$name build status 0" "$M/summary.txt"; then
        for part in 4 5; do
            (cd "$M/$name" && nice -n 5 ./build/compiler test-checker --seed 133 --part $part/8 > "$M/$name-part$part.log" 2>&1); status=$?
            echo "$name part $part status $status: $(grep -c 'branch-condition' "$M/$name-part$part.log") branch-condition lines, $(grep -ci 'shadow\|census' "$M/$name-part$part.log") shadow/census lines; $(tail -1 "$M/$name-part$part.log")" >> "$M/results.txt"
        done
        rm -rf "$M/$name/build/cmake"
    else
        echo "$name not built" >> "$M/results.txt"
    fi
done
echo done >> "$M/results.txt"
