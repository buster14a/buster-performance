#!/usr/bin/env bash
# #451 review: the acceptance runs of the revised code (94ae0608) on the laptop, single-threaded at nice 19 but
# test-files, whose lanes go through the cores queue. Each file is compared with the scalar twins a window at a time:
# 128 KB windows (the default) and 64-byte ones, on #408's frozen sqlite3.c and main.c and generate451's sources.
cd "$(dirname "$0")/.." || exit 1
root="$(pwd)"
out="$root/accept2"
mkdir -p "$out" "$root/tmp"
export TMPDIR="$root/tmp" SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
compiler="$root/wt/build/compiler"
git -C "$root/wt" log -1 --format="tree %H" -- src > "$out/revision.txt"
sha256sum "$compiler" >> "$out/revision.txt"
(cd "$root/wt" && nice -n 19 "$compiler" test-preprocessor > "$out/test-preprocessor.log" 2>&1); echo "test-preprocessor status $?"
for w in 131072 64; do
    nice -n 19 "$compiler" test-preprocessor --window-bytes $w "$root/inputs/sqlite3.c" > "$out/test-preprocessor-sqlite-$w.log" 2>&1; echo "sqlite3.c windows of $w status $?"
    (cd "$root/inputs/mainc" && nice -n 19 "$compiler" test-preprocessor --window-bytes $w -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c) > "$out/test-preprocessor-main-$w.log" 2>&1; echo "main.c windows of $w status $?"
    for g in long-lines spliced; do
        nice -n 19 "$compiler" test-preprocessor --window-bytes $w "$root/inputs/$g.c" > "$out/test-preprocessor-$g-$w.log" 2>&1; echo "$g.c windows of $w status $?"
    done
done
(cd "$root/wt" && CORES_TITLE="#451 review: acceptance" CORES_LINK="https://github.com/buster14a/buster/pull/486" cores -n 4 -- "$compiler" test-files > "$out/test-files.log" 2>&1); echo "test-files status $?"
(cd "$root/wt" && nice -n 19 "$compiler" test-refinement src > "$out/test-refinement-src.log" 2>&1); echo "test-refinement src status $?"
echo "accept done"
