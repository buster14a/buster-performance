#!/bin/bash
# job-contexts.sh HEAD PATCH BASE: C on the window's first piece (the build HEAD: PATCH on the main revision BASE was
# built on) against the build BASE, in turn in each reading, CPU 2, each run its own hold of the lock.
#   1. C on the window (--window-contexts), the tests on the window in the same executable (--window-tests) and BASE's:
#      seven readings on sqlite3.c and Lua, fifteen on musl.
#   2. The window without the tests (--front-window), HEAD and BASE: seven readings.
#   3. -c sqlite3.c as whole processes, twice (compile.sh).
cd "$(dirname "$0")"
head=$1; patch=$2; base=$3
revision=$(head -1 results/$base/revision.txt)
./build-label.sh "$head" "$revision" "$patch" || exit 1
./turns.sh "" 7 "sqlite3 lua" "$base vs-$head --shadow --passes 0 --window-tests" "$head window-tests --shadow --passes 0 --window-tests" "$head window-contexts --shadow --passes 0 --window-contexts" || exit 1
./turns.sh "" 15 "musl" "$base vs-$head --shadow --passes 0 --window-tests" "$head window-tests --shadow --passes 0 --window-tests" "$head window-contexts --shadow --passes 0 --window-contexts" || exit 1
./turns.sh "" 7 "sqlite3 lua musl" "$base vs-$head-window --shadow --passes 0 --front-window" "$head window --shadow --passes 0 --front-window" || exit 1
./compile.sh "$base" "$head" 2 || exit 1
echo job finished
