#!/bin/bash
# After the round: the mutation tree takes the tests commit's new unsequenced fixture (e4b4f2a61), then the control,
# u2, u3 and u4 (driver parts first) and d4 (rewritten to build) run again.
M=/root/.cache/claude-c7/c12k/mut5
until grep -q '^done' $M/results.txt; do sleep 15; done
git -C /home/user/buster-c12c3 show e4b4f2a61:src/buster/compiler/c_check_unsequenced_driver_test.c > $M/tree/src/buster/compiler/c_check_unsequenced_driver_test.c
echo "reruns: the tree takes e4b4f2a61's unsequenced fixture" >> $M/results.txt
cd $M && python3 $M/run.py none u2 u3 u4 d4 > $M/runner3.out 2>&1
echo "reruns done" >> $M/results.txt
