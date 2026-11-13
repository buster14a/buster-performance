#!/bin/bash
# mutants.sh: each mutant in /home/user/w2553/mt (a worktree of the branch), built without debug information, then the
# tests that must catch it; the worktree is restored after each.
set -u
M=/home/user/w2553/mt
F=$M/src/buster/compiler
run() {
    local name=$1 file=$2 old=$3 new=$4; shift 4
    cd $M && git checkout -q . && cp /home/user/buster/src/buster/compiler/tier1_cfg_test.c $F/ && python3 - "$F/$file" "$old" "$new" <<'PY'
import sys
p, old, new = sys.argv[1], sys.argv[2], sys.argv[3]
s = open(p).read()
assert s.count(old) == 1, ("mutant site", s.count(old))
open(p, 'w').write(s.replace(old, new))
PY
    (cd $M && BUSTER_DEBUG_INFO=0 ./build.sh > /home/user/w2553/mt-$name.build 2>&1) || { echo "$name: build failed"; return; }
    for t in "$@"; do
        echo "$name: $t: $(cd $M && ./build/compiler $t 2>&1 | grep -E 'failures|test-tier1-cfg: (the|a) ' | head -3 | tr '\n' ' ' | cut -c1-400)"
    done
}
run nearest tier1_cfg.c "chosen[b] = latch != BUSTER_TIER1_CFG_NONE ? latch : anchored != BUSTER_TIER1_CFG_NONE ? anchored : nearest;" "chosen[b] = latch != BUSTER_TIER1_CFG_NONE ? latch : nearest;" test-tier1-cfg
run nolatch tier1_cfg.c "anchors[b] = latch != BUSTER_TIER1_CFG_NONE ? input->predecessors[input->predecessor_offsets[b] + latch] : anchors[b];" "anchors[b] = anchors[b];" test-tier1-cfg
cd $M && git checkout -q .
