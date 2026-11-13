#!/bin/sh
# Populate alone: first (the .bss change) against pop (and populate), cold and warm, first again as the floor.
d=~/buster-fast-bench/1444-claude-rest
cd $d
. ./env.sh
./kstat.sh pop first pop
./ab.sh pop 2 first pop
echo done > chain5.done
