#!/bin/bash
# Runs test-checker with each built mutant, after the builds, and records whether it failed and on which checks.
S=/tmp/claude-0/-home-user-buster/c45a68bf-d025-5d42-ba16-5bb54ca5630c/scratchpad
M=$S/mutants
until grep -q "^done" "$M/summary.txt" 2>/dev/null; do sleep 30; done
export BUSTER_CORPUS=/home/user/buster/build/corpus
: > "$M/results.txt"
for name in statement order past not conditional plain; do
    if grep -q "^$name build status 0" "$M/summary.txt"; then
        (cd "$M/$name" && nice -n 5 ./build/compiler test-checker --seed 133 > "$M/$name-checker.log" 2>&1); status=$?
        echo "$name test-checker status $status: $(grep -c 'branch-condition' "$M/$name-checker.log") branch-condition lines; $(tail -1 "$M/$name-checker.log")" >> "$M/results.txt"
        rm -rf "$M/$name/build/cmake"
    else
        echo "$name not built" >> "$M/results.txt"
    fi
done
echo done >> "$M/results.txt"
