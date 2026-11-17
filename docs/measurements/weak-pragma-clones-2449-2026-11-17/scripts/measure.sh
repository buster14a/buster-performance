#!/bin/bash
# #2449's measurements on the 9700X: main (base) against the PR (head) for -fsyntax-only and -c of the frozen sqlite3.c,
# in a Williams order (base, head, base again), 3 fresh copies each. Each time-runs is one hold of the lock, on CPU 2.
set -uo pipefail
cd ~/buster-fast-bench/2449-claude
export EXCLUSIVE_OWNER=claude-2449 EXCLUSIVE_TITLE="Solve 2449 (#2896)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2896
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
S=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
mkdir -p results /dev/shm/2449-claude/copies
unset CPATH C_INCLUDE_PATH
note() { { echo "== $1 $(date -u +%FT%TZ)"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> results/context.txt; }
run() {
    local name=$1; shift
    note "$name before"
    ~/buster-fast-bench/exclusive.sh taskset -c 2 head/build/compiler time-runs "$@" > "results/$name.txt" 2> "results/$name.err" || echo "$name failed"
    note "$name after"
}
B=(--copies 3 --directory /dev/shm/2449-claude/copies --build base base/build/compiler --build head head/build/compiler --build base-again base/build/compiler)
run syntax --runs 15 --warmups 2 "${B[@]}" --list -fsyntax-only "${S[@]}"
run object --runs 9 --warmups 1 "${B[@]}" --list -c "${S[@]}" -o /dev/shm/2449-claude/sqlite3.o
rm -f /dev/shm/2449-claude/sqlite3.o
echo measure-done
