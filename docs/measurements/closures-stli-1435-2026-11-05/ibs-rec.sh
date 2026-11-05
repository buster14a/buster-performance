#!/usr/bin/env bash
# 1435 IBS: closures.lua's ops sampled by IBS (every 8191st uop, user space; the kernel throttles a run to about 5,000
# samples), Tier 1 Lua builds at shift 0, ASLR off and the environment of envsweep's k (16 k bytes), RUNS runs of each
# alternating, each record and its parsing one hold, pinned to CPU 2; concatenated into $c-$TAG.tsv.
set -u
W=$HOME/buster-fast-bench/1435-claude
export EXCLUSIVE_OWNER=claude-1435 EXCLUSIVE_TITLE='Problem 1435' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1435
L=$HOME/buster-fast-bench/exclusive.sh
K=${1:-0}
TAG=${2:-k$K}
RUNS=${RUNS:-40}
BUILDS=${BUILDS:-main head}
exe() { case $1 in main|head) echo $W/base/lua-$1-p0 ;; *) echo $W/pad/lua-$1-p0 ;; esac; }
O=$W/ibs
mkdir -p $O && cd $O || exit 1
v=$(head -c $((16 * K)) /dev/zero | tr '\0' x)
for c in $BUILDS; do : > $O/$c-$TAG.tsv; done
for r in $(seq 1 $RUNS); do
    for c in $BUILDS; do
        $L bash -c "env -i PATH=/usr/bin:/bin PADENV=$v setarch -R taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -R -d -c 8191 -o $O/one-$TAG.data $(exe $c) $W/base/closures.lua > /dev/null 2>&1; $W/ibs-parse.sh $O/one-$TAG.data $O/one-$TAG > /dev/null; cat $O/one-$TAG.tsv >> $O/$c-$TAG.tsv"
    done
done
rm -f $O/one-$TAG.*
echo done > $O/done-$TAG.txt
