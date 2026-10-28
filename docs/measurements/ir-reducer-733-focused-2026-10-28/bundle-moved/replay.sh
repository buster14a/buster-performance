#!/bin/sh
set -eu
cd -- "$(dirname -- "$0")"
: "${BUSTER_COMPILER:?Set BUSTER_COMPILER to the matching compiler executable}"
"$BUSTER_COMPILER" reduce-ir --revision e175decaf684ff1812673faf424424b7cbafe659 --output ./replayed --max-candidates 512 --milliseconds 60000 --predicate-ms 30000 --memory 134217728 --steps 100000 --frames 32 --passes 7 --seed 0 --expect-kind 3 --expect-pass 7 --expect-detail 0 --scalar --inject memory-store --arg 0x0000000000000005:0x0000000000000000 './reduced.ir'
