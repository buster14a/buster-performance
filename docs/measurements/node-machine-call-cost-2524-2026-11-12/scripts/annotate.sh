#!/bin/bash
# annotate.sh LABEL: perf record of the shadow on sqlite3.c by results/LABEL's compiler (40 passes, CPU 2, one hold of the
# lock), then node_machine_type's samples by source line (perf annotate's instructions, their addresses to lines by
# addr2line), the 60 heaviest lines kept; perf.data removed.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > '$out/annotate-holder.txt'; taskset -c 2 perf record -q -c 200003 -e cycles:u -o '$out/perf.data' '$out/compiler' measure-node-machine --shadow --passes 40 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > /dev/null 2>&1"
perf annotate -i "$out/perf.data" --stdio --no-source -s node_machine_type 2>/dev/null > "$out/annotate-type.txt"
rm -f "$out/perf.data" "$out/perf.data.old"
awk -F: '/^ +[0-9]+\.[0-9]+ +: +[0-9a-f]+:/ { gsub(/ /, "", $1); gsub(/ /, "", $2); print $1, $2 }' "$out/annotate-type.txt" > "$out/annotate-pairs.txt"
cut -d' ' -f2 "$out/annotate-pairs.txt" | sed 's/^/0x/' | addr2line -e "$out/compiler" -i -a > "$out/annotate-lines.txt" 2>/dev/null
python3 - "$out" <<'PY'
import sys, collections
out = sys.argv[1]
pairs = [l.split() for l in open(out + '/annotate-pairs.txt') if l.strip()]
lines = open(out + '/annotate-lines.txt').read().split('\n')
# addr2line -a -i: an address line, then one or more inlined frames' lines.
frames = {}
current = None
for l in lines:
    if l.startswith('0x'):
        current = int(l, 16)
        frames[current] = []
    elif l and current is not None:
        frames[current].append(l.split('/')[-1])
by_line = collections.Counter()
by_function_line = collections.Counter()
for percent, address in pairs:
    f = frames.get(int(address, 16), ['?'])
    by_line[f[0]] += float(percent)
    by_function_line[' <- '.join(f[:3])] += float(percent)
with open(out + '/annotate-summary.txt', 'w') as o:
    for line, p in by_line.most_common(60):
        o.write('%6.2f %s\n' % (p, line))
    o.write('\n')
    for line, p in by_function_line.most_common(60):
        o.write('%6.2f %s\n' % (p, line))
PY
date -u +%FT%TZ > "$out/.annotated"
