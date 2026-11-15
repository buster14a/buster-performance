#!/usr/bin/env bash
# profile5.sh: with a5b52808d's Release build, perf record of `--tier1 -O2 -march=znver5 -c sqlite3.c` without and with
# --tier1-passes=+vectorize, three runs each at periods near 20,000 user instructions (varied per run, so that the
# deterministic compile's samples don't land on the same instructions), alternating, in one hold; each run reported by
# symbol in full. Results go to out/profile5. Writes progress.txt and profile5.done.
set -u
R=~/buster-fast-bench/2743-claude
cd $R/loops || exit 1
export EXCLUSIVE_OWNER=claude-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 loop vectorizer"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2804
LOCK=~/buster-fast-bench/exclusive.sh
SQLITE=$R/corpus/sqlite/sqlite3.c
BUSTER=$R/tree/build/compiler
step() { echo "$(date -u +%FT%TZ) $*" >> $R/progress.txt; }
rm -f $R/profile5.done
mkdir -p out/profile5
step "profile5 start $(git -C $R/tree rev-parse HEAD) $(sha256sum $BUSTER | cut -c1-16)"
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt
for run in 1 2 3; do
    for variant in base vectorize; do
        extra=''
        [ \$variant = vectorize ] && extra=--tier1-passes=+vectorize
        period=\$((20011 + run * 10))
        taskset -c 2 perf record -q -e instructions:u -c \$period -o out/profile5/\$variant-\$run.data -- $BUSTER --tier1 \$extra -O2 -march=znver5 -c $SQLITE -o /dev/shm/claude-2743-\$variant.o > /dev/null 2>&1
        echo \"\$variant \$run period \$period status \$?\"
    done
done
for f in out/profile5/*.data; do
    perf report -q -i \$f --stdio --no-children --sort sym --percent-limit 0.01 2> /dev/null > \${f%.data}-symbols.txt
    rm -f \$f
done" > out/profile5/run.log 2>&1
rm -f /dev/shm/claude-2743-base.o /dev/shm/claude-2743-vectorize.o
touch $R/profile5.done
step "profile5 done"
