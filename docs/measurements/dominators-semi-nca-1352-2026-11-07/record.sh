#!/bin/sh
# Final-build records for #1352, each under its own lock hold: the 16k gotos profile, benchmark-dominators on
# sqlite3.c's exported CFGs (tree outputs) and on the synthetic shapes (analysis phase).
cd ~/buster-fast-bench/1352-claude || exit 1
./run.sh prof.log ./prof.sh gotos-16000
{ grep 'tier0' prof-stages.txt | head -1; cat prof-top.txt; } > prof-gotos-16000.txt
./run.sh cfg-final.log taskset -c 2 ./build/compiler benchmark-dominators --cfg sqlite.cfg --outputs tree
./run.sh bd-final.log taskset -c 2 ./build/compiler benchmark-dominators --phase analysis
echo finished
