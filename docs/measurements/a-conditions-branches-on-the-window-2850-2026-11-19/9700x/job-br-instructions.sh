#!/bin/bash
# job-br-instructions.sh: user instructions and cycles of whole runs of C on the window (--window-contexts) on
# sqlite3.c and Lua, for the build before (upd4), the piece's build (br1) and the switch's executable with its block
# off and on (br1x, BUSTER_TESTS_SKIP=1 and 0): whether the executable with the block off retires more instructions
# than the build before, which runs the same loop's work. Five runs each, in turn, CPU 2, each its own hold of the lock.
cd "$(dirname "$0")"
. ./corpora.sh
out=$PWD/results/br1x
for n in 1 2 3 4 5; do
    for c in sqlite3 lua; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
        esac
        for spec in "upd4 0 before" "br1 0 piece" "br1x 1 off" "br1x 0 on"; do
            read -r label skip tag <<< "$spec"
            f=$out/instructions-$tag-$c-$n.txt
            ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; BUSTER_TESTS_SKIP=$skip perf stat -x, -e instructions:u,cycles:u,branches:u,branch-misses:u -o $f.perf taskset -c 2 $PWD/results/$label/compiler measure-node-machine --shadow --passes 0 --window-contexts $arguments; echo status \$?" > "$f" 2>&1
        done
    done
done
echo job finished
