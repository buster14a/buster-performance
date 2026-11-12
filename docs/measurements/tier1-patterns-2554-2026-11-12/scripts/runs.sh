#!/bin/bash
# runs.sh ROUNDS NAME...: each NAME's placements (programs.sh's) run as measure-tier1-programs runs the
# programs: speedtest1 with #136's options from a fresh database on /tmp's tmpfs, and Lua's five scripts; pinned to
# CPU 2, counted by perf stat. Before any timing every executable is checked: speedtest1's verification hash, and each
# script's output against clang -O2's (scratch/main/lua-clang2). One untimed warm-up, then ROUNDS rounds; within a
# round every placement's NAMEs run back to back, in an order alternating by round and placement. Run inside one hold
# of the lock. results/proto/runs.tsv: phase, round, program, placement, name, task-clock ms, user cycles,
# instructions, branches, misses, status.
set -u
cd "$(dirname "$0")"
rounds=$1; shift
out=$PWD/results
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
options="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
tmp=$(mktemp -d /tmp/claude-2554-runs.XXXXXX)
shifts=(0 528 1056 1584 2112 2640 3168 3696)
orders=(0 8 16 24)
scripts=(calls tables strings arithmetic closures)
status=0
here=$PWD
for s in "${scripts[@]}"; do cp "$here/scratch/oracle/$s.expected" "$tmp/$s.expected" || status=1; done
for name in "$@"; do
    for shift in "${shifts[@]}"; do
        rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"
        hash=$(cd "$tmp/db" && SQLITE_TMPDIR=$tmp/db/tmp "$here/scratch/$name/speedtest1-$shift" $options --verify speedtest1.db 2>&1 | grep 'Verification Hash')
        echo "$name speedtest1 $shift $hash" >> "$out/checks.txt"
        [ "$hash" = "Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739" ] || status=1
    done
    for order in "${orders[@]}"; do
        for s in "${scripts[@]}"; do
            (cd "$here/inputs/scripts" && "$here/scratch/$name/lua-$order" "$s.lua") > "$tmp/$s.out" 2>&1 || status=1
            if cmp -s "$tmp/$s.out" "$tmp/$s.expected"; then echo "$name lua $order $s same" >> "$out/checks.txt"; else echo "$name lua $order $s DIFFERS" >> "$out/checks.txt"; status=1; fi
        done
    done
done
if [ $status != 0 ]; then echo "status $status (checks failed; nothing timed)" >> "$out/checks.txt"; rm -rf "$tmp"; exit 1; fi
events=task-clock,cycles:u,instructions:u,branches:u,branch-misses:u
names=("$@"); count=${#names[@]}
record()
{
    # $1 phase, $2 round, $3 program, $4 placement, $5 name, $6 status
    awk -F, -v p="$1" -v r="$2" -v g="$3" -v l="$4" -v b="$5" -v c="$6" '
        $3 ~ /task-clock/ { clock = $1 } $3 ~ /cycles/ { cycles = $1 } $3 ~ /instructions/ { instructions = $1 }
        $3 ~ /^branches/ { branches = $1 } $3 ~ /branch-misses/ { misses = $1 }
        END { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", p, r, g, l, b, clock, cycles, instructions, branches, misses, c }' "$tmp/stat.csv" >> "$out/runs.tsv"
}
for round in $(seq 0 "$rounds"); do
    phase=measured; [ "$round" = 0 ] && phase=warmup
    s=0
    for shift in "${shifts[@]}"; do
        for i in $(seq 0 $((count - 1))); do
            if [ $(((round + s) % 2)) = 0 ]; then k=$i; else k=$((count - 1 - i)); fi
            name=${names[$k]}
            rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"
            (cd "$tmp/db" && SQLITE_TMPDIR=$tmp/db/tmp taskset -c 2 perf stat -x, -o "$tmp/stat.csv" -e "$events" -- "$here/scratch/$name/speedtest1-$shift" $options speedtest1.db > /dev/null 2>&1)
            code=$?
            record "$phase" "$round" speedtest1 "$shift" "$name" "$code"
            [ "$code" = 0 ] || status=1
        done
        s=$((s + 1))
    done
    for order in "${orders[@]}"; do
        for script in "${scripts[@]}"; do
            for i in $(seq 0 $((count - 1))); do
                if [ $(((round + s) % 2)) = 0 ]; then k=$i; else k=$((count - 1 - i)); fi
                name=${names[$k]}
                (cd "$here/inputs/scripts" && taskset -c 2 perf stat -x, -o "$tmp/stat.csv" -e "$events" -- "$here/scratch/$name/lua-$order" "$script.lua" > /dev/null 2>&1)
                code=$?
                record "$phase" "$round" "$script" "$order" "$name" "$code"
                [ "$code" = 0 ] || status=1
            done
            s=$((s + 1))
        done
    done
done
rm -rf "$tmp"
echo "status $status" >> "$out/checks.txt"
date -u +%FT%TZ > "$out/runs.done"
exit $status
