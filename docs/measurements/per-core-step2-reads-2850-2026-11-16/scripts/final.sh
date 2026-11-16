#!/bin/bash
# final.sh: main 3d0d56ed7 as it is (build main) and with the pull request's src and tools (final.patch, build final); the
# census of what reads T's record on the three corpora by final; the fact words' kernels' two passes on musl and
# sqlite3.c by final, three runs each; and -c sqlite3.c as whole processes, main against final, twice.
cd "$(dirname "$0")"
./build-label.sh main 3d0d56ed75c5406bfe53c379f37f0d3f85bfc484 || exit 1
./build-label.sh final 3d0d56ed75c5406bfe53c379f37f0d3f85bfc484 final.patch || exit 1
./reads.sh final || exit 1
./two-run.sh final || exit 1
./compile.sh main final 2 || exit 1
echo final finished
