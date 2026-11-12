#!/bin/bash
# run-all.sh: the three builds (each its own hold, build.sh), then each corpus's measurement (each its own hold, by
# queue.sh), detached from the ssh session that starts it.
cd "$(dirname "$0")"
echo $$ > run-all.pid
for t in main step1 head; do ./build.sh "$t"; done
./queue.sh q-measure.txt
echo "all done $(date -u +%FT%TZ)" >> run-all.log
