#!/bin/sh
# Dominator consumers' tests, each under the lock separately; summary lines only.
cd ~/buster-fast-bench/1352-claude || exit 1
for t in "test-dominators" "test-dominators --seed 9 --count 300" "test-ir-optimize" "test-ir-gvn" "test-ir-licm" "test-ir" "test-ssa" "test-ssa-ir" "test-tier1-cfg" "test-tier1-liveness" "test-tier1-pipeline --cross-check" "test-tier1-masks" "test-tier1-frame" "test-tier1-allocation"; do
  ./run.sh t.log sh -c "taskset -c 2 ./build/compiler $t"
  printf '%s: %s | %s\n' "$t" "$(grep -v '^exclusive.sh\|^  title\|^  link' t.log | grep -v '^exit' | tail -1)" "$(tail -1 t.log)"
done
