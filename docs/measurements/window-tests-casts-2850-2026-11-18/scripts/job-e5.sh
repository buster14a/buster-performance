#!/bin/bash
# job-e5.sh: what listing an initialization for its root costs, before the fifth piece's specification: one executable
# (e5: the fourth piece with a switch, --census-roots-unlisted, that lists no initialization for its root), its two
# settings in turn from one copy a reading. The unlisted setting's verdicts differ where a root's test fires.
cd "$(dirname "$0")"
./build-label.sh e5 cc9c84a54c47183515badf07aafb65e5974a82d3 tests-e5-on-cc9c84a5.patch || exit 1
./turns.sh "" 7 "sqlite3 lua" "e5 roots-listed --shadow --passes 0 --window-tests" "e5 roots-unlisted --shadow --passes 0 --window-tests --census-roots-unlisted" || exit 1
./turns.sh "" 15 "musl" "e5 roots-listed --shadow --passes 0 --window-tests" "e5 roots-unlisted --shadow --passes 0 --window-tests --census-roots-unlisted" || exit 1
echo job finished
