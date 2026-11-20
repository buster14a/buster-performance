#!/bin/bash
# job-xb.sh LABEL PATCH REVISION RUNS: the branches' rows on the window on the 9700X: a Release build (LABEL: PATCH on
# main REVISION, an experiment's build with a switch, BUSTER_TESTS_SKIP=1: the branches' rows off, their template the
# mark that lists its expression), and in each reading that executable with the branches' rows on, off, the piece
# before's executable (results/xu8, its update's rows on) twice, then off, on: RUNS readings on sqlite3.c, Lua and
# musl, CPU 2, each run its own hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3; runs=$4
./build-label.sh "$label" "$revision" "$patch" || exit 1
specs=("$label rows-on1 0 --shadow --passes 0 --window-rows" "$label rows-off1 1 --shadow --passes 0 --window-rows" "xu8 $label-base1 0 --shadow --passes 0 --window-rows" "xu8 $label-base2 0 --shadow --passes 0 --window-rows" "$label rows-off2 1 --shadow --passes 0 --window-rows" "$label rows-on2 0 --shadow --passes 0 --window-rows")
./turns-env.sh "" "$runs" "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
