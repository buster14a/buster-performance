#!/bin/bash
# One Buster #451 part 1 correctness command per invocation; the coordinator supplies the shared host lock.
set -euo pipefail
compiler=${BUSTER_PART1_COMPILER:-/home/david/buster-fast-bench/codex-449-450-451-20261026/base/build/compiler}
inputs=${BUSTER_PART1_INPUTS:-/home/david/buster-fast-bench/refine-116-claude/inputs}
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
case "$1" in
    fixtures-preprocessor) command=("$compiler" test-preprocessor) ;;
    fixtures-files) command=("$compiler" test-files) ;;
    refinement) command=("$compiler" test-refinement "$inputs/mainc/src" "$inputs/sqlite3.c") ;;
    sqlite-preprocessor-windows) command=("$compiler" test-preprocessor --window-bytes 64 "$inputs/sqlite3.c") ;;
    sqlite-preprocessor-whole) command=("$compiler" test-preprocessor --window-bytes 2000000000 "$inputs/sqlite3.c") ;;
    sqlite-files) command=("$compiler" test-files "$inputs/sqlite3.c") ;;
    main-preprocessor-windows|main-preprocessor-whole|main-files)
        mode=$1
        cd "$inputs/mainc"
        source=(-march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c)
        case "$mode" in
            main-preprocessor-windows) command=("$compiler" test-preprocessor --window-bytes 64 "${source[@]}") ;;
            main-preprocessor-whole) command=("$compiler" test-preprocessor --window-bytes 2000000000 "${source[@]}") ;;
            main-files) command=("$compiler" test-files "${source[@]}") ;;
        esac
        ;;
    *) exit 2 ;;
esac
printf 'working directory: %s\ncommand:' "$PWD"
printf ' %q' "${command[@]}"
printf '\n'
exec "${command[@]}"
