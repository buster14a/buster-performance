#!/bin/bash
M=/home/david/.cache/claude-134/mutants
S=$HOME/scratch
T=/home/david/.cache/claude-395/c-testsuite/tests/single-exec
unset CPATH C_INCLUDE_PATH
export TMPDIR=/home/david/.cache/claude-134/tmp
export CORES_TITLE="solve 134 mutants" CORES_LINK="https://github.com/buster14a/buster/issues/134"
renice -n 19 -p $$ > /dev/null; ionice -c 3 -p $$
while [ ! -f $S/mutants.done ]; do sleep 20; done
for m in stale stale-unverified; do
  cd $M/$m
  cores -n 3 -- env BUSTER_DEBUG_INFO=0 ./build.sh > $S/mutant-$m-build.log 2>&1
  cores -n 3 -- ./build/compiler test-ssa-source --generate 16 --seed 3 --clang clang > $S/mutant-$m-generated.log 2>&1; echo "status=$?" >> $S/mutant-$m-generated.log
  cores -n 3 -- ./build/compiler test-ssa-source $(sed -n "s|^\([0-9][0-9]*\)$|$T/\1.c|p" tests/c-testsuite/subset.txt | grep -v 00040) > $S/mutant-$m-subset.log 2>&1; echo "status=$?" >> $S/mutant-$m-subset.log
done
echo done > $S/mutants2.done
