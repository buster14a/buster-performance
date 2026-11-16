#!/bin/bash
# fixed.sh: main 3d0d56ed7 with the pull request's src and tools after its fix (fixed.patch: final's, the tests' two
# pinned counts added after it, and the pointer rule's and the cast's operands zeroed), built as fixed; the fact words'
# kernels' two passes on musl and sqlite3.c by fixed and again by two (main with the line), three runs each; and the
# census of what reads T's record on the three corpora by fixed.
cd "$(dirname "$0")"
./build-label.sh fixed 3d0d56ed75c5406bfe53c379f37f0d3f85bfc484 fixed.patch || exit 1
./two-run.sh fixed || exit 1
./passes.sh two -whole-b 3 "musl sqlite3" || exit 1
./passes.sh two -operators-b 3 "musl sqlite3" --facts-operators || exit 1
./reads.sh fixed || exit 1
echo fixed finished
