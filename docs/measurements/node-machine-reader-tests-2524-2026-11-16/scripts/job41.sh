#!/bin/bash
# job41.sh: do the fact words' kernels' cycles on musl follow the stack's place? w2 and z3, the loads and the whole
# kernel with a body a window, eight pads of 512 bytes each, in turn.
set -u
cd "$(dirname "$0")"
for pad in 0 512 1024 1536 2048 2560 3072 3584; do
    for label in w2 z3; do
        ./facts-pad-musl.sh $label loads $pad --facts-loads --passes 5 --list 20
        ./facts-pad-musl.sh $label whole $pad --passes 5 --list 20
    done
done
echo "job41 done $(date -u +%FT%TZ)" >> results/job41.log
