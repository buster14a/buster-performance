#!/bin/bash
# #866's Tier 1 measurement: compile time (5 runs each) and generated code (text bytes, records) with and without GVN.
set -u
REPO=/home/david/.local/share/opencode/worktree/11a4cd/shiny-canyon
OUT=/tmp/opencode/gvn866/t1
C=/home/david/.cache/buster-scratch-x87/ct/c-testsuite/tests/single-exec
S=/home/david/.cache/claude-lane-arenas/sqlite3.c
cd "$REPO" || exit 1

# Compile time on sqlite3.c: 5 runs each way, wall clock in ms.
for mode in base gvn; do
    flags="--tier1"
    [ "$mode" = gvn ] && flags="--tier1 --tier1-gvn"
    : > "$OUT/time-$mode.txt"
    for i in 1 2 3 4 5; do
        start=$(date +%s%N)
        ./build/compiler -c $flags -fno-asynchronous-unwind-tables -o "$OUT/t-$mode.o" "$S" || echo "FAILED" >> "$OUT/time-$mode.txt"
        end=$(date +%s%N)
        echo $(( (end - start) / 1000000 )) >> "$OUT/time-$mode.txt"
    done
done

# Generated code on c-testsuite: records, spills and object bytes.
for mode in base gvn; do
    flags="--tier1"
    [ "$mode" = gvn ] && flags="--tier1 --tier1-gvn"
    : > "$OUT/corpus-$mode.txt"
    bytes=0
    for f in "$C"/*.c; do
        if ./build/compiler -c $flags --tier1-report -fno-asynchronous-unwind-tables -o "$OUT/one.o" "$f" 2>> "$OUT/corpus-$mode.txt" > /dev/null; then
            bytes=$((bytes + $(stat -c %s "$OUT/one.o")))
        else
            echo "FAILED $f" >> "$OUT/corpus-$mode.txt"
        fi
    done
    echo "objects-bytes $bytes" >> "$OUT/corpus-$mode.txt"
done

python3 - <<'PY'
import statistics, collections
for mode in ("base", "gvn"):
    t = [int(x) for x in open(f"/tmp/opencode/gvn866/t1/time-{mode}.txt") if x.strip().isdigit()]
    print(f"sqlite3 -c --tier1 {'--tier1-gvn' if mode=='gvn' else '(default)':14s} median {statistics.median(t):.0f} ms  runs {sorted(t)}")
for mode in ("base", "gvn"):
    sums = collections.Counter(); fails = 0
    for line in open(f"/tmp/opencode/gvn866/t1/corpus-{mode}.txt"):
        if line.startswith("objects-bytes"): sums["bytes"] = int(line.split()[1]); continue
        if line.startswith("FAILED"): fails += 1; continue
        if line.startswith("tier1\t"):
            for part in line.strip().split("\t")[1:]:
                k, v = part.split("=", 1); sums[k] += int(v)
    print(f"c-testsuite {mode:5s} fails={fails} functions={sums['functions']} tier1={sums['tier1']} "
          f"records={sums['records']} spill_stores={sums['spill_stores']} spill_loads={sums['spill_loads']} "
          f"edge_moves={sums['edge_moves']} bytes={sums.get('bytes',0)}")
PY
