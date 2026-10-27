#!/bin/bash
# Builds head (b2), #520's head (m520) and their merge (b2-520), then measures main against head and the two stage
# clocks against each other: each step takes the lock for itself.
cd ~/buster-fast-bench/check-input-529
echo $$ > queue2.pid
./build.sh b2
./build.sh m520
./build.sh b2-520
./measure.sh main-nd b2 m-b2
./stages.sh m520 b2-520 s-b2
echo "queue2 done"
