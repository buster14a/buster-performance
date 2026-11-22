#!/bin/bash
# output.sh: output.c's variants on CPU 2: the file new each run (removed before it, outside the timed process) or
# rewritten, on the benchmark directory's filesystem and on tmpfs. Eleven fresh processes a variant under one hold.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
out="$dir/results/floor-output"
rm -rf "$out"; mkdir -p "$out"
cc=$(ls -d "$HOME"/.cache/buster/benchpress-clang/*/bin/clang 2>/dev/null | head -1)
[ -n "$cc" ] || cc=clang
"$cc" -O2 -march=native -static -o "$out/output" "$dir/floor/output.c"
df -T "$out" /dev/shm | awk '{print $1, $2, $7}' > "$out/filesystems.txt"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850 redesign: the object's write" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
variant()
{
    local name=$1 target=$2 mode=$3 fresh=$4
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "
        cd '$out'
        for i in 0 1 2 3 4 5 6 7 8 9 10 11; do
            if [ '$fresh' = new ]; then rm -f '$target'; fi
            if [ \$i = 0 ]; then taskset -c 2 ./output '$target' 2061192 '$mode'; continue; fi
            taskset -c 2 perf stat -x, -e cycles:u,cycles:k,page-faults -o '$name.p'\$i -- ./output '$target' 2061192 '$mode'
            if [ '$fresh' = new ]; then rm -f '$target'; fi
            taskset -c 2 python3 '$dir/wallrun.py' '$name.w'\$i -- ./output '$target' 2061192 '$mode'
        done
        rm -f '$target'
    " 2>> "$out/lock.log"
}
variant none "$out/x.o" none new
variant write-new "$out/x.o" write new
variant write-over "$out/x.o" write over
variant mapped-new "$out/x.o" mapped new
variant mapped-over "$out/x.o" mapped over
variant tmpfs-write-new /dev/shm/claude-2850-x.o write new
variant tmpfs-mapped-new /dev/shm/claude-2850-x.o mapped new
echo done > "$out/complete"
python3 - "$out" <<'PY'
import glob, os, statistics, sys
out = sys.argv[1]
print(f'{"variant":18} {"wall ms":>8} {"user Mc":>8} {"kernel Mc":>10} {"faults":>7}')
names = sorted({os.path.basename(p).rsplit('.', 1)[0] for p in glob.glob(os.path.join(out, '*.p[0-9]*'))}, key=lambda n: os.path.getmtime(os.path.join(out, n + '.p1')))
for name in names:
    u, k, f = [], [], []
    for p in glob.glob(os.path.join(out, name + '.p[0-9]*')):
        c = {}
        for line in open(p):
            x = line.strip().split(',')
            if len(x) > 2 and x[0].replace('.', '').isdigit():
                c[x[2]] = float(x[0])
        u.append(c.get('cycles:u', 0)); k.append(c.get('cycles:k', 0)); f.append(c.get('page-faults', 0))
    walls = [int(open(w).read()) for w in glob.glob(os.path.join(out, name + '.w*.wall'))]
    print(f'{name:18} {statistics.median(walls) / 1e6:8.3f} {statistics.median(u) / 1e6:8.3f} {statistics.median(k) / 1e6:10.3f} {statistics.median(f):7.0f}')
PY
