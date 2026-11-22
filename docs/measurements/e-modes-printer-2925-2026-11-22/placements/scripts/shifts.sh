#!/bin/bash
# Each tree's Release executable linked at six placements of the -E unit's code (main_unit_frontend.c), each build
# under the 9700X's lock alone (#2925's placement controls, docs/profiling.md's "Builds over their code's placements").
set -u
D=~/buster-fast-bench/1380-claude-2925
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
shifts=${SHIFTS:-"0 704 1408 2112 2816 3520"}
for t in ${TREES:-base head}; do
    echo "== shifts $t $(git -C $D/$t rev-parse HEAD) $(date -u +%FT%TZ)"
    mkdir -p $D/shifts/$t
    (cd $D/$t && ~/buster-fast-bench/exclusive.sh ./build.sh shifts $D/shifts/$t main_unit_frontend.c $shifts > $D/shifts-$t.log 2>&1)
    echo "shifts $t exit $? $(date -u +%FT%TZ)"
done
echo "shifts done"
