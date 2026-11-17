#!/bin/bash
# #1380's measurements on the 9700X: main (base, d1cf1fe82) against the branch (head) for -E -P, -E and -c on the frozen
# sqlite3.c, and the branch's -C, -CC, -dD and -dI against its plain -E, on sqlite3.c and on this compiler's main.c.
# Each time-runs is one hold of the lock, pinned to CPU 2.
set -euo pipefail
cd ~/buster-fast-bench/1380-claude
export EXCLUSIVE_OWNER=claude-1380 EXCLUSIVE_TITLE="Solve 1380" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1380
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
S=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
M=(-target x86_64-pc-linux-gnu -march=native -Ihead/src -fwrapv -funsigned-char -DBUSTER_COMPLETE_DRIVER=1 head/src/buster/compiler/main.c)
mkdir -p results2 /dev/shm/1380-claude/copies
unset CPATH C_INCLUDE_PATH
note() { { echo "== $1 $(date -u +%FT%TZ)"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> results2/context.txt; }
run() {
    local name=$1; shift
    note "$name before"
    ~/buster-fast-bench/exclusive.sh taskset -c 2 head/build/compiler time-runs "$@" > "results2/$name.txt" 2> "results2/$name.err" || echo "$name failed"
    note "$name after"
}
run regression-e --runs 15 --warmups 2 --copies 3 --directory /dev/shm/1380-claude/copies --build base base/build/compiler --build head head/build/compiler --build base-again base/build/compiler \
    --list -E -P "${S[@]}" --list -E "${S[@]}"
run regression-c --runs 9 --warmups 1 --copies 3 --directory /dev/shm/1380-claude/copies --build base base/build/compiler --build head head/build/compiler --build base-again base/build/compiler \
    --list -c "${S[@]}" -o /dev/shm/1380-claude/sqlite3.o
run modes-sqlite --runs 15 --warmups 2 --executable head/build/compiler \
    --list -E -P "${S[@]}" --list -E -P -C "${S[@]}" --list -E -P -CC "${S[@]}" --list -E -dD -dI "${S[@]}" --list -E "${S[@]}" --list -E -C "${S[@]}"
run modes-main --runs 9 --warmups 1 --executable head/build/compiler \
    --list -E -P "${M[@]}" --list -E -P -C "${M[@]}" --list -E -P -CC "${M[@]}" --list -E -dD -dI "${M[@]}" --list -E "${M[@]}" --list -E -C "${M[@]}"
# The preprocessing's phases (read, lex, refine, directives, main loop), without printing, plain and with -C and -CC.
for mode in "" "-E -C" "-E -CC"; do
    name="phases${mode// /}"
    note "$name before"
    ~/buster-fast-bench/exclusive.sh taskset -c 2 head/build/compiler benchmark-preprocessor $mode "${S[@]}" > "results2/$name.txt" 2>&1 || echo "$name failed"
    note "$name after"
done
# What each mode prints, for the record (one run each, not timed), in one hold.
bytes() {
    for mode in "-E -P" "-E -P -C" "-E -P -CC" "-E -dD -dI" "-E" "-E -C"; do
        printf '%s\t%s\n' "$mode" "$(head/build/compiler $mode "${S[@]}" | wc -c)"
    done
}
export -f bytes
export S_LIST="$(printf '%q ' "${S[@]}")"
~/buster-fast-bench/exclusive.sh timeout -k 5 120 bash -c 'eval "S=($S_LIST)"; bytes' > results2/bytes-sqlite.tsv
echo done
