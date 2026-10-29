#!/bin/bash
# The A/B of #837's head (qf2), #857's final head (lb3) and #858's (cq3), each against the first, then the lowering's
# attribution of the three. Each run takes the 9700X's lock per run itself.
cd ~/buster-fast-bench/cc137-claude
echo $$ > queue-m137h.pid
./measure2.sh m137h qf2 lb3 cq3 > m137h.out 2>&1
./lowstat.sh ls4 qf2 lb3 cq3 > ls4.out 2>&1
