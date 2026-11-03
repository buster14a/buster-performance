#!/usr/bin/env bash
# shifts.sh TREE...: each tree's build with main_unit_backend.c's code at six shifts over a page (build.sh shifts),
# BUSTER_DEBUG_INFO=0, one hold of the shared lock each; executables in shifts/TREE/, logs in logs-build/.
. ~/buster-fast-bench/1116-claude/common.sh
mkdir -p logs-build shifts
shifts="0 640 1344 2048 2752 3456"
for t in "$@"; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/$t main_unit_backend.c $shifts > ../logs-build/shifts-$t.log 2>&1; echo \"exit \$?\" >> ../logs-build/shifts-$t.log"
    echo "$t: $(grep -E 'later|exit' logs-build/shifts-$t.log | tr '\n' ' ')"
done
sha256sum shifts/*/compiler-* > shifts/sha256.txt
