#!/bin/bash
# lines.sh TREE NAME SYMBOL...: the cycles of -c sqlite3.c by source line within the named symbols: eight perf record
# runs (cycles:u, one sample each 100,003) in one hold of the lock, perf script's ip, symbol and source line, summed.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
tree=$1; name=$2; shift 2
cc="$dir/trees/$tree/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args="--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c"
out="$dir/results/lines-$name"
rm -rf "$out"; mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: cycles by source line, $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" bash -c "
    cd '$out'
    taskset -c 2 '$cc' $args -o sqlite.o > /dev/null 2>&1
    for i in 1 2 3 4 5 6 7 8; do
        taskset -c 2 perf record -q -e cycles:u -c 100003 -o perf-\$i.data -- '$cc' $args -o sqlite.o > /dev/null 2>&1
    done
    rm -f sqlite.o
" 2> "$out/lock.log"
cd "$out"
pattern=$(printf '%s|' "$@"); pattern=${pattern%|}
for i in 1 2 3 4 5 6 7 8; do perf script -i perf-$i.data -F ip,sym 2> /dev/null; done | awk -v p="^($pattern)(\\.buster_split)?$" '$2 ~ p { c[$2 " " $1] += 1 } END { for (k in c) print c[k], k }' | sort -rn > ips.txt
rm -f perf-*.data
python3 - "$cc" <<'PY' > lines.txt
import sys, subprocess, collections
cc = sys.argv[1]
rows = [l.split() for l in open('ips.txt')]
addresses = [r[2] for r in rows]
out = subprocess.run(['addr2line', '-e', cc, '-i'] + ['0x' + a for a in addresses], capture_output=True, text=True).stdout
# addr2line -i prints the innermost frame first, then its inliners; without -f the frames of one address can't be told
# apart, so ask one address at a time for those that matter.
lines = collections.Counter(); inner = collections.Counter()
for r in rows:
    frames = subprocess.run(['addr2line', '-e', cc, '-i', '0x' + r[2]], capture_output=True, text=True).stdout.split('\n')
    frames = [f.split('/')[-1].split(' ')[0] for f in frames if f]
    if frames:
        lines[(r[1], frames[-1])] += int(r[0])
        inner[(r[1], frames[0], frames[-1])] += int(r[0])
total = collections.Counter()
for (s, l), c in lines.items(): total[s] += c
for s, t in total.most_common():
    print(f'== {s}: {t * 100003 / 8 / 1e6:.2f} M cycles a run')
    for (s2, l), c in lines.most_common():
        if s2 == s and c * 100 >= t * 1.5:
            print(f'  {c * 100003 / 8 / 1e6:7.2f} M {100 * c / t:5.1f}%  {l}')
            for (s3, i, o), c2 in inner.most_common():
                if s3 == s and o == l and i != l and c2 * 100 >= t * 1.0:
                    print(f'      {c2 * 100003 / 8 / 1e6:7.2f} M        inlined {i}')
PY
echo done > complete
