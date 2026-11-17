#!/bin/bash
# job.sh: buster#2890 (C and X write a condition's `&&`, `||` and `!` as the lowering's branches) on main 178c9e2 with
# buster#2894's two commits, which is `base` (flat.patch, the build of that pull request's record); `cond` is the same
# with #2890 (cond.patch against main 178c9e2).
#   1. The shadow's own sweeps after the pipeline, base against cond: three readings in turn a corpus; the machine's
#      counts are in the same files.
#   2. T, C and X at reader time with the lean front, base against cond: three readings in turn.
#   3. The one sweep beside the two (--fused), cond: one reading a corpus.
#   4. The census's own reports, cond's against base's, with both sets of warnings.
#   5. -c sqlite3.c as whole processes, base against cond, twice.
cd "$(dirname "$0")"
main=178c9e2606fb086025126d6f2521098342c75773
./build-label.sh base $main flat.patch || exit 1
./build-label.sh cond $main cond.patch || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "base shadow --shadow" "cond shadow --shadow" || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "base sweeps-lean --shadow --passes 0 --front-sweeps --front-lean" "cond sweeps-lean --shadow --passes 0 --front-sweeps --front-lean" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "cond fused --shadow --fused --passes 1" "base census" "base census-wall -Wall -Wextra" "cond census" "cond census-wall -Wall -Wextra" || exit 1
./compile.sh base cond 2 || exit 1
echo job finished
