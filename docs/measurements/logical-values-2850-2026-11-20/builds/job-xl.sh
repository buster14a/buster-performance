#!/bin/bash
# job-xl.sh LABEL PATCH REVISION RUNS BASE SUFFIX: an operator's value and a comma on the window on the 9700X: a Release
# build (LABEL: PATCH on REVISION, the piece before's pull request's head), the piece before's executable
# (results/BASE: REVISION as it is, built here if it is not there), and in each reading the build, the piece before's
# twice, then the build again: RUNS readings on sqlite3.c, Lua and musl, CPU 2, each run its own hold of the lock.
# The readings' files have SUFFIX in their names: a later job's don't write over them.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3; runs=$4; base=$5; suffix=$6
./build-label.sh "$label" "$revision" "$patch" || exit 1
test -x "results/$base/compiler" || ./build-label.sh "$base" "$revision" || exit 1
options="--shadow --passes 0 --window-rows"
specs=("$label rows-on1 $options" "$base $label-base1 $options" "$base $label-base2 $options" "$label rows-on2 $options")
./turns.sh "$suffix" "$runs" "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
