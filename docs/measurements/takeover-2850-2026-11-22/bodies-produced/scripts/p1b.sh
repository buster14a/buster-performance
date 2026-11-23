#!/bin/bash
# p1b.sh WORKTREE BLOCKS LOG: BLOCKS run with the producer beside every unit's read (BUSTER_TEST_NODE_BODIES_LOG=LOG, nothing
# masked): the blocks' own result, and from the log the units read, those the producer ran in, the bodies it had a verdict
# of and those it took, the diagnostics looked at, and those at a token of a taken body.
set -uo pipefail
tree=$1; blocks=$2; log=$3
export PATH="$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
export CORES_TITLE="#2850: the producer against every diagnostic of the tests' units" CORES_LINK="https://github.com/buster14a/buster/issues/2850"
cd "$tree"
: > "$log"; mkdir -p "$log.units"
BUSTER_TEST_NODE_BODIES_LOG="$log" BUSTER_COMPILER="$tree/build/cmake/native/Develop/compiler" cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < "'"$blocks"'"' > "$log.blocks" 2>&1
echo "blocks exit $?"
grep -E "^parallel: .* passed" "$log.blocks"
grep -E "^== .*: failed" "$log.blocks" | head -20
python3 - "$log" <<'PY'
import re, sys
units = ran = bodies = taken = looked = found = 0
lines = 0
for line in open(sys.argv[1], errors='replace'):
    m = re.match(r"unit=(.*) producer-ran=(\d) bodies=(\d+) taken=(\d+) diagnostics-looked-at=(\d+) in-a-taken-body=(\d+)", line)
    if m:
        units += 1; ran += int(m.group(2)); bodies += int(m.group(3)); taken += int(m.group(4)); looked += int(m.group(5)); found += int(m.group(6))
    elif line.startswith("IN-A-TAKEN-BODY"):
        lines += 1
print(f"units={units} the-producer-ran-in={ran} bodies={bodies} taken={taken} diagnostics-looked-at={looked} in-a-taken-body={found} (lines {lines})")
PY
