#!/bin/bash
# corpus-gate.sh COMPILER OUT: each unit of the four corpora compiled with -c and the producer beside its read
# (BUSTER_TEST_NODE_BODIES_LOG, nothing masked): the diagnostics at a token of a body the producer takes, by corpus.
set -uo pipefail
cc=$1; out=$2
corpus=$HOME/dev/buster-corpus
musl=$corpus/libc/musl
sq=$corpus/sqlite
lua=$HOME/.cache/claude-2850/inputs/lua-5.4.8/src
tree=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$cc")")")")")
mkdir -p "$out"
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
gate()
{
    local name=$1; shift
    local log="$out/$name.log"
    : > "$log"; mkdir -p "$log.units"
    local failed=0 units=0
    local list="$out/$name.files"
    while IFS= read -r f; do
        units=$((units + 1))
        BUSTER_TEST_NODE_BODIES_LOG="$log" "$cc" --lanes 1 "$@" -c "$f" -o /dev/null > "$out/$name.last.txt" 2>&1 || { failed=$((failed + 1)); echo "$f" >> "$out/$name.failed"; }
    done < "$list"
    python3 - "$log" "$name" "$units" "$failed" <<'PY'
import re, sys
units = ran = bodies = taken = looked = found = 0
for line in open(sys.argv[1], errors='replace'):
    m = re.match(r"unit=(.*) producer-ran=(\d) bodies=(\d+) taken=(\d+) diagnostics-looked-at=(\d+) in-a-taken-body=(\d+)", line)
    if m:
        units += 1; ran += int(m.group(2)); bodies += int(m.group(3)); taken += int(m.group(4)); looked += int(m.group(5)); found += int(m.group(6))
print(f"{sys.argv[2]}: compiled={sys.argv[3]} failed={sys.argv[4]} units-logged={units} the-producer-ran-in={ran} bodies={bodies} taken={taken} diagnostics-looked-at={looked} in-a-taken-body={found}")
PY
}
echo "$sq/sqlite3.c" > "$out/sqlite.files"
ls "$lua"/*.c > "$out/lua.files"
echo "$tree/src/buster/compiler/main.c" > "$out/main.files"
printf '%s\n' "${files[@]}" > "$out/musl.files"
gate sqlite -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq"
gate lua
gate main -march=native "-I$tree/src" -fwrapv -funsigned-char --predefines "$tree/build/predefines.h"
gate musl -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include"
echo finished
