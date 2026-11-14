#!/bin/bash
# calls.sh TREE...: the calls each TREE's programs make (programs.sh's speedtest1 at placement 0 and Lua in order 0, its
# five scripts), as retired near returns, with user cycles and instructions, by perf stat (three runs each, the events
# ungrouped), pinned to CPU 2: what the expansions remove, and their cycles a removed call. Run inside one hold of the
# lock. results/calls.tsv: program, tree, cycles, instructions, returns.
set -u
cd "$(dirname "$0")"
here=$PWD
out=$here/results
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
record=$HOME/buster-fast-bench/138-tier1-quality-claude
options="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
tmp=$(mktemp -d /tmp/claude-2541-step1-calls.XXXXXX)
events=cycles:u,instructions:u,ex_ret_near_ret:u
for tree in "$@"; do
    rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"
    (cd "$tmp/db" && SQLITE_TMPDIR=$tmp/db/tmp taskset -c 2 perf stat -x, -r 3 -o "$tmp/stat.csv" -e "$events" -- "$here/scratch/$tree/speedtest1-0" $options speedtest1.db > /dev/null 2>&1)
    awk -F, -v t="$tree" '$3 ~ /cycles/ { c = $1 } $3 ~ /instructions/ { i = $1 } $3 ~ /ex_ret_near_ret/ { r = $1 } END { printf "speedtest1\t%s\t%s\t%s\t%s\n", t, c, i, r }' "$tmp/stat.csv" >> "$out/calls.tsv"
    for script in calls tables strings arithmetic closures; do
        (cd "$record/inputs/scripts" && taskset -c 2 perf stat -x, -r 3 -o "$tmp/stat.csv" -e "$events" -- "$here/scratch/$tree/lua-0" "$script.lua" > /dev/null 2>&1)
        awk -F, -v t="$tree" -v s="$script" '$3 ~ /cycles/ { c = $1 } $3 ~ /instructions/ { i = $1 } $3 ~ /ex_ret_near_ret/ { r = $1 } END { printf "lua-%s\t%s\t%s\t%s\t%s\n", s, t, c, i, r }' "$tmp/stat.csv" >> "$out/calls.tsv"
    done
done
rm -rf "$tmp"
