#!/bin/bash
# [RUNS=NAME] selfhost-runs.sh ROUNDS NAME...: each stage 2 compiler (scratch/selfhost/NAME/compiler) compiling the frozen
# sqlite3.c with the 9700X job's options, by its default tier and by --tier1 (two workloads: the front end, the checker
# and Tier 0; and Tier 1's own pipeline), one lane, pinned to CPU 2, counted by perf stat; one untimed warm-up, then
# ROUNDS rounds with the builds' order rotated and reversed by round. Before any timing every build's objects are
# compared: each workload's object must be the same bytes by every build. Run inside one hold of the lock.
# results/selfhost/runs.tsv: phase, round, workload, build, task-clock ms, user cycles, instructions, branches, misses,
# status; results/selfhost/checks.txt.
set -u
cd "$(dirname "$0")"
rounds=$1; shift
out=$PWD/results/selfhost
runs=${RUNS:-runs}
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tmp=$(mktemp -d /tmp/claude-tier1-quality-selfhost.XXXXXX)
status=0
: > "$out/$runs-checks.txt"
for workload in default tier1; do
    extra=(); [ $workload = tier1 ] && extra=(--tier1)
    for b in "$@"; do
        "scratch/selfhost/$b/compiler" --lanes 1 "${extra[@]}" "${options[@]}" -o "$tmp/$workload-$b.o" > /dev/null 2>&1 || status=1
        echo "$workload $b $(sha256sum < "$tmp/$workload-$b.o" | cut -c1-64)" >> "$out/$runs-checks.txt"
        cmp -s "$tmp/$workload-$b.o" "$tmp/$workload-$1.o" || { status=1; echo "$workload $b DIFFERS" >> "$out/$runs-checks.txt"; }
    done
done
if [ $status != 0 ]; then echo "status $status (checks failed; nothing timed)" >> "$out/$runs-checks.txt"; rm -rf "$tmp"; exit 1; fi
events=task-clock,cycles:u,instructions:u,branches:u,branch-misses:u
builds=("$@"); count=${#builds[@]}
for round in $(seq 0 "$rounds"); do
    phase=measured; [ "$round" = 0 ] && phase=warmup
    for workload in default tier1; do
        extra=(); [ $workload = tier1 ] && extra=(--tier1)
        for i in $(seq 0 $((count - 1))); do
            if [ $((round % 2)) = 0 ]; then k=$(((i + round) % count)); else k=$(((count - 1 - i + round) % count)); fi
            b=${builds[$k]}
            taskset -c 2 perf stat -x, -o "$tmp/stat.csv" -e "$events" -- "scratch/selfhost/$b/compiler" --lanes 1 "${extra[@]}" "${options[@]}" -o "$tmp/out.o" > /dev/null 2>&1
            code=$?
            awk -F, -v p="$phase" -v r="$round" -v g="$workload" -v b="$b" -v c="$code" '
                $3 ~ /task-clock/ { clock = $1 } $3 ~ /cycles/ { cycles = $1 } $3 ~ /instructions/ { instructions = $1 }
                $3 ~ /^branches/ { branches = $1 } $3 ~ /branch-misses/ { misses = $1 }
                END { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", p, r, g, b, clock, cycles, instructions, branches, misses, c }' "$tmp/stat.csv" >> "$out/$runs.tsv"
            [ "$code" = 0 ] || status=1
        done
    done
done
rm -rf "$tmp"
echo "status $status" >> "$out/$runs-checks.txt"
date -u +%FT%TZ > "$out/$runs.done"
exit $status
