#!/bin/bash
# Release builds of each tree, linked at six placements of link-foreign's unit's code (main_unit_executable.c), each
# tree's build under the 9700X's lock alone (#3261's placement controls, docs/profiling.md).
set -u
D=~/buster-fast-bench/3044-claude
export EXCLUSIVE_OWNER=claude-3261 EXCLUSIVE_TITLE='PR sweep: #3261 foreign strings cost' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3261
shifts=${SHIFTS:-"0 704 1408 2112 2816 3520"}
for t in "$@"; do
    echo "== shifts $t $(git -C $D/$t rev-parse HEAD) $(date -u +%FT%TZ)"
    mkdir -p $D/${SDIR:-shifts}/$t
    (cd $D/$t && ~/buster-fast-bench/exclusive.sh ./build.sh shifts $D/${SDIR:-shifts}/$t main_unit_executable.c $shifts > $D/${SDIR:-shifts}-$t.log 2>&1)
    echo "shifts $t exit $? $(date -u +%FT%TZ)"
done
echo "shifts done"
