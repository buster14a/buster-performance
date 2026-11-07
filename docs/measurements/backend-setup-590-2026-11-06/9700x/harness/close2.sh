#!/bin/bash
# #590's closing qualification on benchpress, the shortened second part of close.sh (the lock was contended: each run
# waited 10 to 15 minutes): one round of empty.c and hello.c, baked and built (BUSTER_BAKE=0), THP always (the host's)
# and disabled (harness/nothp), against tcc, then c-testsuite's subset with THP always. Every run takes the shared lock
# itself (exclusive.sh) and is pinned to CPU 2. A log close.sh already wrote is kept.
set -u
cd ~/buster-fast-bench/590-claude
export EXCLUSIVE_OWNER=claude-590 EXCLUSIVE_TITLE="#590 closing qualification: baked tables at main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/590
ex=~/buster-fast-bench/exclusive.sh
work=close
log=$work/logs
obj=$work/objects
for input in empty hello; do
    for cond in always disabled; do
        wrap=""
        [ $cond = disabled ] && wrap=harness/nothp
        for t in unbaked baked; do
            out=$log/$input-$cond-$t-1.txt
            if [ -s $out ] && grep -q '^measure-compile: 0 failures' $out; then continue; fi
            $ex taskset -c 2 $wrap $(pwd)/$work/$t measure-compile --runs 41 --reference /usr/bin/tcc -- -c $work/inputs/$input.c > $out 2>&1
        done
    done
done
$ex taskset -c 2 harness/best_of $obj/best_of.o 3 $(pwd)/$work/unbaked $(pwd)/$work/baked /usr/bin/tcc < $log/subset.list > $log/c-testsuite-always.txt 2>&1
echo done > $log/DONE
