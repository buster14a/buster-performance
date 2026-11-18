#!/bin/bash
# job-window.sh HEAD PATCH BASE OTHER: the build HEAD (PATCH on BASE's main revision) built, then the window without the
# tests (--front-window) read five times, BASE, OTHER and HEAD in turn: the kernel's, the front's and the names' pass's
# ticks.
cd "$(dirname "$0")"
head=$1; patch=$2; base=$3; other=$4
revision=$(head -1 results/$base/revision.txt)
./build-label.sh "$head" "$revision" "$patch" || exit 1
./turns.sh "" 5 "sqlite3 lua musl" "$base vs-$head-window --shadow --passes 0 --front-window" "$other with-$head-window --shadow --passes 0 --front-window" "$head window --shadow --passes 0 --front-window" || exit 1
echo job finished
