#!/bin/bash
# setup594b.sh: the executables' objects (benchmark-link writes a program's objects again for each kind, and the
# shared library's differ: setup594.sh's links/N-F keep those), each program with --kinds dynamic into links/N-F-exec,
# all under one hold of the shared lock.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > setup594b.pid
export EXCLUSIVE_OWNER=claude-594 EXCLUSIVE_TITLE="link-foreign lanes by the link's work (#594): inputs" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/594
~/buster-fast-bench/exclusive.sh bash -c '
for spec in 1:8 2000:8 2000:64 5000:64 10000:64 20000:64 40000:64 102400:64; do
    n=${spec%:*}
    f=${spec#*:}
    mkdir -p "links/$n-$f-exec"
    ./v0/build/compiler benchmark-link --functions "$n" --filler "$f" --only linkers --linkers link-foreign --kinds dynamic --runs 1 --keep \
        --directory "'"$D"'/links/$n-$f-exec" > "links/$n-$f-exec.log" 2>&1
    echo "exec links $n $f $? $(date -Is)" >> setup594.log
done'
echo "exec done $(date -Is)" >> setup594.log
