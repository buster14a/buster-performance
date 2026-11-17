#!/bin/bash
# The kernels by main's and head's --tier1 and clang -O2 (no vectorizers), each linked with one clang -O2 driver, in one
# hold, with each kernel's address in its executable (its offset in a 64-byte line moves a loop's time on its own, as
# tier1-select-compare-2676-2026-11-15 found); then ROUNDS rounds, each a hold of its own, every binary once per kernel,
# the binaries' order rotated by round, pinned to CPU 2 under perf stat (user cycles and instructions); then the
# checksums. Usage: kernels.sh ROUNDS
set -e
dir=$(cd "$(dirname "$0")" && pwd)
B=$(dirname "$dir")
rounds=${1:-11}
out=$B/kernels
mkdir -p $out
cd $out
cp "$dir/kernels.c" "$dir/driver.c" .
cp "$dir/kernels-build.sh" .
"$dir/lock.sh" kernels-build ./kernels-build.sh $B/main/build/compiler $B/head/build/compiler > build.txt 2>&1
kernels="one unsigned half both logic"
variants=(m1 h1 c2)
for r in $(seq 1 $rounds); do
    order="${variants[$(( r % 3 ))]} ${variants[$(( (r + 1) % 3 ))]} ${variants[$(( (r + 2) % 3 ))]}"
    "$dir/lock.sh" kernels-round-$r bash -c '
        for k in '"$kernels"'; do
            for v in '"$order"'; do
                taskset -c 2 ./$v $k > /dev/null
                perf stat -x, -e cycles:u,instructions:u -o perf.tmp taskset -c 2 ./$v $k > run.tmp
                status=$?
                printf "run %s %s %s %s %s %s %s\n" "$1" $k $v $status "$(awk -v k=$k "\$1==k{print \$2}" run.tmp)" "$(awk -F, "/cycles:u/{print \$1}" perf.tmp)" "$(awk -F, "/instructions:u/{print \$1}" perf.tmp)"
            done
        done' _ $r
done > runs.txt
"$dir/lock.sh" kernels-checksums bash -c 'for v in m1 h1 c2; do echo "$v $(taskset -c 2 ./$v | tail -1)"; done' > checksums.txt
python3 - "$kernels" > table.txt <<'PY'
import sys, statistics
d = {}
for line in open("runs.txt"):
    p = line.split()
    if p[0] == "run" and p[4] == "0":
        d.setdefault((p[2], p[3]), []).append((float(p[5]), int(p[6]), int(p[7])))
print("kernel variant ms(best/median/worst) Mcycles(median, range) Minstructions(median)")
for k in sys.argv[1].split():
    for v in ("m1", "h1", "c2"):
        r = d.get((k, v), [])
        if r:
            ms = [x[0] for x in r]; cy = [x[1] / 1e6 for x in r]; ins = [x[2] / 1e6 for x in r]
            print("%s %s %.1f/%.1f/%.1f %.1f (%.1f-%.1f) %.1f n=%d" % (k, v, min(ms), statistics.median(ms), max(ms), statistics.median(cy), min(cy), max(cy), statistics.median(ins), len(r)))
PY
cat table.txt
