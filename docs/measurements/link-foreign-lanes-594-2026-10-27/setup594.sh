#!/bin/bash
# setup594.sh: #594's build of main (v0) and the inputs, on the 9700X, each under its own hold of the shared lock:
# BUSTER_DEBUG_INFO=0 ./build.sh as the CI job builds, then benchmark-link's programs written as objects (--keep), one
# benchmark-link call per program, since each overwrites its work directory's objects.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > setup594.pid
export EXCLUSIVE_OWNER=claude-594 EXCLUSIVE_TITLE="link-foreign lanes by the link's work (#594)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/594
~/buster-fast-bench/exclusive.sh bash -c "cd $D/v0 && BUSTER_DEBUG_INFO=0 ./build.sh" > build-v0.log 2>&1
echo "build v0 $? $(date -Is)" >> setup594.log
cc -O2 -Wall -o procbench procbench.c >> setup594.log 2>&1
echo "procbench $? $(date -Is)" >> setup594.log
for spec in 1:8 2000:8 2000:64 5000:64 10000:64 20000:64 40000:64 102400:64; do
    n=${spec%:*}
    f=${spec#*:}
    mkdir -p "links/$n-$f"
    ~/buster-fast-bench/exclusive.sh "$D/v0/build/compiler" benchmark-link --functions "$n" --filler "$f" --only linkers --linkers link-foreign \
        --kinds dynamic,static,static-pie,shared --runs 1 --keep --directory "$D/links/$n-$f" > "links/$n-$f.log" 2>&1
    echo "links $n $f $? $(date -Is)" >> setup594.log
done
echo "done $(date -Is)" >> setup594.log
