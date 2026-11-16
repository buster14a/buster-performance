#!/bin/bash
# branch.sh LABEL PATCH: main 3d0d56ed7 with PATCH (the branch's src and tools) built as LABEL, the census of what reads
# T's record on the three corpora, and the fact words' kernels' two passes on musl and sqlite3.c, three runs each
cd "$(dirname "$0")"
./build-label.sh "$1" 3d0d56ed75c5406bfe53c379f37f0d3f85bfc484 "$2" || exit 1
./reads.sh "$1" || exit 1
./two-run.sh "$1"
echo branch "$1" finished
