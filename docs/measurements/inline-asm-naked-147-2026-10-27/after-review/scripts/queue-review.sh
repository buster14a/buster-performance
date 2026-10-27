#!/usr/bin/env bash
# #565 after its review fix: main at a66f8638 (base) against the PR's head
# e1dc5d01 (head), each command under the 9700X's lock on its own, on CPU 2.
cd ~/buster-fast-bench/asm-147d-claude || exit 1
mkdir -p tmp && export TMPDIR=$PWD/tmp
echo $$ > queue.pid
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly: naked functions and symbols (#147)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/565
L=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for t in base head; do (cd $t && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 $L ./build.sh > build.log 2>&1; echo "$t build $?"); done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
# Without --clang-features, as #535's record and this PR's first one: with it, sqlite3.c takes __atomic_store_n, which
# the lowering refuses.
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
sqlite="$corpus/sqlite/sqlite3.c"
for t in base head; do $L taskset -c 2 $t/build/compiler -c "${drive[@]}" "$sqlite" -o drive-$t.o > drive-$t.log 2>&1; echo "$t drive check $? $(md5sum < drive-$t.o 2>/dev/null)"; done
# The whole driver's -c of SQLite, interleaved rounds of fresh processes.
./head/build/compiler ab --rounds 5 --cpu 2 --lock $L base head \
    -- time-runs --runs 11 --list -c "${drive[@]}" "$sqlite" -o /dev/null > ab-sqlite.log 2>&1
echo "ab sqlite $?"
for r in 1 2; do
    order="base head"
    if [ $r -eq 2 ]; then order="head base"; fi
    for t in $order; do
        $L taskset -c 2 perf stat -r 11 -e instructions:u,cycles:u,task-clock $t/build/compiler -c "${drive[@]}" "$sqlite" -o /dev/null > perf-sqlite-$t-$r.log 2>&1; echo "$t perf sqlite $r $?"
    done
done
echo done
