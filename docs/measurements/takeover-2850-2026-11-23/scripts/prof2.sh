#!/bin/bash
# prof2.sh NAME TREE [OPTIONS]: a cycles profile of -c sqlite3.c on CPU 2 (perf record, user and kernel), by symbol, and
# seven --time-stages runs, each run group one hold of the lock, with OPTIONS given to the compiler: results/prof2-NAME.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
name=$1; tree=$2; options=${3:-}
cc="$dir/trees/$tree/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args="--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c"
out="$dir/results/prof2-$name"
rm -rf "$out"; mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: profile of -c sqlite3.c, $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" bash -c "
    cd '$out'
    { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > before.txt
    taskset -c 2 '$cc' $options $args -o sqlite.o > /dev/null 2>&1
    for i in 1 2 3 4 5 6 7 8; do
        taskset -c 2 perf record -q -e cycles -c 100003 -o perf-\$i.data -- '$cc' $options $args -o sqlite.o > /dev/null 2>&1
    done
    sha256sum sqlite.o > object.sha256
    taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,branch-misses:u,L1-dcache-load-misses:u,page-faults -r 5 -o stat.csv -- '$cc' $options $args -o sqlite.o > /dev/null 2>&1
    { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > after.txt
" 2> "$out/lock.log"
for i in 1 2 3 4 5 6 7; do
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "cd '$out' && taskset -c 2 '$cc' $options $args --time-stages -o sqlite.o 2> stages-$i.txt > /dev/null" 2>> "$out/lock.log"
done
cd "$out"
rm -f sqlite.o
for i in 1 2 3 4 5 6 7 8; do perf report -i perf-$i.data --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > report-$i.txt; done
rm -f perf-*.data
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
for (w, n), v in tot.most_common():
    print(f'{v / runs / 1e6:9.3f} M {100 * v / total:6.2f}%  [{w}] {n}')
PY
python3 "$dir/stages-reduce.py" "$out" > stages.txt
echo done > complete
