#!/bin/bash
# named.sh: the two builds #2872 names (w2, z3: main be6515fba with their records patches) with the two passes line, built
# and run on musl (the fact words kernel whole, a body a window), three runs each, the builds in turn
cd "$(dirname "$0")"
./build-label.sh w2t be6515fba w2t.patch || exit 1
./build-label.sh z3t be6515fba z3t.patch || exit 1
for n in 1 2 3; do
    ./passes.sh w2t -whole-$n 1 musl || exit 1
    ./passes.sh z3t -whole-$n 1 musl || exit 1
done
echo named finished
