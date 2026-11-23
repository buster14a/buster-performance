#!/bin/bash
# forced.sh WORKTREE BLOCKS OUT SELECT: BLOCKS run with --node-bodies forced on every command that can have it
# (BUSTER_TEST_NODE_BODIES=SELECT: 1 for every body the producer takes, N:K for those whose place is K modulo N): the
# blocks' own result.
set -uo pipefail
tree=$1; blocks=$2; out=$3; select=$4
# With a fifth argument, the gate's log too (BUSTER_TEST_NODE_BODIES_LOG): a line a unit with the bodies it took.
log=${5:-}
[[ -n $log ]] && { : > "$log"; mkdir -p "$log.units"; export BUSTER_TEST_NODE_BODIES_LOG="$log"; }
export PATH="$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
export CORES_TITLE="#2850: the tests with --node-bodies forced on ($select)" CORES_LINK="https://github.com/buster14a/buster/issues/2850"
cd "$tree"
BUSTER_TEST_NODE_BODIES="$select" BUSTER_COMPILER="$tree/build/cmake/native/Develop/compiler" cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < "'"$blocks"'"' > "$out" 2>&1
echo "blocks exit $? (select $select)"
grep -E "^parallel: .* passed" "$out"
grep -E "^== .*: failed" "$out" | head -40
[[ -n $log ]] && python3 - "$log" <<'PY'
import re, sys
units = ran = bodies = taken = looked = found = with_taken = 0
for line in open(sys.argv[1], errors='replace'):
    m = re.match(r"unit=(.*) producer-ran=(\d) bodies=(\d+) taken=(\d+) diagnostics-looked-at=(\d+) in-a-taken-body=(\d+)", line)
    if m:
        units += 1; ran += int(m.group(2)); bodies += int(m.group(3)); taken += int(m.group(4)); looked += int(m.group(5)); found += int(m.group(6)); with_taken += int(m.group(4)) != 0
print(f"units={units} the-producer-ran-in={ran} units-with-a-taken-body={with_taken} bodies={bodies} taken={taken} diagnostics-looked-at={looked} in-a-taken-body={found}")
PY
