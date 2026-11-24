#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.
set -euo pipefail
# One Release build tree with line information, frozen SQLite directory and new output directory.
if [[ $# -ne 3 ]]; then
    echo "usage: $0 BUILD_TREE SQLITE_DIRECTORY OUTPUT_DIRECTORY" >&2
    exit 2
fi
root=$(realpath "$(dirname "$0")")
tree=$(realpath "$1")
sqlite=$(realpath "$2")
mkdir "$3"
out=$(realpath "$3")
export BUSTER_HUGE_PAGES=1
sourcefile=$tree/src/buster/compiler/c_check_input.c
before=$(awk '/Arena sparse = valid \? check_input_sparse_arena/{print NR}' "$sourcefile")
after=$(awk '/arena_release\(&sparse\)/{print NR}' "$sourcefile")
cat >"$out/range.gdb" <<GDB
set pagination off
set confirm off
set startup-with-shell off
break c_check_input.c:$before
commands
silent
python import time; print("ARENA_BEGIN", time.monotonic_ns(), gdb.selected_inferior().pid)
continue
end
break c_check_input.c:$after
commands
silent
python import time; print("ARENA_END", time.monotonic_ns(), int(gdb.parse_and_eval("(uintptr_t)sparse.base")), int(gdb.parse_and_eval("sparse.length")))
continue
end
run
GDB
object=$(mktemp /dev/shm/buster-1167-census.XXXXXXXX)
trap 'rm -f -- "$object"' EXIT
"$root/locked.sh" timeout -k 5 90 perf record -q -k mono -d -e minor-faults -c 1 -o "$out/faults.data" -- taskset -c 2 gdb -nx -batch -x "$out/range.gdb" --args "$tree/build/compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$object" >"$out/range.txt" 2>"$out/hold.log"
sha256sum "$object" >"$out/object.sha256"
"$root/locked.sh" timeout -k 5 60 perf script --ns -i "$out/faults.data" -F pid,time,addr >"$out/faults.txt" 2>"$out/decode.log"
