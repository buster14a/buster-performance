#!/bin/bash
# count9.sh DIR [SPEEDTEST_KINDS LUA_KINDS SUFFIX]: #138's record's patterns.py over DIR's callgrind runs (cg9.sh's),
# joined by #1189's gap.c (GAP_INSTRUCTIONS=1) with the kinds files' origin tags where given;
# DIR/{speedtest1,lua}SUFFIX.ins and .patterns.
set -eu
dir=$(readlink -f "$1")
x=${4:-}
gap=$HOME/.cache/claude-2554/tools/gap
pat=/home/user/buster-performance/docs/measurements/tier1-quality-138-2026-11-12/scripts/tools/patterns.py
objdump -d --no-show-raw-insn "$dir/speedtest1-0" > "$dir/speedtest1.dis"
objdump -d --no-show-raw-insn "$dir/lua-0" > "$dir/lua.dis"
GAP_INSTRUCTIONS=1 "$gap" count "$dir/speedtest1.dis" "$dir/speedtest1.cg" "$dir/speedtest1-0" 0 ${2:-} > "$dir/speedtest1$x.tsv"
grep '^#ins' "$dir/speedtest1$x.tsv" > "$dir/speedtest1$x.ins"
: > "$dir/lua$x.ins"
for s in calls tables strings arithmetic closures; do
    GAP_INSTRUCTIONS=1 "$gap" count "$dir/lua.dis" "$dir/$s.cg" "$dir/lua-0" 0 ${3:-} > "$dir/$s$x.tsv"
    grep '^#ins' "$dir/$s$x.tsv" >> "$dir/lua$x.ins"
done
grep -h '^#total\|^#check' "$dir/speedtest1$x.tsv" "$dir"/{calls,tables,strings,arithmetic,closures}$x.tsv | sort | uniq -c | head -4
python3 "$pat" "$dir/speedtest1.dis" "$dir/speedtest1$x.ins" > "$dir/speedtest1$x.patterns"
python3 "$pat" "$dir/lua.dis" "$dir/lua$x.ins" > "$dir/lua$x.patterns"
echo "== speedtest1"; sed -n '1,10p' "$dir/speedtest1$x.patterns"
echo "== lua"; sed -n '1,10p' "$dir/lua$x.patterns"
