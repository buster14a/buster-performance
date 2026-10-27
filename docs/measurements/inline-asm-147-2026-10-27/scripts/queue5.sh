#!/usr/bin/env bash
# After queue4.sh (PID $1): the lowering benchmark on sqlite3.c, six more processes a tree in an ABBA order, each with
# its user instructions and cycles, in one hold of the lock (about 25 s).
cd ~/buster-fast-bench/asm-147-claude || exit 1
while kill -0 "$1" 2> /dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly lowering (#147, #126)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > step-lowering-sqlite2.sh <<'STEP'
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
for t in base head head base base head head base base head head base; do
    echo "== $t"
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u $t/build/compiler benchmark-lowering-source "${drive[@]}" "$corpus/sqlite/sqlite3.c" 2>&1 | grep -E "totals|instructions|cycles"
done
STEP
~/buster-fast-bench/exclusive.sh ./timed.sh bash step-lowering-sqlite2.sh > step-lowering-sqlite2.log 2>&1
echo "step lowering-sqlite2 $? $(tail -1 step-lowering-sqlite2.log)"
