#!/usr/bin/env bash
set -euo pipefail
objdir=$1; i=$2
cd "$ROOT/src"
mapfile -d '' -t FLAGS < "$objdir/flags.argv0"
mapfile -d '' -t SOURCES < "$objdir/sources.argv0"
mapfile -d '' -t EXTRA < "$objdir/extra.argv0" || EXTRA=()
clang -c "${SOURCES[$i]}" -o "$objdir/$i.o" "${FLAGS[@]}" ${EXTRA[@]+"${EXTRA[@]}"}
