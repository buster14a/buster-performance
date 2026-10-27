#!/bin/bash
# Where the jump tables' cost lands, on the switched executable (one placement): perf record of cycles:u at a fixed
# period, five -c runs of sqlite3.c per mode, each mode its own hold of the lock, pinned to CPU 2; then each mode's
# samples by symbol.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
D=$B/jump-136-toggle
quiet() { grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:"; }
cd $D || exit 1
for mode in off on; do
    if [ $mode = off ]; then e="env BUSTER_NO_JUMP_TABLES=1"; else e="env -u BUSTER_NO_JUMP_TABLES"; fi
    $X taskset -c 2 $e perf record -q -e cycles:u -c 100003 -o $D/profile-$mode.data -- bash -c '
        for i in 1 2 3 4 5; do ./build/compiler -c -I'"$B"'/preprocessor-corpora-astra-01a158dd/sqlite -o '"$D"'/profile-'"$mode"'.o '"$B"'/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c || exit 1; done' 2>&1 | quiet
    echo "== $mode: $?"
    perf report -i $D/profile-$mode.data --stdio -q -n --sort dso,sym --percent-limit 0 2> /dev/null | grep -v "^$" > $D/profile-$mode.txt
    head -3 $D/profile-$mode.txt
done
echo done
