#!/bin/bash
# The local checks of the head's Release build, in turn; each one's log and exit status under /home/user/logs/verify.
cd /home/user/buster || exit 1
L=/home/user/logs/verify; rm -rf $L; mkdir -p $L
for k in 1 2 3 4; do (./build/compiler test-checker-driver --executable ./build/compiler --part $k/4 --in-process > $L/driver-$k.log 2>&1; echo "exit $?" >> $L/driver-$k.log) & done; wait
./build/compiler test-checker --seed 133 > $L/checker.log 2>&1; echo "exit $?" >> $L/checker.log
./build.sh check-call-graph --config Release > $L/call-graph.log 2>&1; echo "exit $?" >> $L/call-graph.log
./build/compiler test-call-graph > $L/test-call-graph.log 2>&1; echo "exit $?" >> $L/test-call-graph.log
bash /home/user/bench/corpora.sh /home/user/bin/compiler-base /home/user/bin/compiler-head /home/user/logs/corpora > $L/corpora.log 2>&1; echo "exit $?" >> $L/corpora.log
echo done > $L/complete
