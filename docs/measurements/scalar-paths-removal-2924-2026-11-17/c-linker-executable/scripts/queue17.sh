#!/bin/sh
# Piece 3 (the executable) at its head p3: Release build, then the nine correctness blocks naming its tests.
cd ~/buster-fast-bench/2924-linker
./run.sh p3-build sh -c "cd hexe && ./build.sh --config Release"
grep -q "^exit 0" p3-build.log || exit 1
./run.sh p3-tests sh -c "cd hexe && BUSTER_COMPILER=\$PWD/build/compiler taskset -c 0-7 ./build/compiler parallel --jobs 8 --timeout 500 < ../p3.tests"
