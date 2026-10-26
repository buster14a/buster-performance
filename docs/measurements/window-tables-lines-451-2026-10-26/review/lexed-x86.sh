#!/usr/bin/env bash
# #451 review: the bytes each screening build's windows lex for x86_64_encoder.c alone, which holds the 157 KB macro
# BUSTER_X86_VECTOR_FORMS: the frozen main.c tree's copy with its #include lines blanked to the same length (the same
# bytes and windows, without the headers' windowed files), preprocessed as main.c is. Counts, not times: laptop.
cd "$(dirname "$0")/.." || exit 1
root="$(pwd)"
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
mkdir -p "$root/tmp/x86"
python3 - "$root/inputs/mainc/src/buster/compiler/x86_64_encoder.c" "$root/tmp/x86/x86_64_encoder.c" <<'PY'
import sys
data = open(sys.argv[1], "rb").read()
lines = [b" " * len(line) if line.startswith(b"#include") else line for line in data.split(b"\n")]
open(sys.argv[2], "wb").write(b"\n".join(lines))
PY
sha256sum "$root/inputs/mainc/src/buster/compiler/x86_64_encoder.c" "$root/tmp/x86/x86_64_encoder.c" | sed "s|$root/||"
for tree in "$@"; do
    printf "%s x86_64_encoder.c: " "$tree"
    (cd "$root/inputs/mainc" && nice -n 19 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h "$root/tmp/x86/x86_64_encoder.c" 2>&1) |
        awk '/W lexed bytes/ {lexed = $8} /W file bytes/ {file = $8} END {printf "lexed %d of %d bytes\n", lexed, file}'
done
