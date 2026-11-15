#!/bin/bash
set -eu
root="$HOME/buster-fast-bench/2803-codex-6af9ef"
variant="$1"
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
sha256sum "$root/corpus/sqlite/sqlite3.c"
taskset -c 2 env BUSTER_LINE_BENCH="$root/corpus/sqlite/sqlite3.c" "$root/$variant/build/cmake/x86-64/Release/compiler" test-preprocessor
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
