#!/usr/bin/env bash
# devin-880 PGO/layout experiment builder. Replicates build.sh's compile+link with extra flags.
# usage: build-variant.sh NAME [extra-clang-args...] -- [extra-link-args...]
# Objects land in $WORK/objs-NAME; binary in $WORK/build/NAME/compiler-0.
set -euo pipefail
ROOT="$HOME/buster-fast-bench/devin-880"
SRC="$ROOT/src"
WORK="$ROOT/work"
name=$1; shift
cflags=()
while [ $# -gt 0 ] && [ "$1" != "--" ]; do cflags+=("$1"); shift; done
if [ "${1:-}" = "--" ]; then shift; fi
ldflags=("$@")
cd "$SRC"
mapfile -d '' -t FLAGS < <(BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
mapfile -d '' -t SOURCES < <(./build.sh print-sources)
objdir="$WORK/objs-$name"
rm -rf "$objdir"; mkdir -p "$objdir"
printf '%s\0' "${FLAGS[@]}" > "$objdir/flags.argv0"
printf '%s\0' "${SOURCES[@]}" > "$objdir/sources.argv0"
printf '%s\0' "${cflags[@]:-}" > "$objdir/extra.argv0" 2>/dev/null || true
printf '%s\0' "${ldflags[@]:-}" > "$objdir/ldextra.argv0" 2>/dev/null || true
export ROOT
seq 0 $((${#SOURCES[@]} - 1)) | xargs -P 8 -I{} "$ROOT/compile-one.sh" "$objdir" {} 2> "$objdir/errors.log" || {
    cat "$objdir/errors.log" >&2; exit 1; }
mkdir -p "$WORK/build/$name"
"$ROOT/link-variant.sh" "$name" "$objdir" "$WORK/build/$name/compiler-0" 0
