#!/bin/bash
# job6.sh: job3 again on the main the second pull request opens on: main cc1c47d62 (with buster#2884, buster#2889,
# buster#2888, buster#2885 and buster#2887) as base6, and the same with the tests in the machine's
# own form as sorted as own6 (own6.patch).
#   1. At reader time, seven readings in turn on sqlite3.c and Lua, three on musl: T, C and X (base6 and own6), with the
#      census's code between T and C, and with the own form (own6).
#   2. The own form beside the census's code, with the default warnings and with every warning, and the own form after
#      C and X: one reading each.
#   3. The shadow's own sweeps after the pipeline, base6 against own6: three readings in turn.
#   4. #2850's kernels with the operators, base6 against own6: three readings in turn.
#   5. The census's own reports, base6 against own6, with both sets of warnings.
#   6. -c sqlite3.c as whole processes, base6 against own6, twice.
cd "$(dirname "$0")"
main=cc1c47d6273e679c9282fdb6fb533cc1ef42bcf3
./build-label.sh base6 $main || exit 1
./build-label.sh own6 $main own6.patch || exit 1
./turns.sh "" 7 "sqlite3 lua" "base6 sweeps --shadow --front-sweeps" "own6 sweeps --shadow --front-sweeps" "own6 tests --shadow --front-tests" "own6 own --shadow --front-own-tests" || exit 1
./turns.sh "" 3 "musl" "base6 sweeps --shadow --front-sweeps" "own6 sweeps --shadow --front-sweeps" "own6 tests --shadow --front-tests" "own6 own --shadow --front-own-tests" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "own6 own-verify --shadow --front-own-tests --verify --passes 1" "own6 own-verify-wall --shadow --front-own-tests --verify --passes 1 -Wall -Wextra" "own6 own-last --shadow --front-own-tests --front-tests-last" || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "base6 shadow --shadow" "own6 shadow --shadow" || exit 1
./turns.sh "" 3 "sqlite3 musl" "base6 facts-operators --shadow --facts --facts-operators" "own6 facts-operators --shadow --facts --facts-operators" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "base6 census" "base6 census-wall -Wall -Wextra" "own6 census" "own6 census-wall -Wall -Wextra" || exit 1
./compile.sh base6 own6 2 || exit 1
echo job6 finished
