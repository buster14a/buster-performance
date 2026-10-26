#!/bin/bash
# Capture clang's dependency closure and SHA-256s for one #408 frozen input, outside timed work under the shared lock.
# The campaign's known source/header paths contain no whitespace. Preserve the raw Make dependencies as well.
# Usage: dependencies.sh sqlite|main ABSOLUTE_OUTPUT_PREFIX
set -euo pipefail
inputs=${BUSTER_PART1_INPUTS:-/home/david/buster-fast-bench/refine-116-claude/inputs}
prefix=$2
case "$prefix" in /*) ;; *) exit 2 ;; esac
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
case "$1" in
    sqlite)
        cd "$inputs"
        command=(clang -M -MT buster-451-sqlite "$inputs/sqlite3.c")
        ;;
    main)
        cd "$inputs/mainc"
        # Buster's --predefines replaces its predefined macros; supply that frozen file to clang after -undef.
        command=(clang -M -MT buster-451-main -march=native -Isrc -fwrapv -funsigned-char -undef -imacros predefines.h src/buster/compiler/main.c)
        ;;
    *) exit 2 ;;
esac
{
    printf 'working directory: %s\ncommand:' "$PWD"
    printf ' %q' "${command[@]}"
    printf '\n'
    clang --version
} > "$prefix.command"
"${command[@]}" > "$prefix.d"
# Refuse escaped whitespace rather than silently hashing a split filename.
if LC_ALL=C grep -q '\\[ 	]' "$prefix.d"; then
    printf 'unexpected escaped whitespace in dependency paths\n' >&2
    exit 1
fi
sed '1s/^[^:]*:[[:space:]]*//' "$prefix.d" | tr ' \t\\\n' '\n' | sed '/^$/d' | LC_ALL=C sort -u > "$prefix.paths"
xargs -r -d '\n' sha256sum -- < "$prefix.paths" > "$prefix.sha256"
printf 'dependency paths: '
wc -l < "$prefix.paths"
sha256sum "$prefix.d" "$prefix.paths" "$prefix.sha256" "$prefix.command"
