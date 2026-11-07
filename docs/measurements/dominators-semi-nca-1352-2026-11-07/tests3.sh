#!/bin/sh
# The c-testsuite subset's dominator and SSA source tests (file list on one line), then profiles of the 16k inputs.
cd ~/buster-fast-bench/1352-claude || exit 1
subset=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt | tr '\n' ' ')
one() {
  ./run.sh t3.log sh -c "$1"
  printf '%.80s: %s | %s\n' "$1" "$(grep -av '^exclusive.sh\|^  title\|^  link\|^  pull request\|^exit' t3.log | tail -1)" "$(tail -1 t3.log)"
}
one "taskset -c 2 ./build/compiler test-ir-source --dominators $subset"
one "taskset -c 2 ./build/compiler test-ssa-source --typed --tier1 $subset"
for input in ifs-16000 ternary-16000; do
  ./run.sh prof.log ./prof.sh $input
  echo "== $input"; grep 'tier0' prof-stages.txt | head -1; cat prof-top.txt
done
echo finished
