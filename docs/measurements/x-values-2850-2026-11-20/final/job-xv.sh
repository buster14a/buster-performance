#!/bin/bash
# job-xv.sh LABEL PATCH REVISION RUNS BASE: the entries' values on the window on the 9700X: a Release build (LABEL:
# PATCH on main REVISION, an experiment's build with a switch, BUSTER_TESTS_SKIP=1: the values off: no record's value's
# column, no list, loop or numbering, and no value compared), the piece before's executable (results/BASE: main
# REVISION as it is, built here if it is not there), and in each reading the first with the values on, off, the piece
# before's twice, then off, on: RUNS readings on sqlite3.c, Lua and musl, CPU 2, each run its own hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3; runs=$4; base=$5
./build-label.sh "$label" "$revision" "$patch" || exit 1
test -x "results/$base/compiler" || ./build-label.sh "$base" "$revision" || exit 1
specs=("$label rows-on1 0 --shadow --passes 0 --window-rows" "$label rows-off1 1 --shadow --passes 0 --window-rows" "$base $label-base1 0 --shadow --passes 0 --window-rows" "$base $label-base2 0 --shadow --passes 0 --window-rows" "$label rows-off2 1 --shadow --passes 0 --window-rows" "$label rows-on2 0 --shadow --passes 0 --window-rows")
./turns-env.sh "" "$runs" "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
