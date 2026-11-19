#!/bin/bash
# job-upd-knob.sh LABEL PATCH BASE: ONE executable (LABEL: PATCH on the main revision BASE was built on; the update
# piece with an experiment's switch, BUSTER_TESTS_SKIP=1, which skips the loop's update's block by a branch and lists
# every update's expression, as before the piece) with the block on (0) and off (1), in an on, off, off, on order inside
# each reading: C on the window (--window-contexts), seven readings on sqlite3.c, Lua and musl, CPU 2, each run its own
# hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; base=$3
revision=$(head -1 results/$base/revision.txt)
./build-label.sh "$label" "$revision" "$patch" || exit 1
specs=("$label contexts-on1 0 --shadow --passes 0 --window-contexts" "$label contexts-off1 1 --shadow --passes 0 --window-contexts" "$label contexts-off2 1 --shadow --passes 0 --window-contexts" "$label contexts-on2 0 --shadow --passes 0 --window-contexts")
./turns-env.sh "" 7 "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
