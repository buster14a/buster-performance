#!/bin/bash
# The last round of #136's benchmark-backend-source PR on the 9700X, after merging main (#485's unwind tables among
# it), each run its own hold of the lock, pinned to CPU 2: sqlite3.c's -c, user instructions and cycles (perf stat
# -r 11), main's and the branch's in turn, two rounds, and benchmark-backend on each; then the new benchmark on the
# frozen sqlite3.c with the 9700X job's options, three times, its vector path alone, after 200 ms of the scalar one,
# and the scalar path alone.
export EXCLUSIVE_OWNER=claude-backend-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
quiet() { grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:"; }
for d in backend-136-main backend-136-claude; do
    nm -S --defined-only $B/$d/build/compiler | awk '$3 ~ /^[tT]$/ { print $4, $2 }' | sort > $B/$d/functions.txt
done
echo "== functions only in one or of another size: $(comm -3 $B/backend-136-main/functions.txt $B/backend-136-claude/functions.txt | wc -l)"
comm -3 $B/backend-136-main/functions.txt $B/backend-136-claude/functions.txt | grep -v 'tier0_benchmark\|backend_source\|check_test' | head -40
for round in 1 2; do
    for d in backend-136-main backend-136-claude; do
        cd $B/$d || exit 1
        $X taskset -c 2 perf stat -r 11 -x, -e instructions:u,cycles:u ./build/compiler -c -I$Q -o $B/$d/sqlite3.o $Q/sqlite3.c > perf-$round.log 2>&1
        echo "== $d -c perf round $round: $?"; quiet < perf-$round.log | grep -E 'instructions|cycles'
    done
done
for d in backend-136-main backend-136-claude; do
    cd $B/$d || exit 1
    $X taskset -c 2 ./build/compiler benchmark-backend > backend.log 2>&1
    echo "== $d benchmark-backend: $?"; quiet < backend.log
done
cd $B/backend-136-claude || exit 1
for round in 1 2 3; do
    $X taskset -c 2 ./build/compiler benchmark-backend-source "${source[@]}" > source-$round.log 2>&1
    echo "== benchmark-backend-source round $round: $?"; quiet < source-$round.log
done
$X taskset -c 2 ./build/compiler benchmark-backend-source --only vector "${source[@]}" > source-vector.log 2>&1
echo "== vector alone: $?"; quiet < source-vector.log | grep -E '^(variant|vector)'
$X taskset -c 2 ./build/compiler benchmark-backend-source --only vector --after-scalar 200 "${source[@]}" > source-after.log 2>&1
echo "== vector after 200 ms of scalar: $?"; quiet < source-after.log | grep -E '^(variant|vector)'
$X taskset -c 2 ./build/compiler benchmark-backend-source --only scalar "${source[@]}" > source-scalar.log 2>&1
echo "== scalar alone: $?"; quiet < source-scalar.log | grep -E '^(variant|scalar)'
echo done
