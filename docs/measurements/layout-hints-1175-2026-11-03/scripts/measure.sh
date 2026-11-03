#!/usr/bin/env bash
# measure.sh BINARY NAME [MODE]: instruments BINARY (linked with --emit-relocs) with BOLT, compiles the frozen sqlite3.c
# with it (MODE fsyntax, the default, is -fsyntax-only; c is -c --lanes 1, since znver5's mwaitx can't run on an Intel
# host), and writes under $WORK/runs/NAME: profile.fdata (BOLT's edge counts), dyno.txt (BOLT's dyno stats of BINARY's
# own layout), edges.txt (taken edges and the conditional branches' fall-throughs, by scripts/taken.c), lines.txt
# (taken and fall-through counts by innermost source line) and functions-taken.txt (taken by compiled function).
# $WORK holds corpus/ (buster's tools/ci/fetch-corpus.sh output) and runs/; LLVM is LLVM 23's bin directory.
set -euo pipefail
here="$(dirname "$(realpath "$0")")"
B=${LLVM:-/usr/lib/llvm-23/bin}
binary="$(realpath "$1")"
out="$WORK/runs/$2"
mode="${3:-fsyntax}"
mkdir -p "$out"
sq="$WORK/corpus/sqlite"
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
"$B/llvm-bolt" "$binary" -instrument -strict -instrumentation-file="$out/profile.fdata" -o "$out/instrumented" > "$out/instrument.log" 2>&1
rm -f "$out/profile.fdata"
if [ "$mode" = c ]; then
    "$out/instrumented" -c --lanes 1 "${options[@]}" -o "$out/sqlite3.o"
else
    "$out/instrumented" -fsyntax-only "${options[@]}"
fi
"$B/llvm-bolt" "$binary" -strict -data="$out/profile.fdata" -dyno-stats -o /dev/null > "$out/dyno.log" 2>&1
sed -n '/program-wide dynostats/,/all conditional branches/p' "$out/dyno.log" > "$out/dyno.txt"
"$here/attribute.sh" "$binary" "$2"
