#!/bin/bash
# The head's suites that the change reaches, each run in a hold of its own: on the 9700X, AVX512VP2INTERSECT's and
# AVX-VNNI's forms execute too. Each log ends with the run's wall time (bash's time).
. "$(dirname "$0")/env.sh"
mkdir -p $M/tests
for t in "test-x86-semantics" "test-x86-semantics --cross-check" "test-x86-target" "test-checker --program-vectors" "test-tier0" "test-assembler --cross-check"; do
    name=$(echo "$t" | tr ' ' '_' | tr -d -)
    $X bash -c "cd $T/$HEAD && TIMEFORMAT='wall %R s' && time ./build/compiler $t" > $M/tests/$name.log 2>&1
    echo "$name: exit $?, $(grep -v '^wall' $M/tests/$name.log | tail -1 | cut -c1-160), $(grep '^wall' $M/tests/$name.log)"
done
