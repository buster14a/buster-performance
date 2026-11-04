#!/usr/bin/env bash
# queue14.sh: the head (c5f4863a) against its main (730eea0a): builds, perf stat of --tier1 -c of the frozen sqlite3.c
# (bisect.sh, bisect14/) and ab, 5 rounds of 21 runs (ab14/); then #142's campaign at the head, seeds 3400 to 3438, by the
# vector path and again with --scalar (campaign.sh, diff-head-c5f4863a/, diff-scalar-head-c5f4863a/), tallied by
# claude-141-takeover's campaign-tally.sh.
. ~/buster-fast-bench/claude-141-wide/common.sh
until [ ! -f queue12.sh ] || [ -f bisect12/done ]; do sleep 20; done
for t in head-c5f4863a main-730eea0a; do
    rm -rf $t && tar xzf $t.tgz && rm $t.tgz
done
./build.sh main-730eea0a head-c5f4863a
BISECT_OUT=bisect14 ./bisect.sh main-730eea0a head-c5f4863a
mkdir -p ab14
head-c5f4863a/build/compiler ab --rounds 5 --cpu 2 --lock $lock main-730eea0a head-c5f4863a -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/ab14.o $Q/sqlite3.c > ab14/compile-tier1-ab.log 2>&1
echo "exit $?" >> ab14/compile-tier1-ab.log
touch ab14/done
./campaign.sh head-c5f4863a c5f4863a1b76842cd14eaea4ce37f86877f607e0 3400 3438
./campaign.sh head-c5f4863a c5f4863a1b76842cd14eaea4ce37f86877f607e0 3400 3438 scalar
for d in diff-head-c5f4863a diff-scalar-head-c5f4863a; do ../claude-141-takeover/campaign-tally.sh $d | sort > $d/campaign.tsv; done
touch campaign14.done
