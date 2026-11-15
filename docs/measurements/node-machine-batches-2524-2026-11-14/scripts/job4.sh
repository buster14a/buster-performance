#!/bin/bash
# job4.sh: the batching commit with order-b.patch (b1v), then two rounds of time-order.sh at orders 0, 1 and 2 and
# batches 4, 16 and 256.
set -u
cd "$(dirname "$0")"
./build-label.sh b1v 5d4c533 order-b.patch > results/b1v-build.out 2>&1
for round in 1 2; do
    for b in 4 16 256; do
        for o in 0 1 2; do ./time-order.sh b1v $o $b -r$round; done
    done
done
date -u +%FT%TZ > results/.job4-done
