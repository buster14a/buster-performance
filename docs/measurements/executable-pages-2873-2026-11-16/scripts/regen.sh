#!/bin/bash
# regen.sh REVISION: the change on main at REVISION with the list as it is (`full0`), built in one hold of the lock; then
# the start order's inputs and list from `full0` (order.sh), in results/order.
cd "$(dirname "$0")"
revision=$1
: > regen.done
HOST_ARCH=znver5 DEBUG_INFO=0 ./build-tree.sh full0 "$revision" tool.patch huge.patch list.patch > build-full0.out 2>&1
rm -rf results/order
for what in small sqlite "musl 0 2000" list; do
    ./lock.sh timeout -k 5 600 ./order.sh full0 results/order $what; echo "$what $?" >> build-full0.out
done
echo regenerated > regen.done
