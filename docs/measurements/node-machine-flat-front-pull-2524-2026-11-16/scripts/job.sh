#!/bin/bash
# job.sh: the front by passes (the hand-off's 0004 with the comparison's fix) on main 178c9e2, built as flat
# (flat.patch); base is that main.
#   1. The fronts before the walk and after it, seven readings in turn on sqlite3.c and Lua, three on musl: the flat
#      front before the walk (--front-flat-first), the lean front before the walk (--front-first --front-lean), and the
#      flat front after the walk beside the lean one (--front-flat). Every run compares the two fronts.
#   2. The shadow's own sweeps after the pipeline, base against flat: three readings in turn.
#   3. The census's own reports, flat's against base's, with both sets of warnings.
#   4. -c sqlite3.c as whole processes, base against flat, twice.
cd "$(dirname "$0")"
main=178c9e2606fb086025126d6f2521098342c75773
./build-label.sh base $main || exit 1
./build-label.sh flat $main flat.patch || exit 1
./turns.sh "" 7 "sqlite3 lua" "flat flatfirst --shadow --passes 0 --front-flat-first" "flat leanfirst --shadow --passes 0 --front-first --front-lean" "flat flat --shadow --passes 0 --front-flat" || exit 1
./turns.sh "" 3 "musl" "flat flatfirst --shadow --passes 0 --front-flat-first" "flat leanfirst --shadow --passes 0 --front-first --front-lean" "flat flat --shadow --passes 0 --front-flat" || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "base shadow --shadow" "flat shadow --shadow" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "base census" "base census-wall -Wall -Wextra" "flat census" "flat census-wall -Wall -Wextra" || exit 1
./compile.sh base flat 2 || exit 1
echo job finished
