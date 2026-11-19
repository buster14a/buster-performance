#!/bin/bash
# job-null-knob.sh LABEL PATCH BASE: ONE executable (LABEL: PATCH on the main revision BASE was built on; the null
# piece with an experiment's switch, BUSTER_TESTS_SKIP, whose bits turn the piece's terms off: 1 the tests' own form's
# asks, 2 the sweep's said values' mask, 4 the kernel's) with the terms on (0) and off (7), in an on, off, off, on
# order inside each reading: the tests on the window alone (--window-tests) and C on the window (--window-contexts),
# seven readings on sqlite3.c, Lua and musl, CPU 2, each run its own hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; base=$3
revision=$(head -1 results/$base/revision.txt)
./build-label.sh "$label" "$revision" "$patch" || exit 1
specs=("$label tests-on1 0 --shadow --passes 0 --window-tests" "$label tests-off1 7 --shadow --passes 0 --window-tests" "$label tests-off2 7 --shadow --passes 0 --window-tests" "$label tests-on2 0 --shadow --passes 0 --window-tests"
       "$label contexts-on1 0 --shadow --passes 0 --window-contexts" "$label contexts-off1 7 --shadow --passes 0 --window-contexts" "$label contexts-off2 7 --shadow --passes 0 --window-contexts" "$label contexts-on2 0 --shadow --passes 0 --window-contexts")
./turns-env.sh "" 7 "sqlite3 lua musl" "${specs[@]}" || exit 1
echo job finished
