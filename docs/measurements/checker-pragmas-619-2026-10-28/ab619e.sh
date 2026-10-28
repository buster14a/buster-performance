#!/bin/bash
# #619's pull request head (77c45e3, the branch with main 241fcb3 merged) against that main: each build under its own
# hold of the 9700X's lock; the frozen sqlite3.c's -c object by each, which must be the same; -fsyntax-only of main.c
# with build.sh's flags; the checker's suites and the job's new step on the head; perf stat of -fsyntax-only and -c in
# rotating rounds; ab's rounds of time-runs; and where the head's instructions go (profile.sh). Every run takes the lock
# on its own and runs pinned to CPU 2, but the suites, on CPUs 0 to 7 as the job runs them.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #619's pull request against main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/619
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
export TMPDIR=~/buster-fast-bench/claude-126-cloud/ab619e/tmp
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
filter="^exclusive.sh:\|^  title:\|^  link:\|^  pull request:"
cd ~/buster-fast-bench/claude-126-cloud/ab619e
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh 2>&1 | grep -v "$filter" > ../build_$tree.log) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
    flags=$(sed -n 's/^flags=(\(.*\))$/\1/p' $tree/build.sh)
    (cd $tree && $lock taskset -c 2 ./build/compiler -fsyntax-only $flags src/buster/compiler/main.c 2>&1 | grep -v "$filter" > ../main_c_$tree.log; echo "main.c $tree status ${PIPESTATUS[0]}: $(grep -m1 error ../main_c_$tree.log)")
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" 2>&1 | grep -v "$filter" > lower_$tree.log
    echo "lower $tree status ${PIPESTATUS[0]}"
    $lock taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>&1 | grep -v "$filter" > drive_$tree.log
    echo "drive $tree status ${PIPESTATUS[0]}"
done
cmp lower_base.o lower_head.o && echo "lower objects identical"
cd head
run()
{
    local name=$1
    shift
    $lock taskset -c 0-7 ./build/compiler "$@" 2>&1 | grep -v "$filter" > ../test_$name.log
    echo "$name status ${PIPESTATUS[0]}: $(tail -1 ../test_$name.log)"
}
run test-checker-driver test-checker-driver --executable ./build/compiler
run test-checker-deferred test-checker-deferred
run test-checker test-checker --seed 133
run test-check-builtins-x86 test-check-builtins-x86
run test-builtin-intrinsic-catalog test-builtin-intrinsic-catalog
# The job's new step: -fsyntax-only of each unit build.sh compiles, but main_unit_*.c, with build.sh's flags, on one CPU.
flags=$(sed -n 's/^flags=(\(.*\))$/\1/p' build.sh)
units=$(sed -n 's/^sources=(\(.*\))$/\1/p' build.sh | tr ' ' '\n' | grep -v main_unit_ | tr '\n' ' ')
$lock taskset -c 2 bash -c "time (failed=0; count=0; for unit in $units; do count=\$((count + 1)); ./build/compiler -fsyntax-only $flags \$unit || failed=\$((failed + 1)); done; echo \"\$count units, \$failed failed\")" 2>&1 | grep -v "$filter" > ../test_units.log
echo "units: $(tr '\n' ' ' < ../test_units.log)"
cd ..
for round in 1 2 3; do
    for tree in base head; do
        echo "== round $round tree $tree drive" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>&1 >/dev/null | grep -v "$filter" >> perf.log
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>&1 >/dev/null | grep -v "$filter" >> perf.log
    done
done
echo "perf done"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- time-runs --runs 11 --list -fsyntax-only "${check[@]}" --list -c -o /dev/null "${lower[@]}" 2>&1 | grep -v "$filter" > ab.log
echo "ab status ${PIPESTATUS[0]}"
~/buster-fast-bench/claude-126-cloud/profile.sh ab619e base head drive 2>&1 | grep -v "$filter"
sha256sum base/build/compiler head/build/compiler lower_base.o lower_head.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
echo "all done"
