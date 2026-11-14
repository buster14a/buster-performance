#!/bin/sh
# #1444, the checker's section, second round: head2 (the start list sampled again with a period per process), its
# census, and the timings of base, head and head2, each step its own holds of the 9700X's lock.
set -eu
d=~/buster-fast-bench/1444-claude-checker
cd $d
echo $$ > chain2.pid
./build-tree.sh head2 1a3050a3145db39b5290d42ca5a1fae72a7f8a3e
./census.sh head2 syntax preprocess tiny hello check parse
./ab.sh main2 2 base head head2
./kstat.sh main2 base head head2
echo done > chain2.done
