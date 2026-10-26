#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
mode=$1
tree=$2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
lua=/home/david/buster-fast-bench/x87-136/lua
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
    -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
    -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
case "$mode" in
    perf) exec perf stat -x, -e instructions:u,cycles:u -r 11 taskset -c 2 "$tree/build/compiler" -fsyntax-only "${source[@]}" ;;
    perf-labels) exec perf stat -x, -e instructions:u,cycles:u -r 11 taskset -c 2 "$tree/build/compiler" -fsyntax-only label-dispatch-128.c ;;
    process) exec taskset -c 2 "$tree/build/compiler" time-runs --runs 21 --warmups 2 \
        --list -fsyntax-only "${source[@]}" --list -c "$lua/lstrlib.c" -o /dev/null \
        --list -c -U__ELF__ "$lua/lparser.c" -o /dev/null --list -fsyntax-only label-dispatch-128.c ;;
    sqlite) exec taskset -c 2 "$tree/build/compiler" -fsyntax-only "${source[@]}" ;;
    lstrlib) exec taskset -c 2 "$tree/build/compiler" -c "$lua/lstrlib.c" -o /dev/null ;;
    lparser) exec taskset -c 2 "$tree/build/compiler" -c -U__ELF__ "$lua/lparser.c" -o /dev/null ;;
    labels) exec taskset -c 2 "$tree/build/compiler" -fsyntax-only label-dispatch-128.c ;;
    *) exit 2 ;;
esac
