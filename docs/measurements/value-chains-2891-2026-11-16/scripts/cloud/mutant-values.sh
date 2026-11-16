#!/bin/bash
# The fifth #2891 mutant: #2883's rule alone (a conditional's condition as branches, no value's first operand), built in
# its own copy of HEAD, then test-checker's parts 4 and 5.
S=/root/.cache/claude-2891
M=$S/mutants
name=values
rm -rf "$M/$name"; mkdir -p "$M/$name"
git -C /home/user/buster archive HEAD | tar x -C "$M/$name"
python3 "$M/make.py" "$M/$name/src/buster/compiler/c_check_program_lower.c" "        if (!reuse && check_lower_branch_condition(program, a))" "        if (conditional && !reuse && check_lower_branch_condition(program, a))" || { echo "$name: mutation failed" >> "$M/results.txt"; exit 1; }
(cd "$M/$name" && BUSTER_DEBUG_INFO=0 nice -n 15 ./build.sh --config Release > build.log 2>&1); echo "$name build status $?" >> "$M/summary.txt"
export BUSTER_CORPUS=/home/user/buster/build/corpus
for part in 4 5; do
    (cd "$M/$name" && nice -n 5 ./build/compiler test-checker --seed 133 --part $part/8 > "$M/$name-part$part.log" 2>&1); status=$?
    echo "$name part $part status $status: $(grep -c 'branch-condition' "$M/$name-part$part.log") branch-condition lines, $(grep -ci 'shadow\|census' "$M/$name-part$part.log") shadow/census lines; $(tail -1 "$M/$name-part$part.log")" >> "$M/results.txt"
done
rm -rf "$M/$name/build/cmake"
echo "values done" >> "$M/results.txt"
