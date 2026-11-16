#!/bin/bash
# tests-time.sh LABEL: how long results/LABEL/compiler's test-tier0 takes, alone and with --cross-check, on CPUs 0 to 7
# as the 9700X's job runs it (the guide's figures), each run its own hold of the lock, from trees/LABEL (the fixtures'
# root). results/LABEL/tests-time.txt.
set -u
cd "$(dirname "$0")"
label=$1
out=$PWD/results/$label
tree=$PWD/trees/$label
: > "$out/tests-time.txt"
for options in "" "--cross-check"; do
    ./lock.sh bash -c "cd $tree && start=\$(date +%s%N) && taskset -c 0-7 $out/compiler test-tier0 $options | tail -1; echo \"test-tier0 $options: status \$? in \$(( (\$(date +%s%N) - start) / 1000000 )) ms\"" >> "$out/tests-time.txt" 2>&1
done
cat "$out/tests-time.txt"
