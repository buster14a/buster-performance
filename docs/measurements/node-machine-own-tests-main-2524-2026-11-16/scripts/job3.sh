#!/bin/bash
# job3.sh: the tests in the machine's own form (the hand-off's 0003 with the fixture lines it owed and its conditions
# sorted) on main 1c6cc8ab5 with pull request buster#2887's sources, built as own (own.patch). head2 is that pull
# request's head, job2's build.
#   1. At reader time, seven readings in turn on sqlite3.c and Lua, three on musl: T, C and X (head2 and own), with the
#      census's code between T and C, and with the own form (own).
#   2. The own form beside the census's code, with the default warnings and with every warning, and the own form after
#      C and X: one reading each.
#   3. The shadow's own sweeps after the pipeline, head2 against own: three readings in turn.
#   4. #2850's kernels with the operators, head2 against own: three readings in turn.
#   5. The census's own reports, own's against head2's (job2's), with both sets of warnings.
#   6. -c sqlite3.c as whole processes, head2 against own, twice.
cd "$(dirname "$0")"
main=1c6cc8ab5e778ab32078cbef17049c4814b30dca
./build-label.sh own $main own.patch || exit 1
./turns.sh "" 7 "sqlite3 lua" "head2 sweeps3 --shadow --front-sweeps" "own sweeps --shadow --front-sweeps" "own tests --shadow --front-tests" "own own --shadow --front-own-tests" || exit 1
./turns.sh "" 3 "musl" "head2 sweeps3 --shadow --front-sweeps" "own sweeps --shadow --front-sweeps" "own tests --shadow --front-tests" "own own --shadow --front-own-tests" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "own own-verify --shadow --front-own-tests --verify --passes 1" "own own-verify-wall --shadow --front-own-tests --verify --passes 1 -Wall -Wextra" "own own-last --shadow --front-own-tests --front-tests-last" || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "head2 shadow3 --shadow" "own shadow --shadow" || exit 1
./turns.sh "" 3 "sqlite3 musl" "head2 facts-operators3 --shadow --facts --facts-operators" "own facts-operators --shadow --facts --facts-operators" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "own census" "own census-wall -Wall -Wextra" || exit 1
./compile.sh head2 own 2 || exit 1
echo job3 finished
