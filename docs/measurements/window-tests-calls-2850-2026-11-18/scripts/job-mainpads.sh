#!/bin/bash
# job-mainpads.sh: main with a string of 3,008 and of 2,944 bytes before the fixtures' texts: the front with the window
# on the three corpora, two readings each, with m3 in the same turns.
cd "$(dirname "$0")"
revision=$(head -1 results/m3/revision.txt)
./build-label.sh m3p3008 "$revision" main-pad3008-experiment.patch || exit 1
./build-label.sh m3p2944 "$revision" main-pad2944-experiment.patch || exit 1
./turns.sh "-mainpads" 2 "sqlite3 lua musl" "m3 window --shadow --passes 0 --front-window" "m3p3008 window --shadow --passes 0 --front-window" "m3p2944 window --shadow --passes 0 --front-window" || exit 1
echo job finished
