#!/usr/bin/env bash
# cost2.sh: the compile-cost A/B again after the pass found its loops from the blocks' terminators instead of a CFG and
# dominators (buster 6380781): a Release build of the branch's tree (one hold), then compile-cost.sh at znver5 and
# x86-64 (one hold each). The first run's lines (a1a0892) move to out/cost-a1a0892. Started detached
# (systemd-run --user); writes progress.txt and cost2.done.
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
rm -f $R/cost2.done
step "cost2 start $(git -C $R/tree rev-parse HEAD)"
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; cd $R/tree && ./build.sh --config Release" > $R/build-tree2.log 2>&1
echo "exit $?" >> $R/build-tree2.log
sha256sum $BUSTER >> $R/env.txt
step "built tree $(git -C $R/tree rev-parse HEAD)"
[ -d out/cost-a1a0892 ] || mv out/cost out/cost-a1a0892
mkdir -p out/cost
for MARCH in znver5 x86-64; do
    $LOCK ./compile-cost.sh $SQLITE sqlite3 11 $MARCH >> out/cost/results.txt 2>> out/cost/run.log
    step "cost2 $MARCH"
done
touch $R/cost2.done
step "cost2 done"
