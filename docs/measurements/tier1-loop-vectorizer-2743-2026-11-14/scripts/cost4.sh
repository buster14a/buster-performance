#!/usr/bin/env bash
# cost4.sh: with a5b52808d's Release build (cost3.sh's), the sqlite3.c A/B at znver5 and x86-64 without Tier 1's unit
# inlining on both sides (-inline against -inline,+vectorize, one hold per target): the pass without the downstream
# cost of the loop that inlining puts in sqlite3VdbeExec. Results go to out/cost-noinline. Writes progress.txt and
# cost4.done.
set -u
R=~/buster-fast-bench/2743-claude
cd $R/loops || exit 1
export EXCLUSIVE_OWNER=claude-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 loop vectorizer"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2804
LOCK=~/buster-fast-bench/exclusive.sh
SQLITE=$R/corpus/sqlite/sqlite3.c
export BUSTER=$R/tree/build/compiler
step() { echo "$(date -u +%FT%TZ) $*" >> $R/progress.txt; }
rm -f $R/cost4.done
step "cost4 start $(git -C $R/tree rev-parse HEAD) $(sha256sum $BUSTER | cut -c1-16)"
[ -d out/cost ] && mv out/cost out/cost-previous-$(date +%s)
mkdir -p out/cost
for MARCH in znver5 x86-64; do
    $LOCK ./cost-flags.sh $SQLITE sqlite3 11 $MARCH -inline -inline,+vectorize >> out/cost/results.txt 2>> out/cost/run.log
    step "cost4 $MARCH"
done
mv out/cost out/cost-noinline
touch $R/cost4.done
step "cost4 done"
