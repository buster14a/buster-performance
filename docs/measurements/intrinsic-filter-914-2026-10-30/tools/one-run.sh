#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-20261030"
kind="$1"
placement="${2:-0}"
process="${3:-1}"
head="placement-fixed/compiler-$placement"
base="$PWD/placement-base/compiler-$placement"
if [ "$placement" = direct ]; then
    head=fixed/compiler-0
    base="$PWD/base/compiler-0"
fi
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export LC_ALL=C
case "$kind" in
    identity)
        uname -a
        lscpu
        ldd --version | head -1
        cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
        cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
        sha256sum placement-base/compiler-0 placement-base/compiler-64 placement-base/compiler-256 placement-fixed/compiler-0 placement-fixed/compiler-64 placement-fixed/compiler-256 "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" tiny.c
        ;;
    capture-sqlite)
        DEBUGINFOD_URLS= taskset -c 2 gdb -q -nx -batch -ex "set \$capture_output = \"$PWD/results/sqlite.names.u32le\"" -x capture_names_binary.gdb --args fixed/compiler-0 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite" -o results/capture-sqlite.o "$corpus/sqlite/sqlite3.c"
        ;;
    capture-tiny)
        DEBUGINFOD_URLS= taskset -c 2 gdb -q -nx -batch -ex "set \$capture_output = \"$PWD/results/tiny.names.u32le\"" -x capture_names_binary.gdb --args fixed/compiler-0 -c -march=znver5 -o results/capture-tiny.o tiny.c
        ;;
    whole-sqlite)
        taskset -c 2 "$head" measure-compile --runs 21 --warmups 2 --keep --directory "$PWD/results" --reference "$base" -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c"
        ;;
    whole-tiny)
        taskset -c 2 "$head" measure-compile --runs 51 --warmups 5 --keep --directory "$PWD/results" --reference "$base" -- -c -march=znver5 tiny.c
        ;;
    *) exit 2 ;;
esac
