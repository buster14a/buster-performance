#!/usr/bin/env bash
# measure2.sh: measure.sh's remainder, restarted after x86-64's buster-tier1-vec placements, with one lock hold per build
# (its four placements in turn, about a minute) instead of one per placement: the shared lock's queue had made each
# hold wait about ten minutes. Started detached (systemd-run --user); writes progress.txt and measure.done.
set -u
R=~/buster-fast-bench/2743-claude
cd $R/loops || exit 1
export EXCLUSIVE_OWNER=claude-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 loop vectorizer"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
LOCK=~/buster-fast-bench/exclusive.sh
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
export BUSTER=$R/tree/build/compiler
export MAIN=$R/main/build/compiler
step() { echo "$(date -u +%FT%TZ) $*" >> $R/progress.txt; }
rm -f $R/measure.done
step restart
for MARCH in x86-64 znver5; do
    O=out/$MARCH
    mkdir -p $O
    if [ "$MARCH" = x86-64 ]; then
        NAMES="buster-tier1 clang-O2 clang-O2-novec clang-O2-novec-nounroll"
        # The interrupted build's lines go: it runs again whole.
        grep -v " buster-tier1 \| perf x86-64 buster-tier1 " $O/results.txt > $O/results.kept && mv $O/results.kept $O/results.txt
    else
        NAMES="buster-tier1-vec buster-tier1 clang-O2 clang-O2-novec clang-O2-novec-nounroll"
        $LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; ./build-9700x.sh $MARCH" > $O/build.log 2>&1
        step "built kernels $MARCH"
        : > $O/results.txt
    fi
    for NAME in $NAMES; do
        $LOCK bash -c "for PAD in 0 16 32 48; do ./run-one.sh $MARCH $NAME \$PAD; done" >> $O/results.txt 2>> $O/run.log
        step "ran $MARCH $NAME"
    done
    if [ "$MARCH" != x86-64 ]; then
        $LOCK bash -c "./run-one.sh $MARCH buster-tier1-hand 0; ./run-one.sh $MARCH clang-O2-hand 0" >> $O/results.txt 2>> $O/run.log
        step "ran $MARCH hand"
    fi
done
mkdir -p out/cost
SQLITE=$R/corpus/sqlite/sqlite3.c
for MARCH in znver5 x86-64; do
    $LOCK ./compile-cost.sh $SQLITE sqlite3 11 $MARCH >> out/cost/results.txt 2>> out/cost/run.log
    step "cost $MARCH"
done
step done
echo done > $R/measure.done
