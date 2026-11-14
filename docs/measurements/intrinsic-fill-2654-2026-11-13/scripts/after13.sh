#!/bin/bash
# after13.sh: runs q13 (main 447192ef, head 18145a06, scalar variant 8ed0b892) once all three trees are built.
cd ~/buster-fast-bench/893-claude
for tree in base-447192ef head-18145a06 scalar-8ed0b892; do until grep -q "^exit " $tree/build.log 2>/dev/null; do sleep 5; done; done
mv results results-round-12 && mkdir results
BASE_TREE=base-447192ef HEAD_TREE=head-18145a06 ./queue.sh q13.txt
