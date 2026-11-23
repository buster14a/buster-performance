#!/bin/bash
# ab.sh TAG ROUNDS BUILD...: each round runs every build once, in a rotating order, each run under the lock,
# pinned to CPU 2, with the load and the busiest processes before and after.
D=~/buster-fast-bench/3375-claude
cd $D
TAG=$1; ROUNDS=$2; shift 2
B=("$@"); N=${#B[@]}
L="EXCLUSIVE_OWNER=claude-3375 EXCLUSIVE_TITLE=issue-3375-calling-convention-kernel EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3375"
mkdir -p runs-$TAG
for r in $(seq 1 $ROUNDS); do
  for i in $(seq 0 $((N-1))); do
    t=${B[$(( (i + r) % N ))]}
    [ $((r % 2)) = 0 ] && t=${B[$(( (N - 1 - i + r) % N ))]}
    env $L ~/buster-fast-bench/exclusive.sh bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; taskset -c 2 $D/$t/build/compiler benchmark-calling-convention --only assignment; echo \"exit \$?\"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6" > runs-$TAG/$r-$t.log 2>&1
  done
done
echo done > runs-$TAG/done
