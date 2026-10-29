#!/bin/bash
# #147's transparent unions PR, its second head (73c572d3), against main 9bb5060e over the checker unit's placements and
# fresh copies (#509's method): -c of the frozen sqlite3.c, pinned to CPU 2, ab taking the lock for each time-runs
# process; main's executables again as an A/A control. Main's placements are the first campaign's (../pr3/shifts/base,
# built by shifts3.sh from the same commit). Before them a drive check: the head's object against main's.
export EXCLUSIVE_OWNER=claude-solve-147 EXCLUSIVE_TITLE="solve 147 (transparent unions)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/147"
unset CPATH C_INCLUDE_PATH
B=~/buster-fast-bench
P=$B/solve147-claude/pr3
D=$B/solve147-claude/pr3b
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
shifts="0 688 1376 2064 2752 3440"
(cd $D/head && BUSTER_DEBUG_INFO=0 $B/exclusive.sh ./build.sh shifts $D/shifts/head main_unit_checker.c $shifts > $D/shifts-head.log 2>&1) || { echo "shifts head failed"; exit 1; }
echo "shifted head"
$B/exclusive.sh taskset -c 2 $D/shifts/head/compiler-0 -c -I$Q -o $D/drive-head.o $Q/sqlite3.c > $D/drive-head.log 2>&1
echo "drive head status $?"
cmp $P/drive-base.o $D/drive-head.o && echo "objects identical"
builds=()
for b in base:$P/shifts/base head:$D/shifts/head base-again:$P/shifts/base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "${b#*:}/compiler-$s"); done
done
mkdir -p $D/copies
$D/head/build/compiler ab --rounds 3 --cpu 2 --lock $B/exclusive.sh $D/head/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory $D/copies "${builds[@]}" --list -c -I$Q -o $D/shifts-out.o $Q/sqlite3.c > $D/shifts-ab.log 2>&1
echo "ab status $?"
grep -E "^  (head|base-again): " $D/shifts-ab.log
echo done
