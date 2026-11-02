#!/bin/bash
# Builds head2-wip (one hold), then measures main, head1 and head2 (another hold); writes logs/run-b1.done at its end.
D=$HOME/buster-fast-bench/1128-claude
cd $D/head2-wip && EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE="solve #1128 head2 build" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128 \
    ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > $D/head2-build.log 2>&1
echo "build exit $?" > $D/logs/run-b1.status
$D/scripts/measure3.sh b1 11 main=base-3ce71ec3 head1=head1-wip head2=head2-wip
echo "measure exit $?" >> $D/logs/run-b1.status
touch $D/logs/run-b1.done
