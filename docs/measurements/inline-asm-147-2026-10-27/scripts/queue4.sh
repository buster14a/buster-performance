#!/usr/bin/env bash
# After queue3.sh's ab (PID $1): its per-run steps regrouped into a few holds of the lock, each well under a minute or
# two, base and head in an ABBA order inside each, pinned to CPU 2.
cd ~/buster-fast-bench/asm-147-claude || exit 1
killtree() { for c in $(ps -o pid= --ppid "$1"); do killtree "$c"; done; kill "$1" 2> /dev/null; }
while ! grep -q "ab sqlite" queue3.log; do sleep 5; done
killtree "$1"
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly lowering (#147, #126)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
L=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > step-perf.sh <<'STEP'
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
for t in base head head base; do taskset -c 2 perf stat -r 11 -e instructions:u,cycles:u,task-clock $t/build/compiler -c "${drive[@]}" "$corpus/sqlite/sqlite3.c" -o /dev/null 2>&1 | sed "s/^/$t: /"; done
taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 3 --list -c "${drive[@]}" bench/asm.c -o /dev/null --list -c "${drive[@]}" bench/plain.c -o /dev/null
for f in asm plain plain asm; do taskset -c 2 perf stat -r 11 -e instructions:u,cycles:u,task-clock head/build/compiler -c "${drive[@]}" bench/$f.c -o /dev/null 2>&1 | sed "s/^/$f: /"; done
STEP
cat > step-assembler.sh <<'STEP'
for t in base head head base; do echo "== $t"; taskset -c 2 $t/build/compiler benchmark-assembler; done
STEP
cat > step-lowering.sh <<'STEP'
for t in base head head base; do echo "== $t"; taskset -c 2 $t/build/compiler benchmark-lowering-source c-testsuite/tests/single-exec/*.c; done
STEP
cat > step-lowering-sqlite.sh <<'STEP'
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
for t in base head head base; do echo "== $t"; taskset -c 2 $t/build/compiler benchmark-lowering-source "${drive[@]}" "$corpus/sqlite/sqlite3.c"; done
STEP
cat > step-tests.sh <<'STEP'
for t in base head head base; do echo "== $t"; taskset -c 2 head/build/compiler time-runs --runs 3 --warmups 1 --executable $t/build/compiler --list test-assembler --cross-check | grep -E "^list|failed"; done
STEP
for s in perf assembler lowering lowering-sqlite tests; do
    $L ./timed.sh bash step-$s.sh > step-$s.log 2>&1
    echo "step $s $? $(tail -1 step-$s.log)"
done
echo done
