#!/bin/bash
# job4.sh: the front by passes (the hand-off's 0004) on main 1c6cc8ab5 with buster#2887's sources and the tests in the
# machine's own form as sorted, built as flat (flat.patch); own is that tree without 0004, job3's build.
#   1. The fronts before the walk and after it, seven readings in turn on sqlite3.c and Lua, three on musl: the flat
#      front before the walk (--front-flat-first), the lean front before the walk (--front-first --front-lean), and the
#      flat front after the walk beside the lean one (--front-flat). Every run compares the two fronts.
#   2. The shadow's own sweeps after the pipeline, own against flat: three readings in turn.
#   3. The census's own reports, flat's against own's (job3's), with both sets of warnings.
#   4. -c sqlite3.c as whole processes, own against flat, twice.
cd "$(dirname "$0")"
main=1c6cc8ab5e778ab32078cbef17049c4814b30dca
./build-label.sh flat $main flat.patch || exit 1
./turns.sh "" 7 "sqlite3 lua" "flat flatfirst --shadow --passes 0 --front-flat-first" "flat leanfirst --shadow --passes 0 --front-first --front-lean" "flat flat --shadow --passes 0 --front-flat" || exit 1
./turns.sh "" 3 "musl" "flat flatfirst --shadow --passes 0 --front-flat-first" "flat leanfirst --shadow --passes 0 --front-first --front-lean" "flat flat --shadow --passes 0 --front-flat" || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "own shadow4 --shadow" "flat shadow --shadow" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "flat census" "flat census-wall -Wall -Wextra" || exit 1
./compile.sh own flat 2 || exit 1
echo job4 finished
