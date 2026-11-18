#!/bin/bash
# job-padbuilds.sh: c14 with a string of 1088 and of 64 bytes before the fixtures' texts (the read-only data after it
# moves by as much): the front with the window on sqlite3.c, two readings each, with m3 and c14 in the same turns.
cd "$(dirname "$0")"
revision=$(head -1 results/m3/revision.txt)
./build-label.sh p1088 "$revision" tests-pad1088-experiment.patch || exit 1
./build-label.sh p64 "$revision" tests-pad64-experiment.patch || exit 1
./turns.sh "-pads" 2 "sqlite3" "m3 window --shadow --passes 0 --front-window" "c14 window --shadow --passes 0 --front-window" "p1088 window --shadow --passes 0 --front-window" "p64 window --shadow --passes 0 --front-window" || exit 1
echo job finished
