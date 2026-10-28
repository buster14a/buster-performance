#!/bin/bash
# #619's head (head3) on the 9700X: the checker's suites that its changes reach, each under its own hold of the lock,
# with the oracle cache off, as a local run keeps nothing.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #619's checker suites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/619
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
export TMPDIR=~/buster-fast-bench/claude-126-cloud/ab619/tmp
export SOURCE_DATE_EPOCH=1792454400
filter="^exclusive.sh:\|^  title:\|^  link:\|^  pull request:"
cd ~/buster-fast-bench/claude-126-cloud/ab619/head3
run()
{
    local name=$1
    shift
    $lock taskset -c 0-7 ./build/compiler "$@" 2>&1 | grep -v "$filter" > ../test3_$name.log
    echo "$name status ${PIPESTATUS[0]}: $(tail -1 ../test3_$name.log)"
}
run test-checker-driver test-checker-driver --executable ./build/compiler
run test-checker-deferred test-checker-deferred
run test-checker test-checker --seed 133
run test-check-builtins-x86 test-check-builtins-x86
run test-builtin-intrinsic-catalog test-builtin-intrinsic-catalog
# The 9700X job's new step: -fsyntax-only of each unit build.sh compiles, but main_unit_*.c, with build.sh's flags, timed
# as the step's one CPU runs it.
flags=$(sed -n 's/^flags=(\(.*\))$/\1/p' build.sh)
units=$(sed -n 's/^sources=(\(.*\))$/\1/p' build.sh | tr ' ' '\n' | grep -v main_unit_ | tr '\n' ' ')
$lock taskset -c 2 bash -c "time (failed=0; count=0; for unit in $units; do count=\$((count + 1)); ./build/compiler -fsyntax-only $flags \$unit || failed=\$((failed + 1)); done; echo \"\$count units, \$failed failed\")" > ../test3_units.log 2>&1
grep -v "$filter" ../test3_units.log | tr '\n' ' '; echo
echo "tests done"
