#!/bin/bash
# corpus-objects-select.sh COMPILER OUT [EXTRA...] with SELECT=N:K in the environment (the on-runs take the
# producer's bodies whose place is K modulo N): each unit of the four corpora compiled to an object with --lanes 1, without and
# with --node-bodies: the objects compared, the diagnostics compared, the exit statuses compared; and what was taken.
set -uo pipefail
cc=$1; out=$2; shift 2
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
run()
{
    local name=$1; shift
    local list="$out/$name.files"
    local units=0 same=0 differ=0 status_differ=0 diag_differ=0 failed=0 bodies=0 taken=0 tokens=0
    : > "$out/$name.differences"
    while IFS= read -r f; do
        units=$((units + 1))
        "$cc" --lanes 1 "$@" -c "$f" -o "$out/off.o" > "$out/off.err" 2>&1; local s0=$?
        BUSTER_TEST_NODE_BODIES="$SELECT" "$cc" --lanes 1 --node-bodies --time-stages "$@" -c "$f" -o "$out/on.o" > "$out/on.all" 2>&1; local s1=$?
        BUSTER_TEST_NODE_BODIES="$SELECT" "$cc" --lanes 1 --node-bodies "$@" -c "$f" -o "$out/on2.o" > "$out/on.err" 2>&1; local s2=$?
        local line; line=$(grep -m1 "^node-bodies:" "$out/on.all" || true)
        if [[ -n $line ]]; then
            bodies=$((bodies + $(sed 's/.*bodies=\([0-9]*\).*/\1/' <<< "$line")))
            taken=$((taken + $(sed 's/.*taken=\([0-9]*\).*/\1/' <<< "$line")))
            tokens=$((tokens + $(sed 's/.*tokens=\([0-9]*\).*/\1/' <<< "$line")))
        fi
        [[ $s0 -ne 0 ]] && failed=$((failed + 1))
        if [[ $s0 -ne $s2 || $s0 -ne $s1 ]]; then status_differ=$((status_differ + 1)); echo "status $f: $s0 $s1 $s2" >> "$out/$name.differences"; fi
        if ! cmp -s "$out/off.err" "$out/on.err"; then diag_differ=$((diag_differ + 1)); echo "diagnostics $f" >> "$out/$name.differences"; fi
        if [[ $s0 -eq 0 ]]; then
            if cmp -s "$out/off.o" "$out/on2.o" && cmp -s "$out/off.o" "$out/on.o"; then same=$((same + 1)); else differ=$((differ + 1)); echo "object $f" >> "$out/$name.differences"; fi
        fi
    done < "$list"
    echo "$name: units=$units failed=$failed objects-same=$same objects-different=$differ statuses-different=$status_differ diagnostics-different=$diag_differ bodies=$bodies taken=$taken taken-tokens=$tokens"
}
echo "$sq/sqlite3.c" > "$out/sqlite.files"
ls "$lua"/*.c > "$out/lua.files"
echo "$tree/src/buster/compiler/main.c" > "$out/main.files"
printf '%s\n' "${files[@]}" > "$out/musl.files"
run sqlite "$@" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq"
run lua "$@"
run main "$@" -march=native "-I$tree/src" -fwrapv -funsigned-char --predefines "$tree/build/predefines.h"
run musl "$@" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include"
echo finished
