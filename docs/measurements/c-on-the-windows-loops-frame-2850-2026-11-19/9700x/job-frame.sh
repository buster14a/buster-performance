#!/bin/bash
# job-frame.sh LABEL...: an experiment's build of C on the window's loop with the counters (contexts-LABEL.patch on the
# revision upd4 was built on), then three runs on sqlite3.c and Lua, CPU 2, each its own hold of the lock.
cd "$(dirname "$0")"
revision=$(head -1 results/upd4/revision.txt)
. ./corpora.sh
for label in "$@"; do
    ./build-label.sh "$label" "$revision" "contexts-$label.patch" || continue
    for n in 1 2 3; do
        for c in sqlite3 lua; do
            case $c in
                sqlite3) arguments=$sqlite_arguments ;;
                lua) arguments=$lua_arguments ;;
            esac
            f=$PWD/results/$label/counters-piece-$c-$n.txt
            ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; taskset -c 2 $PWD/results/$label/compiler measure-node-machine --shadow --passes 0 --window-contexts $arguments; echo status \$?" > "$f" 2>&1
        done
    done
done
echo job finished
