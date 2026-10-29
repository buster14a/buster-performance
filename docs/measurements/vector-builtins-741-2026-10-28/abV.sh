#!/bin/bash
# buster14a/buster#741 (the generic vector builtins, the x86 leaves and the narrowing conversions, head 5fe76d3) against
# main c9a433b (base), with an A/A control (aa: a copy of base's executable, run as a third tree): each tree's build under
# its own hold of the 9700X's lock; the frozen sqlite3.c's -c object by each, which must be the same; the suites the head
# changes, on the head; perf stat of -fsyntax-only and -c in rotating rounds; and ab's rounds of time-runs. Every run
# takes the lock on its own, its receipt lines kept, and runs pinned to CPU 2, but the suites, on CPUs 0 to 7 as the job
# runs them.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #741's vector builtins against main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/741
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abV
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
done
mkdir -p aa/build && cp base/build/compiler aa/build/compiler
for tree in base aa head; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
done
cmp lower_base.o lower_head.o && cmp lower_base.o lower_aa.o && echo "lower objects identical"
cd head
run()
{
    local name=$1
    shift
    $lock taskset -c 0-7 ./build/compiler "$@" > ../test_$name.log 2>&1
    echo "$name status $?: $(grep -v '^exclusive.sh:\|^  ' ../test_$name.log | tail -1)"
}
run test-checker-program-vectors test-checker --program-vectors
run test-checker test-checker --seed 133
run test-tier0 test-tier0 --cross-check
run test-checker-driver test-checker-driver --executable ./build/compiler
run test-checker-deferred test-checker-deferred
run test-check-lanes test-check-lanes
cd ..
for round in 1 2 3; do
    for tree in base aa head; do
        echo "== round $round tree $tree drive" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>> perf.log >/dev/null
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>> perf.log >/dev/null
    done
done
echo "perf done"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base aa head -- time-runs --runs 11 --list -fsyntax-only "${check[@]}" --list -c -o /dev/null "${lower[@]}" > ab.log 2>&1
echo "ab status $?"
(cd base && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum) > source-base.sha256
(cd head && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum) > source-head.sha256
sha256sum base/build/compiler aa/build/compiler head/build/compiler lower_base.o lower_aa.o lower_head.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
echo "all done"
