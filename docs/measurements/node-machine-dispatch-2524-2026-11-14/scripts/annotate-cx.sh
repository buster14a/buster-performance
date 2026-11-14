#!/bin/bash
# annotate-cx.sh LABEL EVENT [INPUT]: perf record of the shadow (40 passes, CPU 2, one hold of the lock) by results/LABEL's
# compiler with EVENT (cycles:u or instructions:u) on sqlite3.c (INPUT=lua for Lua 5.4.8), then C's and X's functions'
# samples by source line (perf annotate's instructions, their addresses to lines by addr2line -i: the line and its
# inlining chain); the symbol report kept, perf.data removed.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
event=$2
input=${3:-sqlite}
tag=${event%%:*}-$input
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
lua=$PWD/inputs/lua-5.4.8/src
if [ "$input" = lua ]; then args="$lua/*.c"; else args="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"; fi
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > '$out/annotate-$tag-holder.txt'; taskset -c 2 perf record -q -c 200003 -e $event -o '$out/perf-$tag.data' '$out/compiler' measure-node-machine --shadow --passes 40 $args > /dev/null 2>&1"
perf report -i "$out/perf-$tag.data" --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60 > "$out/perf-symbols-$tag.txt"
for sym in node_machine_contexts node_machine_expand node_machine_evaluate node_machine_power; do
    perf annotate -i "$out/perf-$tag.data" --stdio --no-source -s $sym 2>/dev/null > "$out/ann-$tag-$sym.txt"
    awk -F: '/^ +[0-9]+\.[0-9]+ +: +[0-9a-f]+:/ { gsub(/ /, "", $1); gsub(/ /, "", $2); print $1, $2 }' "$out/ann-$tag-$sym.txt" > "$out/ann-$tag-$sym.pairs"
    cut -d' ' -f2 "$out/ann-$tag-$sym.pairs" | sed 's/^/0x/' | addr2line -e "$out/compiler" -i -a > "$out/ann-$tag-$sym.lines" 2>/dev/null
    python3 - "$out" "$tag" "$sym" <<'PY'
import sys, collections
out, tag, sym = sys.argv[1:4]
pairs = [l.split() for l in open('%s/ann-%s-%s.pairs' % (out, tag, sym)) if l.strip()]
lines = open('%s/ann-%s-%s.lines' % (out, tag, sym)).read().split('\n')
frames = {}
current = None
for l in lines:
    if l.startswith('0x'):
        current = int(l, 16)
        frames[current] = []
    elif l and current is not None:
        frames[current].append(l.split('/')[-1])
by_line = collections.Counter()
by_chain = collections.Counter()
total = 0.0
for percent, address in pairs:
    f = frames.get(int(address, 16), ['?'])
    by_line[f[0]] += float(percent)
    by_chain[' <- '.join(f[:3])] += float(percent)
    total += float(percent)
with open('%s/annotate-%s-%s.txt' % (out, tag, sym), 'w') as o:
    o.write('total %.2f\n' % total)
    for line, p in by_line.most_common(100):
        o.write('%6.2f %s\n' % (p, line))
    o.write('\n')
    for line, p in by_chain.most_common(100):
        o.write('%6.2f %s\n' % (p, line))
PY
    mv "$out/ann-$tag-$sym.txt" "$out/asm-$tag-$sym.txt"
    rm -f "$out/ann-$tag-$sym.pairs" "$out/ann-$tag-$sym.lines"
done
rm -f "$out/perf-$tag.data" "$out/perf-$tag.data.old"
date -u +%FT%TZ > "$out/.annotated-$tag"
