#!/bin/bash
# job-xu.sh LABEL PATCH REVISION RUNS: an update's rows on the window on the 9700X: a Release build (LABEL: PATCH on
# main REVISION, an experiment's build with a switch, BUSTER_TESTS_SKIP=1: the update's rows off, its template the
# mark that lists its expression), and in each reading that executable with the update's rows on, off, the piece
# before's executable (results/xr10) twice, then off, on: RUNS readings on sqlite3.c, Lua and musl, CPU 2, each run its
# own hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3; runs=$4
./build-label.sh "$label" "$revision" "$patch" || exit 1
specs=("$label rows-on1 0 --shadow --passes 0 --window-rows" "$label rows-off1 1 --shadow --passes 0 --window-rows" "xr10 $label-base1 0 --shadow --passes 0 --window-rows" "xr10 $label-base2 0 --shadow --passes 0 --window-rows" "$label rows-off2 1 --shadow --passes 0 --window-rows" "$label rows-on2 0 --shadow --passes 0 --window-rows")
./turns-env.sh "" "$runs" "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
