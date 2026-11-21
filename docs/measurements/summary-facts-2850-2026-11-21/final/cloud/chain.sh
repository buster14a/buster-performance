#!/bin/bash
# The frozen commit's checks in the cloud container, one heavy thing at a time: the checks (a Release build, the tests,
# the shadow on the four inputs, the other modes, the complete driver), every probe, the fuzzer, the regression
# programs, the faults from the list's end down, and the sanitizers' rows.
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
TREE=/home/user/buster-san OUT=$S/gchecks /home/user/keep/checks-rows.sh > $S/gchecks/run.log 2>&1
c=$S/gchecks/compiler
$S/spfb/run.sh $c $S/gprobes > $S/gprobes/run.log 2>&1
echo "probes done $(date -u +%H:%M)" >> $S/gchecks/progress.txt
cd $S/gfuzz
python3 /home/user/keep/fuzz/fuzz.py $c 61 15000 $S/gfuzz/plain > $S/gfuzz/run-61.log 2>&1 &
FUZZ_PAD=1 FUZZ_SEVERAL=1 python3 /home/user/keep/fuzz/fuzz.py $c 62 15000 $S/gfuzz/several > $S/gfuzz/run-62.log 2>&1 &
FUZZ_PRAGMA=1 python3 /home/user/keep/fuzz/fuzz.py $c 63 15000 $S/gfuzz/fenv > $S/gfuzz/run-63.log 2>&1 &
wait
python3 /home/user/keep/fuzz/fuzz.py $c 64 15000 $S/gfuzz/wall -Wall -Wextra > $S/gfuzz/run-64.log 2>&1 &
FUZZ_SLOPPY=0.12 python3 /home/user/keep/fuzz/fuzz.py $c 65 15000 $S/gfuzz/sloppy > $S/gfuzz/run-65.log 2>&1 &
FUZZ_SLOPPY=0.12 FUZZ_PAD=1 python3 /home/user/keep/fuzz/fuzz.py $c 66 15000 $S/gfuzz/sloppy-padded > $S/gfuzz/run-66.log 2>&1 &
wait
echo "fuzz done $(date -u +%H:%M)" >> $S/gchecks/progress.txt
cd /home/user/buster-san && find tests -name "*.c" | sort | python3 $S/tests-run/run.py $c > $S/gtests/out.txt 2>&1
echo "tests done $(date -u +%H:%M)" >> $S/gchecks/progress.txt
TREE=/home/user/mut-sides /home/user/keep/sides/faults/local-round.sh $S/sides/faults/cloud9 /home/user/keep/sides/faults/faults-sides.py $(seq 141 -1 0) > $S/sides/faults/cloud9/log.txt 2>&1
echo "faults done $(date -u +%H:%M)" >> $S/gchecks/progress.txt
/home/user/keep/sanitizers-parts.sh /home/user/buster-san $S/gsan "--passes 0 --window-rows" "5" > $S/gsan/log.txt 2>&1
echo "chain done $(date -u +%H:%M)" >> $S/gchecks/progress.txt
