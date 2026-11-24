#!/bin/bash
# #1340 part 2's fault round: test-checker-driver --branch-truth-only with each rule of the bit broken in turn
# (mutants.py's switch). Usage: fault-round.sh COMPILER > fault-round.txt
compiler=$1
for mutant in 0 $(seq 1 20) $(seq 23 47) $(seq 50 76); do
    out=$(BUSTER_TRUTH_MUTANT=$mutant "$compiler" test-checker-driver --executable "$compiler" --branch-truth-only 2>&1)
    failures=$(printf '%s\n' "$out" | sed -n 's/^checker-driver: [0-9]* checks, \([0-9]*\) failures$/\1/p')
    unsound=$(printf '%s\n' "$out" | grep -c 'unsound [1-9]')
    which=$(printf '%s\n' "$out" | sed -n 's/^test-checker: a branch condition.s bit is sound on \(the [a-z]* [a-z]*\|generated\).*/\1/p' | sort | uniq -c | tr -s ' \n' ' ')
    printf 'mutant %s: failures %s, reports of an unsound unit %s;%s\n' "$mutant" "$failures" "$unsound" "$which"
done
