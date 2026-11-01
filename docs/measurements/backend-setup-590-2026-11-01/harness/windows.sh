#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# windows.sh BASE HEAD LOG: each build's hello.c compile stopped at check_lower_prepare (the end of backend-setup) under
# gdb, with the present base pages of each 2 MB window of .bss (/proc/PID/pagemap), under the 9700X's lock, on CPU 2.
cd ~/buster-fast-bench/590-claude
export EXCLUSIVE_OWNER=claude-590 EXCLUSIVE_TITLE="#590 backend setup measurements (PR #1027)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1027
for t in "$1" "$2"; do
    echo "== $t"
    ~/buster-fast-bench/exclusive.sh taskset -c 2 gdb -q -batch -x harness/windows.gdb --args $t/build/compiler -c -o /tmp/windows-$t.o harness/hello.c 2>&1 | grep -E 'WINDOW'
    nm -S -n $t/build/compiler | awk '$3 ~ /^[bB]$/' > "$3.$t.nm"
done > "$3" 2>&1
echo done >> "$3"
