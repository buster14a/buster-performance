#!/bin/bash
# run4.sh PID: after run2.sh (the process PID) ends, where the checker's peak resident set differs between the trees:
# each executable's -fsyntax-only of sqlite3.c (the whole-driver runs' command) stopped by gdb at its first munmap of
# more than 64 MB, when its arenas start to be released and are all still mapped (at exit only 16 MB are resident):
# its peak (VmHWM) and current resident set and every resident mapping (smaps.py), twice each, each run locked alone.
set -u
while kill -0 "$1" 2> /dev/null; do
    sleep 10
done
D=~/buster-fast-bench/build-270-claude/ab3
L=$D/run4.log
export EXCLUSIVE_OWNER=claude-270
export EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/424
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
LOCK=~/buster-fast-bench/exclusive.sh
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
driver=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
echo "=== start $(date -Is)" >> "$L"
cd "$D/base"
for tree in base head head base; do
    echo "== tree $tree" >> "$L"
    "$LOCK" taskset -c 2 gdb -q -batch -ex 'set debuginfod enabled off' -ex 'catch syscall munmap' -ex 'condition 1 $rsi > 0x4000000' \
        -ex run -ex 'printf "munmap of %lu bytes at %#lx\n", $rsi, $rdi' -ex "source $D/smaps.py" -ex kill \
        --args "$D/$tree/build/compiler" -fsyntax-only "${driver[@]}" "$C/sqlite/sqlite3.c" >> "$L" 2>&1
    echo "status $?" >> "$L"
done
echo "done $(date -Is)" >> "$L"
