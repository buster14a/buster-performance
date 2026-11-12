#!/bin/bash
# run2.sh: round 2, detached: the step 4 and step 3 builds (build2.sh, each its own hold), then each corpus's timings and
# peaks (each its own hold, by queue.sh).
cd "$(dirname "$0")"
echo $$ > run2.pid
./build2.sh step4 ed681ad5754e9eae258bd759685c4078302d77b7
./build2.sh step3 7b6eb29e7cd104ecf44990c05aa063155e40ddec
./queue.sh q-measure2.txt
echo "round 2 done $(date -u +%FT%TZ)" >> run2.log
