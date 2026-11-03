#!/usr/bin/env bash
# queue12.sh: after queue11, commit 12 as 3a2ce1b5 wrote it (a static thread-local count) against commit 12 with
# c4f27c91's ir.c (the count shared by main.c's units, as the head has it), on the same base: head-12x's build, then perf
# stat of --tier1 -c of the frozen sqlite3.c (bisect.sh, bisect12/).
. ~/buster-fast-bench/claude-141-wide/common.sh
until [ -f ab11/done ]; do sleep 20; done
rm -rf head-12x && tar xzf head-12x.tgz && rm head-12x.tgz
./build.sh head-12x
BISECT_OUT=bisect12 ./bisect.sh head-3a2ce1b5 head-12x
