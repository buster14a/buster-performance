#!/bin/bash
# after12.sh: runs q12 (main 447192ef against head 90758cc0) once both trees are built.
cd ~/buster-fast-bench/893-claude
for tree in base-447192ef head-90758cc0; do until grep -q "^exit " $tree/build.log 2>/dev/null; do sleep 5; done; done
BASE_TREE=base-447192ef HEAD_TREE=head-90758cc0 ./queue.sh q12.txt
