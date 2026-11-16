#!/bin/bash
# extra.sh: the probe's own cost with more rounds (the same executable with BUSTER_EXECUTABLE_HUGE_PAGES=0, which leaves
# the helper as it was: musl a unit a process, 15 rounds; an empty file's -fsyntax-only, 31), the peak resident set
# of an empty file's -c by main and by full, 11 rounds from fresh copies after warm-ups, and, where keep/ has the first
# version's executable (its probe in the helper: raw/v1), that one against full on musl's units, 9 rounds. A hold of the
# lock each.
cd "$(dirname "$0")"
log=series-extra.log
: > "$log"
step() { local name=$1; shift; local start=$(date +%s); ./lock.sh timeout -k 10 900 "$@" > "results/$name.log" 2>&1; echo "$? $(( $(date +%s) - start ))s $name" >> "$log"; }
B_ENV=BUSTER_EXECUTABLE_HUGE_PAGES=0 step probe-musl ./ab.sh results/probe-musl musl 15 "full=$PWD/full/build/compiler" "nolook=$PWD/full/build/compiler"
B_ENV=BUSTER_EXECUTABLE_HUGE_PAGES=0 step probe-syntax ./ab.sh results/probe-syntax syntax 31 "full=$PWD/full/build/compiler" "nolook=$PWD/full/build/compiler"
step peak-empty ./peak-empty.sh results/peak-empty 11 "main=$PWD/main/build/compiler" "full=$PWD/full/build/compiler"
[ -e keep/full-v1.compiler ] && step v1-musl ./ab.sh results/v1-musl musl 9 "v1=$PWD/keep/full-v1.compiler" "full=$PWD/full/build/compiler"
echo done >> "$log"
