#!/bin/bash
# corpora.sh LABEL: the shadow with --verify (T's rows and rules checked against the action at every node they type) on
# the frozen sqlite3.c, Lua 5.4.8's 34 sources and musl's 1,336 units, each without and with -g, by results/LABEL's
# compiler, CPU 2, one hold of the lock a run, each hold's owner line appended to verify-holds.txt first. It compares,
# it doesn't time (--passes 0). As 2524-claude-step1's corpora.sh.
set -u
cd "$(dirname "$0")"
label=$1
out=$PWD/results/$label
compiler=$out/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
{
    sha256sum "$compiler" "$sqlite/sqlite3.c" "$lua"/*.c "$lua"/*.h
    echo "musl units ${#files[@]}"
    cat "${files[@]}" | sha256sum
} > "$out/corpora-inputs.txt" 2>&1
printf '%q ' -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" > "$out/musl-options.txt"
printf '%q ' "${files[@]}" > "$out/musl-files.txt"
for g in "" "-g"; do
    suffix=${g:+-g}
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner >> '$out/verify-holds.txt'; taskset -c 2 '$compiler' measure-node-machine --shadow --verify --passes 0 --list 20 $g -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/verify-sqlite3$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/verify-sqlite3$suffix.txt'"
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner >> '$out/verify-holds.txt'; taskset -c 2 '$compiler' measure-node-machine --shadow --verify --passes 0 --list 20 $g '$lua'/*.c > '$out/verify-lua$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/verify-lua$suffix.txt'"
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner >> '$out/verify-holds.txt'; taskset -c 2 '$compiler' measure-node-machine --shadow --verify --passes 0 --list 20 $g \$(cat '$out/musl-options.txt') \$(cat '$out/musl-files.txt') > '$out/verify-musl$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/verify-musl$suffix.txt'"
done
date -u +%FT%TZ > "$out/.verified"
