#!/bin/bash
# Builds each mutant of mutants_opt.py in worktree $1, runs the runners, prints killed/survived.
set -u
W=$1
D=$(cd "$(dirname "$0")" && pwd)
C=$W/src/buster/compiler
python3 - "$D" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); from mutants_opt import MUTANTS
open(sys.argv[1] + "/names.txt", "w").write("\n".join(m[0] for m in MUTANTS) + "\n")
PY
while read -r name; do
    (cd "$W" && git checkout -q -- src)
    python3 - "$D" "$name" "$C" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); from mutants_opt import MUTANTS
m = [x for x in MUTANTS if x[0] == sys.argv[2]][0]
p = sys.argv[3] + "/" + m[1]
s = open(p).read()
assert s.count(m[2]) == 1, m[0]
open(p, "w").write(s.replace(m[2], m[3]))
PY
    (cd "$W" && BUSTER_TOOLCHAIN=path ./build.sh > "$D/$name.build" 2>&1) || { echo "$name build-failed" >> "$D/results"; continue; }
    killed=""
    for t in "test-ir-optimize" "test-ir-gvn" "test-ir-licm" "test-tier1-pipeline" "test-tier1-wide"; do
        (cd "$W" && timeout 1500 ./build/compiler $t > "$D/$name.$(echo $t | tr ' ' _).log" 2>&1) || killed="$killed $t"
    done
    if [ -n "$killed" ]; then echo "$name killed by$killed" >> "$D/results"; else echo "$name SURVIVED" >> "$D/results"; fi
done < "$D/names.txt"
(cd "$W" && git checkout -q -- src)
echo done >> "$D/results"
