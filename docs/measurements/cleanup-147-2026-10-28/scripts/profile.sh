#!/bin/bash
# Where head's extra cycles go: cycles:u profiles of 30 compiles of sqlite3.c by main's and head's placement-0 builds,
# interleaved in one hold of the lock on CPU 2, then each symbol's samples side by side.
export EXCLUSIVE_OWNER=claude-solve-147 EXCLUSIVE_TITLE="solve 147 (cleanup)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/745"
unset CPATH C_INCLUDE_PATH
B=~/buster-fast-bench
D=$B/solve147-claude
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
$B/exclusive.sh bash -c '
    B=~/buster-fast-bench
    D=$B/solve147-claude
    Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
    for round in 1 2 3; do
        for tree in main head; do
            taskset -c 2 perf record -q -e cycles:u -c 200003 -o $D/profile-$tree-$round.data -- bash -c "for i in 1 2 3 4 5 6 7 8 9 10; do $D/shifts/$tree/compiler-0 -c -I$Q -o $D/profile-$tree.o $Q/sqlite3.c; done" > /dev/null 2>&1
        done
    done
'
for tree in main head; do
    for round in 1 2 3; do
        perf report -q -i $D/profile-$tree-$round.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^#" | awk "NF {print \$NF, \$1}" > $D/profile-$tree-$round.txt
    done
done
python3 - <<'PY'
import collections, os
D = os.path.expanduser("~/buster-fast-bench/solve147-claude")
def load(tree):
    total = collections.Counter()
    for r in (1, 2, 3):
        for line in open(f"{D}/profile-{tree}-{r}.txt"):
            parts = line.split()
            if len(parts) == 2 and parts[1].endswith("%"):
                total[parts[0]] += float(parts[1][:-1])
    return total
m, h = load("main"), load("head")
names = sorted(set(m) | set(h), key=lambda n: -(abs(h[n] - m[n])))
print("symbol main% head% diff (sums of 3 rounds)")
for n in names[:40]:
    print(f"{n} {m[n]:.2f} {h[n]:.2f} {h[n]-m[n]:+.2f}")
PY
for tree in main head; do perf report -q -i $D/profile-$tree-1.data --no-children --sort symbol --stdio --show-total-period 2>/dev/null | grep -m3 "Samples\|Event count"; done
echo done
