#!/bin/bash
# job-call.sh HEAD PATCH BASE [READINGS]: the call piece's build HEAD (PATCH on the main revision BASE was built on)
# against the build BASE, each with C on the window (--window-contexts), in turn in each reading, CPU 2, each run its
# own hold of the lock: READINGS on sqlite3.c and Lua (7), twice as many and one on musl.
cd "$(dirname "$0")"
head=$1; patch=$2; base=$3; readings=${4:-7}
revision=$(head -1 results/$base/revision.txt)
./build-label.sh "$head" "$revision" "$patch" || exit 1
./turns.sh "" "$readings" "sqlite3 lua" "$base contexts-vs-$head --shadow --passes 0 --window-contexts" "$head window-contexts --shadow --passes 0 --window-contexts" || exit 1
./turns.sh "" "$((2 * readings + 1))" "musl" "$base contexts-vs-$head --shadow --passes 0 --window-contexts" "$head window-contexts --shadow --passes 0 --window-contexts" || exit 1
echo job finished
