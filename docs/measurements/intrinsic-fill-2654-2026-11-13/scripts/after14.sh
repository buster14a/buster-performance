#!/bin/bash
# after14.sh: runs q14 (main 447192ef against the final head 3a1001e0) once it is built.
cd ~/buster-fast-bench/893-claude
until grep -q "^exit " head-3a1001e0/build.log 2>/dev/null; do sleep 5; done
mv results results-round-13 && mkdir results
BASE_TREE=base-447192ef HEAD_TREE=head-3a1001e0 ./queue.sh q14.txt
