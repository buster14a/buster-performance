#!/bin/bash
# Compare admitted production roots, then every native kind, class, value and parser-source token.
# Usage: ./verify-frozen.sh /absolute/path/to/Develop/compiler /absolute/path/to/sqlite3.c output-directory
set -euo pipefail
probe="$(cd "$(dirname "$0")" && pwd)"
compiler="$(realpath "$1")"
source_file="$(realpath "$2")"
out="$(realpath -m "$3")"
mkdir -p "$out"
args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$(dirname "$source_file")" "$source_file")
for mode in window plain; do
    flags=()
    if [[ $mode == window ]]; then flags+=(--node-window-assignments); fi
    PROBE_SOURCE="$mode" PROBE_ROOTS="$out/roots-$mode.bin" gdb -q -nx -batch -x "$probe/sql-roots.gdb" --args "$compiler" "${flags[@]}" --dump-typed "${args[@]}"
done
python3 - "$out" <<'PY'
from collections import defaultdict
from pathlib import Path
import struct, sys
out = Path(sys.argv[1])
def entries(mode):
    return struct.iter_unpack('<III96s', (out / f'roots-{mode}.bin').read_bytes())
ordinary = defaultdict(set)
for token, op, slot, value in entries('plain'):
    ordinary[token].add(value)
checked = failed = 0
for token, op, slot, value in entries('window'):
    checked += 1
    failed += value not in ordinary[token]
print(f'All 96 checked bytes matched at {checked - failed} of {checked} roots.')
assert checked and not failed
PY
for mode in off on; do
    NATIVE_MODE="$mode" NATIVE_PROBE="$out/native-$mode.txt" gdb -q -nx -batch -x "$probe/sql-native-sources.gdb" --args "$compiler" measure-lowering-templates "${args[@]}"
    test -s "$out/native-$mode.txt"
done
cmp "$out/native-off.txt" "$out/native-on.txt"
sha256sum "$out/native-on.txt"
