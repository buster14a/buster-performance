#!/bin/bash
# two-run.sh LABEL: the two passes of the fact words kernels (step 1 whole, and with the operators) by LABEL, three runs
# each on musl and sqlite3.c
cd "$(dirname "$0")"
./passes.sh "$1" -whole 3 "musl sqlite3" && ./passes.sh "$1" -operators 3 "musl sqlite3" --facts-operators
echo two-run "$1" finished
