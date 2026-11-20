#!/bin/bash
# count.sh DIR: DIR/lua-base's and DIR/lua-head's (the 9700X's builds) five scripts under callgrind (--dump-instr=yes),
# outputs compared between the builds; joined to each executable's disassembly by #1189's gap.c (GAP_INSTRUCTIONS=1,
# no origin tags), each run through the 9700X's own loader and C library (glibc/), as #2554's record's cg9.sh does, and counted by #138's record's patterns.py, as #2554's record's count9.sh does. DIR/{base,head}/.
set -u
here=$(dirname $(readlink -f "$0"))
dir=$(readlink -f "$1")
pat=/home/user/buster-performance/docs/measurements/tier1-quality-138-2026-11-12/scripts/tools/patterns.py
for t in base head; do
    mkdir -p "$dir/$t"
    for s in calls tables strings arithmetic closures; do
        (cd "$here/scripts" && valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file="$dir/$t/$s.cg" "$here/glibc/ld-linux-x86-64.so.2" --library-path "$here/glibc" "$dir/lua-$t" $s.lua > "$dir/$t/$s.out" 2> "$dir/$t/$s.err"; echo "status $?" >> "$dir/$t/$s.out") &
    done
done
wait
for s in calls tables strings arithmetic closures; do
    cmp -s "$dir/base/$s.out" "$dir/head/$s.out" && echo "$s same" || echo "$s DIFFERS"
done > "$dir/outputs.txt"
for t in base head; do
    objdump -d --no-show-raw-insn "$dir/lua-$t" > "$dir/$t/lua.dis"
    : > "$dir/$t/lua.ins"; : > "$dir/$t/totals.txt"
    for s in calls tables strings arithmetic closures; do
        GAP_INSTRUCTIONS=1 "$here/gap" count "$dir/$t/lua.dis" "$dir/$t/$s.cg" "$dir/lua-$t" 0 > "$dir/$t/$s.tsv"
        grep '^#ins' "$dir/$t/$s.tsv" >> "$dir/$t/lua.ins"
        grep '^#total' "$dir/$t/$s.tsv" | sed "s/^/$s /" >> "$dir/$t/totals.txt"
    done
    python3 "$pat" "$dir/$t/lua.dis" "$dir/$t/lua.ins" > "$dir/$t/lua.patterns"
    # luaV_execute's own instructions, summed over the five scripts.
    awk -F'\t' '$2 == "luaV_execute" {s += $6} END {print "luaV_execute", s}' "$dir/$t/lua.ins" > "$dir/$t/luaV_execute.txt"
done
cat "$dir/outputs.txt"
paste "$dir/base/lua.patterns" "$dir/head/lua.patterns"
cat "$dir/base/luaV_execute.txt" "$dir/head/luaV_execute.txt"
