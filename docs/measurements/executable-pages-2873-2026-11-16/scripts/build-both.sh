#!/bin/bash
# build-both.sh: the two trees the A/Bs compare with main, one after the other, a hold of the lock each: `order` (the
# tracer and the new list alone) and `full` (those, the link aligned for huge pages and the exit helper's look).
cd "$(dirname "$0")"
./build-tree.sh order 1c6cc8ab5e778ab32078cbef17049c4814b30dca tool.patch list.patch > build-order.out 2>&1
./build-tree.sh full 1c6cc8ab5e778ab32078cbef17049c4814b30dca tool.patch huge.patch list.patch > build-full.out 2>&1
