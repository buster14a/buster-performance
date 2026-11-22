#!/bin/bash
# alone.sh COMPILER OUT [EXTRA...]: measure-node-machine --shadow --front-alone on sqlite3.c, Lua, musl and the compiler's
# own source; each one's report and exit status.
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
    "$cc" measure-node-machine --shadow --front-alone --list 24 "$@" > "$out/$name.txt" 2>&1
    echo "$name exit $?"
    grep "node-shadow: alone bodies\|node-shadow: alone compared" "$out/$name.txt" | cut -c1-330
}
run sqlite "$@" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c"
run lua "$@" "$lua"/*.c
run main "$@" -march=native "-I$tree/src" -fwrapv -funsigned-char --predefines "$tree/build/predefines.h" "$tree/src/buster/compiler/main.c"
run musl "$@" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" \
    -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}"
