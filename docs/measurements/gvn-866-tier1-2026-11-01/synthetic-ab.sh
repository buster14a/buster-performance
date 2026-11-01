#!/bin/bash
# Snapshot both GVN builds as standalone binaries, then time them at matched settings.
set -u
REPO=/home/david/.local/share/opencode/worktree/11a4cd/shiny-canyon
OUT=/tmp/opencode/gvn866
CPU=${1:-4}
PROCS=${2:-5}
cd "$REPO" || exit 1
mkdir -p "$OUT"

cp build/compiler "$OUT/compiler-candidate" || exit 1
git stash push --quiet -- src/buster/compiler/ir_optimize_gvn.c src/buster/compiler/ir_optimize_gvn_test.c docs/ir-value-numbering.md || exit 1
BUSTER_DEBUG_INFO=0 ./build.sh > "$OUT/build-baseline2.log" 2>&1 || { echo "baseline build failed"; exit 1; }
cp build/compiler "$OUT/compiler-baseline" || exit 1
git stash pop --quiet || exit 1
echo "binary sizes: $(stat -c %s "$OUT"/compiler-baseline) $(stat -c %s "$OUT"/compiler-candidate)"

for i in $(seq 1 "$PROCS"); do
    taskset -c "$CPU" "$OUT/compiler-baseline" benchmark-ir-optimize-passes --pass gvn --instructions 4096 --samples 21 > "$OUT/b2-$i.txt" 2>&1
done
for i in $(seq 1 "$PROCS"); do
    taskset -c "$CPU" "$OUT/compiler-candidate" benchmark-ir-optimize-passes --pass gvn --instructions 4096 --samples 21 > "$OUT/c2-$i.txt" 2>&1
done

BUSTER_DEBUG_INFO=0 ./build.sh > "$OUT/build-restore.log" 2>&1 || { echo "restore build failed"; exit 1; }
echo "restored candidate build"

python3 - <<'PY'
import re, statistics, glob
def rows(prefix):
    out = {}
    for f in sorted(glob.glob(f"/tmp/opencode/gvn866/{prefix}-*.txt")):
        for line in open(f):
            m = re.match(r"ir-pass gvn (\S+) (\S+) samples=(\d+) repeats=(\d+) ns=([0-9.]+)", line)
            if m:
                out.setdefault((m.group(1), m.group(2)), []).append((int(m.group(4)), float(m.group(5))))
    return out
b, c = rows("b2"), rows("c2")
print(f"{'shape':11s} {'path':7s} {'baseline ns':>12s} {'reps':>5s} {'candidate ns':>13s} {'reps':>5s} {'delta':>8s}")
for key in sorted(b):
    bl = b[key]; cl = c[key]
    bm = statistics.median(v for _, v in bl); cm = statistics.median(v for _, v in cl)
    print(f"{key[0]:11s} {key[1]:7s} {bm:12.1f} {min(r for r,_ in bl):5d} {cm:13.1f} {min(r for r,_ in cl):5d} {100*(cm-bm)/bm:+7.1f}%")
PY
