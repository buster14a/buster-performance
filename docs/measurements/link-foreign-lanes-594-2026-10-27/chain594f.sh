#!/bin/bash
# chain594f.sh: the head (v1, with benchmark-link's row on every CPU) built again under one hold, then the confirmation's
# two passes (confirm594d.sh), benchmark-link's link-foreign rows by the head, and the outputs' identities.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > chain594f.pid
export EXCLUSIVE_OWNER=claude-594 EXCLUSIVE_TITLE="link-foreign lanes by the link's work (#594): head build" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/594
~/buster-fast-bench/exclusive.sh bash -c "cd $D/v1 && BUSTER_DEBUG_INFO=0 ./build.sh" > build-v1b.log 2>&1
echo "build v1b $? $(date -Is)" >> setup594.log
sha256sum v0/build/compiler v1/build/compiler > builds594.sha256
sleep 20
./confirm594d.sh 2 > confirm594d.out 2>&1
sleep 20
./linkbench594.sh v1 1
./outputs594.sh > outputs594.txt 2>&1
echo "outputs $? $(date -Is)" >> confirm594d.log
