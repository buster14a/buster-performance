#!/usr/bin/env bash
# cost3.sh REVISION: the compile-cost A/B of REVISION's tree (one hold for its Release build, one per target), then
# one hold for a profile: perf record of `--tier1 -c sqlite3.c` at znver5 without and with --tier1-passes=+vectorize
# (user instructions, a period varied per run), each reported by symbol. Results go to out/cost-REVISION. Started
# detached (systemd-run --user); writes progress.txt and cost3.done.
set -u
REVISION=$1
R=~/buster-fast-bench/2743-claude
cd $R/loops || exit 1
export EXCLUSIVE_OWNER=claude-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 loop vectorizer"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2804
LOCK=~/buster-fast-bench/exclusive.sh
SQLITE=$R/corpus/sqlite/sqlite3.c
export BUSTER=$R/tree/build/compiler
step() { echo "$(date -u +%FT%TZ) $*" >> $R/progress.txt; }
rm -f $R/cost3.done
step "cost3 start $(git -C $R/tree rev-parse HEAD)"
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; cd $R/tree && ./build.sh --config Release" > $R/build-tree3.log 2>&1
echo "exit $?" >> $R/build-tree3.log
sha256sum $BUSTER >> $R/env.txt
step "built tree $(git -C $R/tree rev-parse HEAD)"
[ -d out/cost ] && mv out/cost out/cost-previous-$(date +%s)
mkdir -p out/cost
for MARCH in znver5 x86-64; do
    $LOCK ./compile-cost.sh $SQLITE sqlite3 11 $MARCH >> out/cost/results.txt 2>> out/cost/run.log
    step "cost3 $MARCH"
done
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt
for variant in base vectorize; do
    extra=''
    [ \$variant = vectorize ] && extra=--tier1-passes=+vectorize
    taskset -c 2 perf record -q -e instructions:u -c 200003 -o out/cost/\$variant.data -- $BUSTER --tier1 \$extra -O2 -march=znver5 -c $SQLITE -o /dev/shm/claude-2743-\$variant.o > /dev/null 2>&1
    perf report -q -i out/cost/\$variant.data --stdio --no-children --sort sym 2> /dev/null | head -80 > out/cost/\$variant-symbols.txt
done" >> out/cost/run.log 2>&1
rm -f /dev/shm/claude-2743-base.o /dev/shm/claude-2743-vectorize.o
mv out/cost out/cost-$REVISION
touch $R/cost3.done
step "cost3 done"
