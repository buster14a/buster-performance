#!/bin/bash
# After the first round: the archived tree refreshed to the PR's head (tar -m: every file newer than the old build), and
# each survivor run again against the head's tests.
M=/root/.cache/claude-c7/c12c/mut
until grep -qx done $M/results.txt; do sleep 30; done
survivors=$(sed -n 's/^\(m[0-9]*\) SURVIVED$/\1/p' $M/results.txt | tr '\n' ' ')
H=$(git -C /home/user/buster-c12c rev-parse HEAD)
echo "rerun on $H: $survivors" >> $M/results.txt
git -C /home/user/buster-c12c archive $H | tar -xm -C $M/tree
(cd $M/tree && ./build.sh > $M/rerun-base-build.log 2>&1); echo "rerun base build $?" >> $M/results.txt
cd $M && python3 run.py $survivors
