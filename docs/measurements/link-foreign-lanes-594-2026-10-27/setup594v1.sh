#!/bin/bash
# setup594v1.sh: the head (v1) built as the CI job builds it, then its tests that run link-foreign, each under its own
# hold of the shared lock, in a TMPDIR of its own.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > setup594v1.pid
export EXCLUSIVE_OWNER=claude-594 EXCLUSIVE_TITLE="link-foreign lanes by the link's work (#594): head build and tests" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/594
mkdir -p "$D/tmp"
~/buster-fast-bench/exclusive.sh bash -c "cd $D/v1 && BUSTER_DEBUG_INFO=0 ./build.sh" > build-v1.log 2>&1
echo "build v1 $? $(date -Is)" >> setup594.log
for t in "test-foreign --cross-check" "test-foreign-corpus" "test-check-debug --cross-check" "test-call-graph"; do
    name=$(echo "$t" | tr ' ' '_')
    ~/buster-fast-bench/exclusive.sh bash -c "cd $D/v1 && TMPDIR=$D/tmp taskset -c 0-7 ./build/compiler $t" > "v1-$name.log" 2>&1
    echo "v1 $t $? $(date -Is)" >> setup594.log
done
~/buster-fast-bench/exclusive.sh bash -c "cd $D/v1 && ./build.sh check-call-graph" > v1-check-call-graph.log 2>&1
echo "v1 check-call-graph $? $(date -Is)" >> setup594.log
echo "v1 done $(date -Is)" >> setup594.log
