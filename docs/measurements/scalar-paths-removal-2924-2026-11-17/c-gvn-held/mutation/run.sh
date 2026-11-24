#!/bin/bash
# Builds each mutant of mutants.py in the worktree $1 and runs the runners; prints killed/survived.
set -u
W=$1
D=$(cd "$(dirname "$0")" && pwd)
F=$W/src/buster/compiler/ir_optimize_gvn.c
cp "$F" "$D/original.c"
python3 - "$D" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); from mutants import MUTANTS
open(sys.argv[1] + "/names.txt", "w").write("\n".join(m[0] for m in MUTANTS) + "\n")
PY
while read -r name; do
    python3 - "$D" "$name" "$F" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); from mutants import MUTANTS
m = [x for x in MUTANTS if x[0] == sys.argv[2]][0]
s = open(sys.argv[1] + "/original.c").read()
assert s.count(m[1]) == 1, m[0]
open(sys.argv[3], "w").write(s.replace(m[1], m[2]))
PY
    (cd "$W" && BUSTER_TOOLCHAIN=path ./build.sh > "$D/$name.build" 2>&1) || { echo "$name build-failed" >> "$D/results"; continue; }
    killed=""
    for t in "test-ir-gvn" "test-ir-optimize" "test-ir-licm" "test-ir-simd"; do
        (cd "$W" && timeout 900 ./build/compiler $t > "$D/$name.$(echo $t | tr ' ' _).log" 2>&1) || killed="$killed $t"
    done
    if [ -n "$killed" ]; then echo "$name killed by$killed" >> "$D/results"; else echo "$name SURVIVED" >> "$D/results"; fi
done < "$D/names.txt"
cp "$D/original.c" "$F"
echo done >> "$D/results"
