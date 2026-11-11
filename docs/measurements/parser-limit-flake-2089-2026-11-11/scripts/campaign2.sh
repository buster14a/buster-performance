#!/bin/bash
# The 9700X's part of #2089: builds the depth-experiment and fixed trees, measures the stack offset with ASLR off,
# reproduces the failure deterministically on main, then loops the fixed build. One hold of the lock per build or run.
B=$HOME/buster-fast-bench/2089-claude
export EXCLUSIVE_OWNER=claude-2089 EXCLUSIVE_TITLE="test-parser limit flake (#2089)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2089
X=~/buster-fast-bench/exclusive.sh
L=$B/logs/c2
mkdir -p $L
for t in depth fix; do
  cd $B/trees/$t && $X ./build.sh > $L/build-$t.log 2>&1
  echo "build $t $?" >> $L/steps.txt
done
pad() { head -c $1 /dev/zero | tr '\0' x; }
cd $B/trees/depth && $X setarch -R env -i PAD= taskset -c 2 ./build/compiler test-parser > $L/depth-0.txt 2>&1
echo "depth-0 $?" >> $L/steps.txt
line=$(grep "^depth: a valid file" $L/depth-0.txt)
x=$(echo "$line" | sed 's/.*reference % 4096 = \([0-9]*\),.*/\1/')
d=$(echo "$line" | sed 's/.*drive \([0-9]*\),.*/\1/')
m=$(( ((x - d) % 4096 + 4096) % 4096 ))
p=$(( m - m % 64 ))
echo "ref%4096 $x drive $d pad $p" >> $L/steps.txt
cd $B/trees/depth && $X setarch -R env -i PAD=$(pad $p) taskset -c 2 ./build/compiler test-parser > $L/depth-$p.txt 2>&1
echo "depth-$p $?" >> $L/steps.txt
for t in main fix; do
  for q in $p $((p + 128)); do
    cd $B/trees/$t && $X setarch -R env -i PAD=$(pad $q) taskset -c 2 ./build/compiler test-parser > $L/$t-pad-$q.txt 2>&1
    echo "$t-pad-$q $?" >> $L/steps.txt
  done
done
$B/loop.sh c2 30 plain fix
$B/loop.sh c2 15 perf fix
echo done >> $L/steps.txt
