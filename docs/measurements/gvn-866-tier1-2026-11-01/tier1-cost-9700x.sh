#!/bin/bash
# The 9700X half of #866's compile-time pair: -c --tier1 against -c --tier1 --tier1-gvn, five runs each, CPU 2,
# every process under the shared host lock.
set -u
cd /home/david/buster-fast-bench/gvn866-tier1/repo || exit 1
S=${1:-/home/david/buster-fast-bench/refine-claude/inputs/sqlite3.c}
OUT=/tmp/gvn866-9700x
mkdir -p "$OUT"
LOCK=/home/david/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=solve-866-tier1
export EXCLUSIVE_TITLE="solve 866 tier1 9700x pair"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/1020"
echo "source: $S ($(wc -c < "$S") bytes)"
for mode in base gvn; do
    flags="--tier1"
    [ "$mode" = gvn ] && flags="--tier1 --tier1-gvn"
    : > "$OUT/time-$mode.txt"
    for i in 1 2 3 4 5; do
        start=$(date +%s%N)
        "$LOCK" taskset -c 2 ./build/compiler -c $flags --tier1-report -o "$OUT/$mode.o" "$S" 2> "$OUT/$mode.report"
        end=$(date +%s%N)
        echo $(( (end - start) / 1000000 )) >> "$OUT/time-$mode.txt"
    done
    echo "$mode: text=$(size "$OUT/$mode.o" | awk 'NR==2{print $1}') report=$(grep -o 'functions=[0-9]*\|records=[0-9]*\|spill_stores=[0-9]*\|spill_loads=[0-9]*\|edge_moves=[0-9]*' "$OUT/$mode.report" | tr '\n' ' ')"
done
echo "base runs: $(tr '\n' ' ' < "$OUT/time-base.txt")"
echo "gvn  runs: $(tr '\n' ' ' < "$OUT/time-gvn.txt")"
python3 - "$OUT" <<'PY'
import sys, statistics
out = sys.argv[1]
b = [int(x) for x in open(f"{out}/time-base.txt") if x.strip()]
g = [int(x) for x in open(f"{out}/time-gvn.txt") if x.strip()]
print(f"median base {statistics.median(b):.0f} ms, gvn {statistics.median(g):.0f} ms, change {100*(statistics.median(g)-statistics.median(b))/statistics.median(b):+.1f}%")
PY
