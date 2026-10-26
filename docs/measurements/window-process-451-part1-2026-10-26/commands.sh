#!/bin/bash
# Original measurement dispatch glue for Buster #451 part 1. The coordinator calls ONE command per shared-lock hold.
# Usage: commands.sh preflight|process WORKLOAD windows|whole|ROUND
#        commands.sh phase sqlite|main windows|whole
# WORKLOAD is sqlite-e, sqlite-check, main-e, or main-parse. process takes ROUND (1..5), alternating the first list.
set -euo pipefail
compiler=${BUSTER_PART1_COMPILER:-/home/david/buster-fast-bench/codex-449-450-451-20261026/base/build/compiler}
inputs=${BUSTER_PART1_INPUTS:-/home/david/buster-fast-bench/refine-116-claude/inputs}
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
mode=$1
workload=$2
variant=$3
case "$workload" in
    sqlite|sqlite-e|sqlite-check) source=("$inputs/sqlite3.c") ;;
    main|main-e|main-parse)
        cd "$inputs/mainc"
        source=(-march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c)
        ;;
    *) exit 2 ;;
esac
case "$workload" in
    sqlite-e|main-e) driver=(-E -o /dev/null) ;;
    sqlite-check) driver=(-fsyntax-only) ;;
    main-parse) driver=(parse -fsyntax-only) ;;
    sqlite|main) driver=() ;;
esac
case "$mode" in
    preflight)
        extra=()
        case "$variant" in
            windows) ;;
            whole) extra=(--window-bytes 2000000000) ;;
            *) exit 2 ;;
        esac
        command=("$compiler" "${driver[@]}" "${extra[@]}" "${source[@]}")
        ;;
    process)
        case "$variant" in
            1|3|5) first=(); second=(--window-bytes 2000000000) ;;
            2|4) first=(--window-bytes 2000000000); second=() ;;
            *) exit 2 ;;
        esac
        command=("$compiler" time-runs --runs 21 --warmups 2
            --list "${driver[@]}" "${first[@]}" "${source[@]}"
            --list "${driver[@]}" "${second[@]}" "${source[@]}")
        ;;
    phase)
        extra=()
        case "$variant" in
            windows) ;;
            whole) extra=(--window-bytes 2000000000) ;;
            *) exit 2 ;;
        esac
        command=("$compiler" benchmark-preprocessor --only vectorized "${extra[@]}" "${source[@]}")
        ;;
    *) exit 2 ;;
esac
printf 'working directory: %s\ncommand:' "$PWD"
printf ' %q' "${command[@]}"
printf '\n'
exec "${command[@]}"
