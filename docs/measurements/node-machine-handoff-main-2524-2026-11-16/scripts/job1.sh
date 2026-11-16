#!/bin/bash
# job1.sh: main 1c6cc8ab5 as it is (main) and with the branch's src, tools and tests (head.patch: #2882's fix and the
# hand-off's 0001 and 0002, C and X and the tests at reader time).
#   1. At reader time: T alone (main and head), T, C and X, and with the tests between T and C (head): seven readings in
#      turn on sqlite3.c and Lua, three on musl. Counts, differences and ticks.
#   2. The tests with every warning on, and the rows and rules against the action at reader time: one reading each.
#   3. The shadow's own sweeps after the pipeline, main against head: three readings in turn.
#   4. #2850's kernels, main against head: the fact words whole and with the operators, three readings in turn.
#   5. The census's own reports, main against head, with the default warnings and with every warning.
#   6. -c sqlite3.c as whole processes, main against head, twice.
cd "$(dirname "$0")"
main=1c6cc8ab5e778ab32078cbef17049c4814b30dca
./build-label.sh main $main || exit 1
./build-label.sh head $main head.patch || exit 1
./turns.sh "" 7 "sqlite3 lua" "main types --shadow --front-types" "head types --shadow --front-types" "head sweeps --shadow --front-sweeps" "head tests --shadow --front-tests" || exit 1
./turns.sh "" 3 "musl" "main types --shadow --front-types" "head types --shadow --front-types" "head sweeps --shadow --front-sweeps" "head tests --shadow --front-tests" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "head tests-wall --shadow --front-tests -Wall -Wextra" "head verify --shadow --verify --front-tests --passes 1" || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "main shadow --shadow" "head shadow --shadow" || exit 1
./turns.sh "" 3 "sqlite3 musl" "main facts --shadow --facts" "head facts --shadow --facts" "main facts-operators --shadow --facts --facts-operators" "head facts-operators --shadow --facts --facts-operators" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "main census" "head census" "main census-wall -Wall -Wextra" "head census-wall -Wall -Wextra" || exit 1
./compile.sh main head 2 || exit 1
echo job1 finished
