#!/bin/bash
# Usage: faults.sh FAULT_BINARY BASE N...: for each fault N, frames.c's comparison and the area's inventory blocks
# (fail-fast) under BUSTER_FAULT2874=N; one line a fault.
set -u
BIN=$1; BASE=$2; shift 2
S=/tmp/claude-0/-home-user/da9b228d-448f-5dff-bcec-738df11c230d/scratchpad
T=$(ls -d /root/.cache/buster/toolchain/*/llvm-23.1.4/bin | head -1)
for n in "$@"; do
    f=$(BUSTER_FAULT2874=$n $S/piece2/fcmp.sh $BASE $BIN 2>&1 | tail -1)
    diffs=$(BUSTER_FAULT2874=$n $S/piece2/fcmp.sh $BASE $BIN 2>&1 | grep '^DIFF' | tr '\n' ';')
    (cd /home/user/buster && BUSTER_FAULT2874=$n BUSTER_CORPUS=/home/user/corpus PATH=$T:$PATH $BIN parallel --jobs 4 --fail-fast $S/piece2/area.tests > $S/piece2/fault-$n.log 2>&1)
    tests=$(grep -E "^parallel: .* passed" $S/piece2/fault-$n.log | tail -1)
    failed=$(grep -E "^== .*: failed" $S/piece2/fault-$n.log | sed 's/: failed.*//' | tr '\n' ';')
    echo "fault $n | $f | $diffs | $tests | $failed"
done
