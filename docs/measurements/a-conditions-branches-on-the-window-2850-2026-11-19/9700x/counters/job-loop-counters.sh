#!/bin/bash
# job-loop-counters.sh: an experiment's counters around C on the window's loop (counters-edit.py: user instructions,
# cycles, loads and stores dispatched, each of the loop's two runs of a chunk and around nothing) in three builds: the
# build before the branches piece (upd4c), the piece's (br2c) and the piece's with its switch (br2xc, the block on and
# off). Three runs each on sqlite3.c, Lua and musl, in turn, CPU 2, each its own hold of the lock.
cd "$(dirname "$0")"
revision=$(head -1 results/upd4/revision.txt)
for label in upd4c br2c br2xc; do
    ./build-label.sh "$label" "$revision" "contexts-$label.patch" || exit 1
done
. ./corpora.sh
for n in 1 2 3; do
    for c in sqlite3 lua musl; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
            musl) arguments=$musl_arguments ;;
        esac
        for spec in "upd4c 0 before" "br2c 0 piece" "br2xc 1 off" "br2xc 0 on"; do
            read -r label skip tag <<< "$spec"
            f=$PWD/results/$label/counters-$tag-$c-$n.txt
            ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; BUSTER_TESTS_SKIP=$skip taskset -c 2 $PWD/results/$label/compiler measure-node-machine --shadow --passes 0 --window-contexts $arguments; echo status \$?" > "$f" 2>&1
        done
    done
done
echo job finished
