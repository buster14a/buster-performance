#!/usr/bin/env bash
# #147's inline assembly (PR from claude/inline-asm-lowering-126-9c1d15): main at its merge-base (base) against the
# branch's head (head), each command under the 9700X's lock on its own, on CPU 2.
cd ~/buster-fast-bench/asm-147-claude || exit 1
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly lowering (#147, #126)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
L=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
# The trees were built by queue.sh (base and head, BUSTER_DEBUG_INFO=0, build 0 each).
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
# Without --clang-features: with it, sqlite3.c takes __atomic_store_n, which main's lowering refuses.
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
sqlite="$corpus/sqlite/sqlite3.c"
for t in base head; do $t/build/compiler -c "${drive[@]}" "$sqlite" -o drive-$t.o > drive-$t.log 2>&1; echo "$t drive check $? $(md5sum < drive-$t.o 2>/dev/null)"; done
for t in head; do for f in asm plain; do $t/build/compiler -c "${drive[@]}" bench/$f.c -o $f-$t.o > $f-$t.log 2>&1; echo "$t $f check $?"; done; done
# The whole driver's -c of SQLite, interleaved rounds of fresh processes.
./head/build/compiler ab --rounds 5 --cpu 2 --lock $L base head \
    -- time-runs --runs 11 --list -c "${drive[@]}" "$sqlite" -o /dev/null > ab-sqlite.log 2>&1
echo "ab sqlite $?"
for r in 1 2; do
    order="base head"
    if [ $r -eq 2 ]; then order="head base"; fi
    for t in $order; do
        $L taskset -c 2 perf stat -r 11 -e instructions:u,cycles:u,task-clock $t/build/compiler -c "${drive[@]}" "$sqlite" -o /dev/null > perf-sqlite-$t-$r.log 2>&1; echo "$t perf sqlite $r $?"
        $L taskset -c 2 $t/build/compiler benchmark-assembler > assembler-$t-$r.log 2>&1; echo "$t assembler $r $?"
        $L taskset -c 2 $t/build/compiler benchmark-lowering-source c-testsuite/tests/single-exec/*.c > lowering-$t-$r.log 2>&1; echo "$t lowering c-testsuite $r $?"
        $L taskset -c 2 $t/build/compiler benchmark-lowering-source "${drive[@]}" "$sqlite" > lowering-sqlite-$t-$r.log 2>&1; echo "$t lowering sqlite $r $?"
        $L taskset -c 2 ./head/build/compiler time-runs --runs 3 --warmups 1 --executable $t/build/compiler --list test-assembler --cross-check > test-assembler-$t-$r.log 2>&1; echo "$t test-assembler $r $?"
        $L taskset -c 0-7 ./timed.sh $t/build/compiler test-checker --seed 133 > test-checker-$t-$r.log 2>&1; echo "$t test-checker $r $? $(tail -1 test-checker-$t-$r.log)"
    done
done
# What an asm statement costs -c: 1,000 functions of 4 statements against the same functions in plain C (head only:
# main refuses them).
$L taskset -c 2 ./head/build/compiler time-runs --runs 21 --warmups 3 --executable head/build/compiler \
    --list -c "${drive[@]}" bench/asm.c -o /dev/null --list -c "${drive[@]}" bench/plain.c -o /dev/null > asm-cost.log 2>&1
echo "asm cost $?"
for f in asm plain; do $L taskset -c 2 perf stat -r 11 -e instructions:u,cycles:u,task-clock head/build/compiler -c "${drive[@]}" bench/$f.c -o /dev/null > perf-$f.log 2>&1; echo "perf $f $?"; done
echo done
