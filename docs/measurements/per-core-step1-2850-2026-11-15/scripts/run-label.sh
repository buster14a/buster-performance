#!/bin/bash
# run-label.sh LABEL PATCH [RUNS]: build LABEL from main 8f223aee with PATCH, then on the three corpora, each run its own
# hold of the lock: --facts (a body a window), --facts-packed (windows of 384 records) and --facts-packed with windows
# of 4,096 records.
cd "$(dirname "$0")"
runs=${3:-1}
./build-label.sh "$1" 8f223aee "$2" && ./facts.sh "$1" "" $runs --passes 5 --list 20 && ./facts.sh "$1" "-packed" $runs --facts-packed --passes 5 --list 20 &&
    ./facts.sh "$1" "-packed4096" $runs --facts-packed --facts-window 4096 --passes 5 --list 20
