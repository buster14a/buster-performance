#!/bin/bash
# The head's suites that the change reaches, each run in a hold of its own: on the 9700X the AVX-512 VL forms the
# laptop's target table leaves out execute too. Each log ends with the run's wall time (bash's time).
. "$(dirname "$0")/env.sh"
mkdir -p $M/tests
for t in "test-x86-semantics --cross-check" "test-x86-semantics" "test-assembler --cross-check" "test-tier0"; do
    name=$(echo "$t" | tr ' ' '_' | tr -d -)
    $X bash -c "cd $T/head && TIMEFORMAT='wall %R s' && time ./build/compiler $t" > $M/tests/$name.log 2>&1
    echo "$name: exit $?, $(grep -v '^wall' $M/tests/$name.log | tail -1 | cut -c1-120), $(grep '^wall' $M/tests/$name.log)"
done
