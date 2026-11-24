#!/bin/sh
# Piece 2 (bind) at its head p2: Release build, then the five correctness blocks naming its tests.
cd ~/buster-fast-bench/2924-linker
./run.sh p2-build sh -c "cd hbind && ./build.sh --config Release"
grep -q "^exit 0" p2-build.log || exit 1
./run.sh p2-tests sh -c "cd hbind && BUSTER_COMPILER=\$PWD/build/compiler taskset -c 0-7 ./build/compiler parallel --jobs 8 --timeout 500 < ../p2.tests"
