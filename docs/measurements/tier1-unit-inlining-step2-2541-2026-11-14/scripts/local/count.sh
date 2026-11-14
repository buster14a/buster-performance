#!/bin/bash
# count.sh NAME: callgrind counts of ~/.cache/claude-2541/work/NAME's speedtest1 (size 2) and Lua's five scripts: total
# instructions and calls, checking speedtest1's output and each script's output against the reference run's.
set -u
name=$1
work=$HOME/.cache/claude-2541/work/$name
inputs=$HOME/.cache/claude-2541/inputs
tmp=$(mktemp -d)
options="--shrink-memory --reprepare --stats --journal wal --size 2 --heap 40000000 64 --testset mix1"
summ() { awk '/^summary:/ { ir = $2 } /^calls=/ { split($1, a, "="); calls += a[2] } END { printf "%d %d", ir, calls }' "$1"; }
mkdir -p "$tmp/db/tmp"
(cd "$tmp/db" && SQLITE_TMPDIR=$tmp/db/tmp valgrind --tool=callgrind --cache-sim=no --callgrind-out-file="$tmp/st.cg" "$work/speedtest1" $options --verify speedtest1.db > "$tmp/st.out" 2>/dev/null)
hash=$(grep 'Verification Hash' "$tmp/st.out")
read sir scalls < <(summ "$tmp/st.cg")
line="$name speedtest1 Ir=$sir calls=$scalls [$hash]"
tot_ir=0; tot_calls=0
for s in calls tables strings arithmetic closures; do
    (cd "$inputs/scripts" && valgrind --tool=callgrind --cache-sim=no --callgrind-out-file="$tmp/$s.cg" "$work/lua" "$s.lua" > "$tmp/$s.out" 2>/dev/null)
    ref=$HOME/.cache/claude-2541/ref/$s.out
    if [ -f "$ref" ]; then cmp -s "$ref" "$tmp/$s.out" || line="$line LUA-$s-DIFFERS"; fi
    read ir calls < <(summ "$tmp/$s.cg")
    tot_ir=$((tot_ir + ir)); tot_calls=$((tot_calls + calls))
done
echo "$line | lua Ir=$tot_ir calls=$tot_calls"
rm -rf "$tmp"
