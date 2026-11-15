#!/bin/bash
# annotate-flat.sh LABEL EVENT PERIOD RUNS [SYMBOL]: perf record of measure-node-machine --shadow --passes 0
# --front-flat-first on sqlite3.c by results/LABEL's compiler, RUNS processes with periods two apart (CPU 2, one hold of
# the lock), then SYMBOL's (node_front_chunk_flat's) samples by source line: perf annotate's instructions, their
# addresses to lines by addr2line -i (the line and its inlining chain), the runs' shares averaged. Files
# results/LABEL/annflat-EVENT-SYMBOL.txt (by line) and .chains.txt (by inlining chain); the perf data removed.
set -u
cd "$(dirname "$0")"
label=$1; event=$2; period=$3; runs=$4; sym=${5:-node_front_chunk_flat}
out=$PWD/results/$label
name=${event%%:*}
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export LC_ALL=C
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-annflat.txt"
for n in $(seq 1 $runs); do
    commands="$commands; perf record -q -o $out/annflat-$name-$n.data -e $event -c $((period + 2 * n)) -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-flat-first -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > /dev/null 2>&1"
done
./lock.sh bash -c "$commands"
: > $out/annflat-$name-$sym.pairs
for n in $(seq 1 $runs); do
    nice -n 19 perf annotate -i $out/annflat-$name-$n.data --stdio --no-source -s $sym 2>/dev/null | awk -F: '/^ +[0-9]+\.[0-9]+ +: +[0-9a-f]+:/ { gsub(/ /, "", $1); gsub(/ /, "", $2); print $1, $2 }' >> $out/annflat-$name-$sym.pairs
    rm -f $out/annflat-$name-$n.data
done
cut -d' ' -f2 $out/annflat-$name-$sym.pairs | sort -u | sed 's/^/0x/' | addr2line -e $out/compiler -i -a > $out/annflat-$name-$sym.lines 2>/dev/null
python3 - "$out" "$name" "$sym" "$runs" <<'PY'
import sys, collections
out, name, sym, runs = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
pairs = [l.split() for l in open('%s/annflat-%s-%s.pairs' % (out, name, sym)) if l.strip()]
frames = {}
current = None
for l in open('%s/annflat-%s-%s.lines' % (out, name, sym)).read().split('\n'):
    if l.startswith('0x'):
        current = int(l, 16)
        frames[current] = []
    elif l and current is not None:
        frames[current].append(l.split('/')[-1].split(' ')[0])
by_line = collections.Counter()
by_chain = collections.Counter()
for percent, address in pairs:
    f = frames.get(int(address, 16), ['?'])
    by_line[f[0]] += float(percent) / runs
    by_chain[' <- '.join(f[:3])] += float(percent) / runs
with open('%s/annflat-%s-%s.txt' % (out, name, sym), 'w') as o:
    for line, share in by_line.most_common(80):
        o.write('%7.2f%%  %s\n' % (share, line))
with open('%s/annflat-%s-%s.chains.txt' % (out, name, sym), 'w') as o:
    for line, share in by_chain.most_common(80):
        o.write('%7.2f%%  %s\n' % (share, line))
PY
