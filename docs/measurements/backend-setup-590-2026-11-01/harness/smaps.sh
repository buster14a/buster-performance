#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# smaps.sh BASE HEAD LOG: each build's hello.c compile stopped at check_lower_prepare (the end of backend-setup) under gdb,
# with its smaps_rollup and every mapping's AnonHugePages and FilePmdMapped, under the 9700X's lock, pinned to CPU 2.
cd ~/buster-fast-bench/590-claude
export EXCLUSIVE_OWNER=claude-590 EXCLUSIVE_TITLE="#590 backend setup measurements (PR #1027)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1027
for t in "$1" "$2"; do
    echo "== $t"
    ~/buster-fast-bench/exclusive.sh taskset -c 2 gdb -q -batch -x harness/smaps.gdb --args $t/build/compiler -c -o /tmp/smaps-$t.o harness/hello.c 2>&1 | grep -E 'ROLLUP|HUGE'
done > "$3" 2>&1
echo done >> "$3"
