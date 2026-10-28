#!/bin/bash
# #136's producer of vectors (c0b216d, the branch with main 241fcb3 merged) against that main (base, the build #619's
# record made, ../ab619e/base): the head's build under its own hold of the 9700X's lock; the frozen sqlite3.c's -c object
# by each, which must be the same; the suites the producer reaches on the head; perf stat of -fsyntax-only and -c in
# rotating rounds; ab's rounds of time-runs; and where the head's -c instructions go (profile.sh). Every run takes the
# lock on its own and runs pinned to CPU 2, but the suites, on CPUs 0 to 7 as the job runs them.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #136's vector producer against main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/136
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
export TMPDIR=~/buster-fast-bench/claude-126-cloud/abP2/tmp
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
filter="^exclusive.sh:\|^  title:\|^  link:\|^  pull request:"
cd ~/buster-fast-bench/claude-126-cloud/abP2
(cd head && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh 2>&1 | grep -v "$filter" > ../build_head.log) || { echo "build head failed"; exit 1; }
echo "built head: $(grep 'sources compiled' build_head.log)"
$lock taskset -c 2 head/build/compiler -c -o lower_head.o "${lower[@]}" 2>&1 | grep -v "$filter" > lower_head.log
echo "lower head status ${PIPESTATUS[0]}"
$lock taskset -c 2 head/build/compiler -fsyntax-only "${check[@]}" 2>&1 | grep -v "$filter" > drive_head.log
echo "drive head status ${PIPESTATUS[0]}"
cmp ../ab619e/lower_base.o lower_head.o && echo "lower objects identical"
cd head
run()
{
    local name=$1
    shift
    $lock taskset -c 0-7 ./build/compiler "$@" 2>&1 | grep -v "$filter" > ../test_$name.log
    echo "$name status ${PIPESTATUS[0]}: $(tail -1 ../test_$name.log)"
}
run test-checker test-checker --seed 133
run test-tier0 test-tier0 --cross-check
run test-checker-driver test-checker-driver --executable ./build/compiler
run test-checker-deferred test-checker-deferred
run test-check-lanes test-check-lanes
run test-calling-convention test-calling-convention --cross-check
run test-check-builtins-x86 test-check-builtins-x86
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
~/buster-fast-bench/claude-126-cloud/profile.sh abP2 base head lower 2>&1 | grep -v "$filter"
sha256sum base/build/compiler head/build/compiler ../ab619e/lower_base.o lower_head.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
echo "all done"
