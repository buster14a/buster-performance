#!/bin/bash
# sweep.sh NAME REV...: one worktree checked out at each revision in turn, a Release compiler built of it under the lock,
# then, in one hold: a warm-up, three counted runs and five --time-stages runs of -c sqlite3.c on CPU 2. A line a revision
# in results/sweep-NAME/table.txt: user instructions, user and kernel cycles (medians of three, M) and the stages' medians, ms.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
cd "$dir"
name=$1; shift
out="$dir/results/sweep-$name"
mkdir -p "$out/bins"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args="--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c"
git -C src fetch -q origin
tree="$dir/trees/sweep"
if [[ ! -d $tree ]]; then
    git -C src worktree add -q --detach "$tree" "$1"
fi
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
for rev in "$@"; do
    full=$(git -C src rev-parse "$rev")
    short=${full:0:9}
    cc="$out/bins/compiler-$short"
    if [[ ! -x $cc ]]; then
        git -C "$tree" checkout -q --detach "$full" || { echo "$short checkout-failed" >> "$out/table.txt"; continue; }
        export EXCLUSIVE_TITLE="#2850: build $short for a sweep of main"
        (cd "$tree" && "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config Release --target compiler) > "$out/build-$short.log" 2>&1 || { echo "$short build-failed" >> "$out/table.txt"; continue; }
        cp "$tree/build/compiler" "$cc"
    fi
    export EXCLUSIVE_TITLE="#2850: -c sqlite3.c at $short, a sweep of main"
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "
        cd '$out'
        taskset -c 2 '$cc' $args -o sweep.o > /dev/null 2>&1
        taskset -c 2 perf stat -x, -e instructions:u,cycles:u,cycles:k,page-faults -r 3 -o stat-$short.csv -- '$cc' $args -o sweep.o > /dev/null 2>&1
        for i in 1 2 3 4 5; do taskset -c 2 '$cc' $args --time-stages -o sweep.o 2> stages-$short-\$i.txt > /dev/null; done
        sha256sum sweep.o | cut -c1-16 > object-$short.txt
    " 2> "$out/lock-$short.log"
    python3 - "$out" "$short" >> "$out/table.txt" <<'PY'
import sys, statistics, glob
out, short = sys.argv[1], sys.argv[2]
counters = {}
for line in open(f"{out}/stat-{short}.csv"):
    parts = line.strip().split(",")
    if len(parts) > 3 and parts[0].replace(".", "").isdigit():
        counters[parts[2]] = float(parts[0])
stages = {}
for path in glob.glob(f"{out}/stages-{short}-*.txt"):
    for line in open(path):
        parts = line.rstrip("\n").split("\t")
        if len(parts) >= 3 and parts[0] == "time-stage":
            try:
                stages.setdefault(parts[1], []).append(float(parts[2]))
            except ValueError:
                pass
def median(key):
    return statistics.median(stages[key]) if key in stages else float("nan")
keys = ["preprocess", "parse", "check-input", "check-expressions", "check-declarations", "check-program", "select", "lower", "tier0", "total"]
print(short, "%.3f" % (counters.get("instructions:u", 0) / 1e6), "%.1f" % (counters.get("cycles:u", 0) / 1e6), "%.1f" % (counters.get("cycles:k", 0) / 1e6), " ".join("%.2f" % median(k) for k in keys), open(f"{out}/object-{short}.txt").read().strip())
PY
    tail -1 "$out/table.txt"
done
echo sweep-complete
