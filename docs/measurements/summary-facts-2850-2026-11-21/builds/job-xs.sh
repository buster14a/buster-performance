#!/bin/bash
# job-xs.sh LABEL PATCH REVISION RUNS SUFFIX: a summary node's side facts on the window on the 9700X: a Release build
# (LABEL: PATCH on REVISION, the piece before's pull request's head), and in each reading the build with the facts, the
# same executable without them twice (--no-window-summaries, the shadow's switch), then with them again: RUNS readings
# on sqlite3.c, Lua and musl, CPU 2, each run its own hold of the lock. The readings' files have SUFFIX in their names:
# a later job's don't write over them.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3; runs=$4; suffix=$5
test -x "results/$label/compiler" || ./build-label.sh "$label" "$revision" "$patch" || exit 1
options="--shadow --passes 0 --window-rows"
specs=("$label on1 $options" "$label off1 $options --no-window-summaries" "$label off2 $options --no-window-summaries" "$label on2 $options")
./turns.sh "$suffix" "$runs" "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
