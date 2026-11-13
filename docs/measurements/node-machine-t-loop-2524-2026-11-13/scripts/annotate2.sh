#!/bin/bash
# annotate2.sh LABEL EVENT: perf record of the shadow on sqlite3.c by results/LABEL's compiler (40 passes, CPU 2, one hold
# of the lock) with EVENT (cycles:u or instructions:u), then T's functions' samples by source line (perf annotate's
# instructions, their addresses to lines by addr2line), for node_machine_type, node_machine_call_rule and
# node_machine_store_rule; the symbol report kept, perf.data removed.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
event=$2
tag=${event%%:*}
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > '$out/annotate2-$tag-holder.txt'; taskset -c 2 perf record -q -c 200003 -e $event -o '$out/perf-$tag.data' '$out/compiler' measure-node-machine --shadow --passes 40 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > /dev/null 2>&1"
perf report -i "$out/perf-$tag.data" --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60 > "$out/perf-symbols-$tag.txt"
for sym in node_machine_type node_machine_call_rule node_machine_store_rule; do
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
for percent, address in pairs:
    f = frames.get(int(address, 16), ['?'])
    by_line[f[0]] += float(percent)
    by_chain[' <- '.join(f[:3])] += float(percent)
with open('%s/annotate2-%s-%s.txt' % (out, tag, sym), 'w') as o:
    for line, p in by_line.most_common(80):
        o.write('%6.2f %s\n' % (p, line))
    o.write('\n')
    for line, p in by_chain.most_common(80):
        o.write('%6.2f %s\n' % (p, line))
PY
    rm -f "$out/ann-$tag-$sym.txt" "$out/ann-$tag-$sym.pairs" "$out/ann-$tag-$sym.lines"
done
rm -f "$out/perf-$tag.data" "$out/perf-$tag.data.old"
date -u +%FT%TZ > "$out/.annotated2-$tag"
