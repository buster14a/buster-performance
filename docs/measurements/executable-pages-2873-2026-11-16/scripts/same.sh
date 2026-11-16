#!/bin/bash
# same.sh: the probe's own cost, each side on one copy of the executable (ab.sh's SAME), with the setting on (=1) and
# off (=0), so that the two sides' environments are of one size: the head's `full` on musl a unit a process (15 rounds)
# and an empty file's -fsyntax-only (31), and the first version's executable (keep/full-v1.compiler, its probe a query
# in the helper), 15 rounds on musl. Waits for last.sh; a hold of the lock each.
cd "$(dirname "$0")"
while pgrep -f "last.sh" > /dev/null; do sleep 5; done
log=series-same.log
: > "$log"
step() { local name=$1; shift; local start=$(date +%s); SAME=1 A_ENV=BUSTER_EXECUTABLE_HUGE_PAGES=1 B_ENV=BUSTER_EXECUTABLE_HUGE_PAGES=0 ./lock.sh timeout -k 10 900 "$@" > "results/$name.log" 2>&1; echo "$? $(( $(date +%s) - start ))s $name" >> "$log"; }
step same-musl ./ab.sh results/same-musl musl 15 "full=$PWD/full/build/compiler" "nolook=$PWD/full/build/compiler"
step same-syntax ./ab.sh results/same-syntax syntax 31 "full=$PWD/full/build/compiler" "nolook=$PWD/full/build/compiler"
step same-v1-musl ./ab.sh results/same-v1-musl musl 15 "v1=$PWD/keep/full-v1.compiler" "nolook=$PWD/keep/full-v1.compiler"
echo done >> "$log"
