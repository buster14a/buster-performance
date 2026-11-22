#!/bin/bash
# profile-alone.sh NAME TREE OPTION: a cycles profile of measure-node-machine --shadow OPTION on sqlite3.c, CPU 2 (perf
# record, user and kernel), by symbol, under the lock: results/profile-alone-NAME.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
name=$1; tree=$2; option=$3
cc="$dir/trees/$tree/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/profile-alone-$name"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: profile of the machine with no node of the walk's, $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" bash -c "
    cd '$out'
    { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > before.txt
    for i in 1 2 3 4; do
        taskset -c 2 perf record -q -e cycles -c 100003 -o perf-\$i.data -- '$cc' measure-node-machine --shadow $option -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sq' '$sq/sqlite3.c' > run-\$i.txt 2>&1
    done
    { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > after.txt
" 2> "$out/lock.log"
cd "$out"
for i in 1 2 3 4; do perf report -i perf-$i.data --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > report-$i.txt; done
python3 - <<'PY' > by-function.txt
import glob, collections, re
tot = collections.Counter(); runs = 0; total = 0
for f in sorted(glob.glob('report-*.txt')):
    runs += 1
    for line in open(f):
        m = re.match(r'\s*([0-9.]+)%\s+(\d+)\s+\[(.)\]\s+(\S+)', line)
        if m:
            name = m.group(4).replace('.buster_split', '')
            tot[(m.group(3), name)] += int(m.group(2)); total += int(m.group(2))
print(f'total periods {total / runs / 1e6:.1f} M cycles a run over {runs} runs')
k = sum(v for (w, n), v in tot.items() if w == 'k')
print(f'kernel {100 * k / total:.1f}%')
acc = 0
for (w, n), v in tot.most_common(120):
    acc += v
    print(f'{100 * v / total:6.2f}% {100 * acc / total:6.1f}% {v / runs / 1e6:8.2f} M cycles  [{w}] {n}')
PY
echo done > complete
