#!/bin/bash
# job.sh LABEL PATCH [READINGS]: buster#2850's piece "the front writes the window" (--front-window), on buster#2895's
# head eb0a76e21 (main c7caeb56b with buster#2890's and the fact words' kernel at reader time). LABEL is that head with
# PATCH.
#   1. The window (--front-window) and the piece before it (--front-facts) in turn: READINGS readings a corpus
#      (default 5).
#   2. One run of the window on sqlite3.c under perf record, three times: user cycles, instructions and mispredicted
#      branches by symbol (perf.sh).
cd "$(dirname "$0")"
label=$1; patch=$2; readings=${3:-5}
head=eb0a76e21697c047d97f6efeb046b26691ea1e64
./build-label.sh "$label" $head "$patch" || exit 1
./turns.sh "" "$readings" "sqlite3 lua musl" "$label window --shadow --passes 0 --front-window" "$label facts --shadow --passes 0 --front-facts" || exit 1
./perf.sh "$label" || exit 1
echo job finished
