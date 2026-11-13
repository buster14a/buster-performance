#!/bin/bash
# place-runs.sh ROUNDS TREE...: each TREE's eight shifted speedtest1 executables (scratch/place/TREE/speedtest1-SHIFT) run
# as measure-tier1-programs runs speedtest1 (fresh database on /tmp's tmpfs, #136's options), pinned to CPU 2, counted by
# perf stat; each executable verified first (--verify's hash), one untimed warm-up, then ROUNDS rounds; within a round
# every shift's TREEs run back to back, in an order alternating by round and shift. #138's record's exp-runs.sh. Run
# inside one hold of the lock. results/place/runs.tsv: phase, round, shift, tree, task-clock ms, user cycles,
# instructions, branches, misses, status.
set -u
cd "$(dirname "$0")"
rounds=$1; shift
out=$PWD/results/place
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
options="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
tmp=$(mktemp -d /tmp/claude-2541-place.XXXXXX)
shifts=(0 528 1056 1584 2112 2640 3168 3696)
status=0
here=$PWD
for name in "$@"; do
    for shift in "${shifts[@]}"; do
        rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"
        hash=$(cd "$tmp/db" && SQLITE_TMPDIR=$tmp/db/tmp "$here/scratch/place/$name/speedtest1-$shift" $options --verify speedtest1.db 2>&1 | grep 'Verification Hash')
        echo "$name $shift $hash" >> "$out/checks.txt"
        [ "$hash" = "Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739" ] || status=1
    done
done
if [ $status != 0 ]; then echo "status $status (checks failed; nothing timed)" >> "$out/checks.txt"; rm -rf "$tmp"; exit 1; fi
events=task-clock,cycles:u,instructions:u,branches:u,branch-misses:u
names=("$@"); count=${#names[@]}
for round in $(seq 0 "$rounds"); do
    phase=measured; [ "$round" = 0 ] && phase=warmup
    s=0
    for shift in "${shifts[@]}"; do
        for i in $(seq 0 $((count - 1))); do
            if [ $(((round + s) % 2)) = 0 ]; then k=$i; else k=$((count - 1 - i)); fi
            name=${names[$k]}
            rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"
            (cd "$tmp/db" && SQLITE_TMPDIR=$tmp/db/tmp taskset -c 2 perf stat -x, -o "$tmp/stat.csv" -e "$events" -- "$here/scratch/place/$name/speedtest1-$shift" $options speedtest1.db > /dev/null 2>&1)
            code=$?
            awk -F, -v p="$phase" -v r="$round" -v g="$shift" -v b="$name" -v c="$code" '
                $3 ~ /task-clock/ { clock = $1 } $3 ~ /cycles/ { cycles = $1 } $3 ~ /instructions/ { instructions = $1 }
                $3 ~ /^branches/ { branches = $1 } $3 ~ /branch-misses/ { misses = $1 }
                END { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", p, r, g, b, clock, cycles, instructions, branches, misses, c }' "$tmp/stat.csv" >> "$out/runs.tsv"
            [ "$code" = 0 ] || status=1
        done
        s=$((s + 1))
    done
done
rm -rf "$tmp"
echo "status $status" >> "$out/checks.txt"
date -u +%FT%TZ > "$out/runs.done"
exit $status
