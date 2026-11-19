#!/bin/bash
# job-gat.sh HEAD PATCH BASE: an experiment's build HEAD (PATCH on the revision BASE was built on) against the build
# BASE, in turn in each reading, CPU 2, each run its own hold of the lock: the tests on the window alone
# (--window-tests) and C on the window (--window-contexts), seven readings on sqlite3.c, Lua and musl.
cd "$(dirname "$0")"
head=$1; patch=$2; base=$3
revision=$(head -1 results/$base/revision.txt)
./build-label.sh "$head" "$revision" "$patch" || exit 1
specs=("$base vs-$head --shadow --passes 0 --window-tests" "$head window-tests --shadow --passes 0 --window-tests" "$base contexts-vs-$head --shadow --passes 0 --window-contexts" "$head window-contexts --shadow --passes 0 --window-contexts")
./turns.sh "" 7 "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
