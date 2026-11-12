#!/bin/bash
# runs.sh NAME ROUNDS BUILD=DIRECTORY...: every BUILD's speedtest1 and Lua (DIRECTORY/speedtest1 or
# DIRECTORY/speedtest1-BUILD, and lua likewise) run as measure-tier1-programs runs them: speedtest1 with #136's options
# from a fresh database on /tmp's tmpfs, made and removed outside its count, and each of the five scripts; pinned to
# CPU 2, each run counted by perf stat (task-clock, user cycles and instructions, branches and misses). One untimed
# warm-up of everything, then ROUNDS rounds, the builds' order rotated and reversed by round. Before any timing every
# build's outputs are checked: speedtest1's verification hash and each script's output against the first build's. Run
# inside one hold of the lock. results/NAME/runs.tsv: phase, round, program, build, task-clock ms, user cycles,
# instructions, branches, branch misses, status.
set -u
cd "$(dirname "$0")"
name=$1; rounds=$2; shift 2
out=$PWD/results/$name
mkdir -p "$out"
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
scripts=$PWD/inputs/scripts
options="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
tmp=$(mktemp -d /tmp/claude-tier1-quality-runs.XXXXXX)
builds=(); declare -A st lua
for pair in "$@"; do
    b=${pair%%=*}; d=$(readlink -f "${pair#*=}")
    builds+=("$b")
    if [ -x "$d/speedtest1" ]; then st[$b]=$d/speedtest1; lua[$b]=$d/lua; else st[$b]=$d/speedtest1-$b; lua[$b]=$d/lua-$b; fi
done
status=0
# Checks, outside any timing.
: > "$out/checks.txt"
first=${builds[0]}
for b in "${builds[@]}"; do
    rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"
    hash=$(cd "$tmp/db" && SQLITE_TMPDIR=$tmp/db/tmp "${st[$b]}" $options --verify speedtest1.db 2>&1 | grep 'Verification Hash')
    echo "$b speedtest1 $hash" >> "$out/checks.txt"
    [ "$hash" = "Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739" ] || { status=1; echo "$b speedtest1 FAILED" >> "$out/checks.txt"; }
    for s in calls tables strings arithmetic closures; do
        (cd "$scripts" && "${lua[$b]}" "$s.lua") > "$tmp/$s-$b.out" 2>&1 || status=1
        if cmp -s "$tmp/$s-$b.out" "$tmp/$s-$first.out"; then echo "$b $s same" >> "$out/checks.txt"; else echo "$b $s DIFFERS" >> "$out/checks.txt"; status=1; fi
    done
done
# No timing of builds whose outputs are wrong.
if [ $status != 0 ]; then
    echo "status $status (checks failed; nothing timed)" >> "$out/checks.txt"
    rm -rf "$tmp"
    exit 1
fi
events=task-clock,cycles:u,instructions:u,branches:u,branch-misses:u
run()
{
    # $1 phase, $2 round, $3 program, $4 build
    local phase=$1 round=$2 program=$3 b=$4 code
    if [ "$program" = speedtest1 ]; then
        rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"
        (cd "$tmp/db" && SQLITE_TMPDIR=$tmp/db/tmp taskset -c 2 perf stat -x, -o "$tmp/stat.csv" -e "$events" -- "${st[$b]}" $options speedtest1.db > /dev/null 2>&1)
        code=$?
    else
        (cd "$scripts" && taskset -c 2 perf stat -x, -o "$tmp/stat.csv" -e "$events" -- "${lua[$b]}" "$program.lua" > /dev/null 2>&1)
        code=$?
    fi
    awk -F, -v p="$phase" -v r="$round" -v g="$program" -v b="$b" -v c="$code" '
        $3 ~ /task-clock/ { clock = $1 } $3 ~ /cycles/ { cycles = $1 } $3 ~ /instructions/ { instructions = $1 }
        $3 ~ /^branches/ { branches = $1 } $3 ~ /branch-misses/ { misses = $1 }
        END { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", p, r, g, b, clock, cycles, instructions, branches, misses, c }' "$tmp/stat.csv" >> "$out/runs.tsv"
    [ "$code" = 0 ] || status=1
}
count=${#builds[@]}
programs=(speedtest1 calls tables strings arithmetic closures)
for round in $(seq 0 "$rounds"); do
    phase=measured; [ "$round" = 0 ] && phase=warmup
    for program in "${programs[@]}"; do
        for i in $(seq 0 $((count - 1))); do
            # Rotate the starting build by round and reverse the direction on odd rounds.
            if [ $((round % 2)) = 0 ]; then k=$(((i + round) % count)); else k=$(((count - 1 - i + round) % count)); fi
            run "$phase" "$round" "$program" "${builds[$k]}"
        done
    done
done
rm -rf "$tmp"
echo "status $status" >> "$out/checks.txt"
date -u +%FT%TZ > "$out/done"
exit $status
