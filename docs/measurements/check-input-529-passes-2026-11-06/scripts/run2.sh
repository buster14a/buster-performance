#!/bin/bash
base=~/buster-fast-bench/529-claude-galileo
cd $base
if [ ! -d pr1530 ]; then git -C main worktree add -q ../pr1530 pr1530; fi
./prof.sh main main
./prof.sh pr1530 pr1530
