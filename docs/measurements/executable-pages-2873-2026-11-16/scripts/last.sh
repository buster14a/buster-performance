#!/bin/bash
# last.sh: the pull request's head. `full` built again from the patches as they are (the test's read that always faults
# came after the runs before), main against it once more (series.sh, into results/head-full-KIND), the probe's cost on
# it (the same executable with BUSTER_EXECUTABLE_HUGE_PAGES=0, musl a unit a process, 15 rounds), and the tests of what
# the change touches (results/tests-head). Waits for the runs before it; a hold of the lock each.
cd "$(dirname "$0")"
while pgrep -f "final.sh|extra.sh" > /dev/null; do sleep 5; done
: > last.done
cp huge.patch huge-before-head.patch
cp huge-head.patch huge.patch
./build-tree.sh full 1c6cc8ab5e778ab32078cbef17049c4814b30dca tool.patch huge.patch list.patch > build-head.out 2>&1
./series.sh head full
B_ENV=BUSTER_EXECUTABLE_HUGE_PAGES=0 ./lock.sh timeout -k 10 900 ./ab.sh results/head-probe-musl musl 15 "full=$PWD/full/build/compiler" "nolook=$PWD/full/build/compiler" > results/head-probe-musl.log 2>&1
./tests.sh full results/tests-head
echo finished > last.done
