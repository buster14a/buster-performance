#!/bin/bash
# job-xh.sh BEFORE AFTER PATCH REVISION RUNS SUFFIX: the tests' holes and the objects' side on the 9700X: two Release
# builds (BEFORE: REVISION as it is, main with the piece before; AFTER: PATCH on it), and in each reading the build
# before, the build after twice, then the build before again: RUNS readings on sqlite3.c, Lua and musl, CPU 2, each
# run its own hold of the lock. The readings' files have SUFFIX in their names: a later job's don't write over them.
cd "$(dirname "$0")"
before=$1; after=$2; patch=$3; revision=$4; runs=$5; suffix=$6
test -x "results/$before/compiler" || ./build-label.sh "$before" "$revision" || exit 1
test -x "results/$after/compiler" || ./build-label.sh "$after" "$revision" "$patch" || exit 1
options="--shadow --passes 0 --window-rows"
specs=("$before before1 $options" "$after after1 $options" "$after after2 $options" "$before before2 $options")
./turns.sh "$suffix" "$runs" "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
