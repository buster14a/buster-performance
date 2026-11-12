#!/bin/bash
# compile.sh ROUNDS NAME...: each NAME's (src-NAME's compiler's) --tier1 -c of speedtest1's unity file and of Lua's
# lvm.c, and its default -c of the unity file, as measure-tier1-programs' options give them; one untimed warm-up, then
# ROUNDS rounds, the NAMEs' order alternating by round; pinned to CPU 2, perf stat's task-clock and user cycles and
# instructions. Run inside one hold of the lock. results/compile.tsv: round, input, mode, name, ms, cycles,
# instructions, status; results/compile-objects.sha256 the objects of the last round.
set -u
cd "$(dirname "$0")"
rounds=$1; shift
out=$PWD/results
work=$PWD/scratch/compile
mkdir -p "$out" "$work"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
names=("$@"); count=${#names[@]}
events=task-clock,cycles:u,instructions:u
one()
{
    # $1 round, $2 input, $3 mode, $4 name
    local compiler=$PWD/src-$4/build/compiler status
    local mode=(); [ "$3" = tier1 ] && mode=(--tier1 -fno-asynchronous-unwind-tables)
    if [ "$2" = speedtest1 ]; then
        taskset -c 2 perf stat -x, -o "$work/stat.csv" -e "$events" -- "$compiler" "${mode[@]}" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 \
            -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$PWD/inputs" -o "$work/$2-$3-$4.o" "$work/speedtest1-unity.c" > /dev/null 2>&1
    else
        taskset -c 2 perf stat -x, -o "$work/stat.csv" -e "$events" -- "$compiler" "${mode[@]}" -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX \
            -o "$work/$2-$3-$4.o" "$PWD/inputs/lua-5.4.8/src/lvm.c" > /dev/null 2>&1
    fi
    status=$?
    awk -F, -v r="$1" -v i="$2" -v m="$3" -v n="$4" -v s="$status" '
        $3 ~ /task-clock/ { clock = $1 } $3 ~ /cycles/ { cycles = $1 } $3 ~ /instructions/ { instructions = $1 }
        END { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", r, i, m, n, clock, cycles, instructions, s }' "$work/stat.csv" >> "$out/compile.tsv"
}
for round in $(seq 0 "$rounds"); do
    for input in speedtest1 lvm; do
        for mode in tier1 default; do
            [ "$input" = lvm ] && [ "$mode" = default ] && continue
            for i in $(seq 0 $((count - 1))); do
                if [ $((round % 2)) = 0 ]; then k=$i; else k=$((count - 1 - i)); fi
                one "$round" "$input" "$mode" "${names[$k]}"
            done
        done
    done
done
(cd "$work" && sha256sum *.o) > "$out/compile-objects.sha256"
date -u +%FT%TZ > "$out/compile.done"
