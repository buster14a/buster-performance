#!/bin/bash
# The last test commit (e526b3bfb): its build and test-checker's four parts unmutated, then m10 against it in the
# mutation tree once the survivors' rerun is done.
O=/root/.cache/claude-c7/c12c/final; mkdir -p $O; S=$O/status.txt; : > $S
E=/root/.cache/claude-c7/c12c/edit
cd $E && ./build.sh > $O/build.log 2>&1; echo "build: $?" >> $S
for k in 1 2 3 4; do timeout -k 5 1500 ./build/compiler test-checker --part $k/4 > $O/checker-$k.log 2>&1 & done
for j in $(jobs -p); do wait $j; done
echo "checker: $(grep -h ' failures$' $O/checker-*.log | awk '{f+=$4} END {print f " failures"}'), $(grep -h 'recorded digests' $O/checker-*.log | awk '{a+=$6; b+=$11} END {print a " with a line, " b " without"}'), $(grep -h 'literal grammar' $O/checker-*.log | head -3 | tr '\n' ' ')" >> $S
M=/root/.cache/claude-c7/c12c/mut
until [ "$(grep -cx done $M/results.txt)" -ge 2 ]; do sleep 30; done
git -C $E archive HEAD | tar -xm -C $M/tree
echo "m10 on $(git -C $E rev-parse --short HEAD)" >> $M/results.txt
cd $M && python3 run.py m10
echo done >> $S
