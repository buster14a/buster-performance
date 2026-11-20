#!/bin/bash
# job-xr.sh LABEL PATCH REVISION RUNS: X's rows on the window on the 9700X: a Release build (LABEL: PATCH on main
# REVISION), and ONE executable with the rows on (--window-rows) and off (--window-contexts), in an on, off, off, on
# order inside each reading: RUNS readings on sqlite3.c, Lua and musl, CPU 2, each run its own hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3; runs=$4
./build-label.sh "$label" "$revision" "$patch" || exit 1
specs=("$label rows-on1 0 --shadow --passes 0 --window-rows" "$label rows-off1 0 --shadow --passes 0 --window-contexts" "$label rows-off2 0 --shadow --passes 0 --window-contexts" "$label rows-on2 0 --shadow --passes 0 --window-rows")
./turns-env.sh "" "$runs" "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
