#!/bin/bash
# verify-main4b.sh: the rest of test-checker on the series' last tree (main4/compiler, native Develop): part 7 alone
# first (clang's own build of one oracle takes close to the harness's 60 seconds on this machine), then the others.
cd ~/.cache/claude-2524o/wt-main
out=~/.cache/claude-2524o/handoff/main4
$out/compiler test-checker --seed 133 --part 7/8 > $out/tests-7.log 2>&1; echo "exit $?" >> $out/tests-7.log
for k in 1 2 3; do ( $out/compiler test-checker --seed 133 --part $k/8 > $out/tests-$k.log 2>&1; echo "exit $?" >> $out/tests-$k.log ) & done; wait
for k in 4 6 8; do ( $out/compiler test-checker --seed 133 --part $k/8 > $out/tests-$k.log 2>&1; echo "exit $?" >> $out/tests-$k.log ) & done; wait
echo done > $out/done-all-parts
