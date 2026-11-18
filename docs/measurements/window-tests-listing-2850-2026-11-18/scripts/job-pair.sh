#!/bin/bash
# job-pair.sh HEAD PATCH BASE: the build HEAD (PATCH on the main revision BASE was built on) against the build BASE, the
# two in turn in each reading, CPU 2, each run its own hold of the lock.
#   1. The window's tests: seven readings on sqlite3.c and Lua, fifteen on musl.
#   2. With every warning: five and fifteen.
#   3. Beside --verify: one reading of HEAD.
#   4. The window without the tests (--front-window): three readings.
#   5. -c sqlite3.c as whole processes, twice (compile.sh).
cd "$(dirname "$0")"
head=$1; patch=$2; base=$3
revision=$(head -1 results/$base/revision.txt)
./build-label.sh "$head" "$revision" "$patch" || exit 1
./turns.sh "" 7 "sqlite3 lua" "$base vs-$head --shadow --passes 0 --window-tests" "$head window-tests --shadow --passes 0 --window-tests" || exit 1
./turns.sh "" 15 "musl" "$base vs-$head --shadow --passes 0 --window-tests" "$head window-tests --shadow --passes 0 --window-tests" || exit 1
./turns.sh "" 5 "sqlite3 lua" "$base vs-$head-wall --shadow --passes 0 --window-tests -Wall -Wextra" "$head window-tests-wall --shadow --passes 0 --window-tests -Wall -Wextra" || exit 1
./turns.sh "" 15 "musl" "$base vs-$head-wall --shadow --passes 0 --window-tests -Wall -Wextra" "$head window-tests-wall --shadow --passes 0 --window-tests -Wall -Wextra" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "$head window-tests-verify --shadow --passes 0 --window-tests --verify" || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "$base vs-$head-window --shadow --passes 0 --front-window" "$head window --shadow --passes 0 --front-window" || exit 1
./compile.sh "$base" "$head" 2 || exit 1
echo job finished
