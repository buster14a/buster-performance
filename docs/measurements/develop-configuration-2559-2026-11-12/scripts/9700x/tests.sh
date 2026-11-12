#!/bin/bash
# (buster-performance stage1-build-design-2040-2026-11-12's scripts/tests.sh, for buster#2559) The run time of a fixed list of the compiler's own tests by one executable, to be run inside the 9700X lock
# (lock.sh): tests.sh NAME COMPILER [FIRST LAST]
# scripts/tests.list has the commands, one a line: the self-host gate's fourteen smoke commands (tools/ci/selfhost.c)
# and seven heavier ones of the correctness inventory that need no frozen input and no other compiler. Each runs once,
# from the `src` clone, with BUSTER_COMPILER naming the executable; FIRST and LAST (1-based) choose a range of the
# list, for an executable too slow to run it all in one hold. Each command's wall, user and system time and status go
# to results/tests/NAME.tsv.
set -u
export LC_ALL=C
name=$1; compiler=$2; first=${3:-1}; last=${4:-1000}
d=$HOME/buster-fast-bench/2559-claude
mkdir -p "$d/results/tests"
head -1 /var/lib/buster-9700x/owner > "$d/results/tests/$name.$first.holder.txt"
cd "$d/src" || exit 2
{ date -Is; ps -eo psr,pcpu,pid,etimes,comm --sort=-pcpu | head -8; } > "$d/results/tests/$name.$first.ps.txt"
export BUSTER_COMPILER=$compiler
TIMEFORMAT='%R %U %S'
index=0
while IFS= read -r line; do
    index=$((index + 1))
    if [ "$index" -ge "$first" ] && [ "$index" -le "$last" ]; then
        # shellcheck disable=SC2086
        { time timeout 540 "$compiler" $line > "$d/results/tests/$name.$index.log" 2>&1; } 2> "$d/results/tests/$name.$index.time"
        rc=$?
        printf '%s\t%s\t%s\trc=%s\n' "$index" "$line" "$(tail -1 "$d/results/tests/$name.$index.time")" "$rc" >> "$d/results/tests/$name.tsv"
    fi
done < "$d/scripts/tests.list"
