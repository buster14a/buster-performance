#!/bin/bash
# #1340 part 2: base against head over the corpora: each unit's object and stderr, with the default warnings and with
# the warnings named below, both compilers run from the same directory; then head's --branch-truth-census of each unit.
# Usage: corpora.sh BASE HEAD CORPUS LUA C_TESTSUITE OUT
set -u
base=$1; head=$2; corpus=$3; lua=$4; cts=$5; out=$6
mkdir -p "$out"; cd "$out"
musl="$corpus/libc/musl"
musl_flags=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
sqlite_flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite")
lua_flags=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "-I$lua/src")
extra=(-Wall -Wextra -Wunreachable-code -Wreturn-type -Wuninitialized -Wtautological-compare)
: > summary.txt
run_set() {
    local name=$1; shift
    local -n flags=$1; shift
    local units=0 same=0 differ=0 failed=0 conditions=0 kept=0 decided=0 unsound=0 censused=0 nodes=0
    for mode in default extra; do
        local warn=(); [ $mode = extra ] && warn=("${extra[@]}")
        for file in "$@"; do
            "$base" --lanes 1 -c "${warn[@]}" "${flags[@]}" "$file" -o base.o 2> base.err; local bs=$?
            "$head" --lanes 1 -c "${warn[@]}" "${flags[@]}" "$file" -o head.o 2> head.err; local hs=$?
            units=$((units + 1))
            if [ $bs -ne $hs ] || ! cmp -s base.err head.err || { [ $bs -eq 0 ] && ! cmp -s base.o head.o; }; then
                differ=$((differ + 1)); echo "$name $mode $file: differs (status $bs/$hs)" >> differs.txt
            else
                same=$((same + 1))
            fi
            [ $bs -ne 0 ] && failed=$((failed + 1))
            rm -f base.o head.o
            if [ $mode = default ]; then
                line=$("$head" --lanes 1 -fsyntax-only -w --branch-truth-census "${flags[@]}" "$file" 2>&1 | grep '^branch-truth-census')
                if [ -n "$line" ]; then
                    read -r _ _ n _ _ _ _ _ _ _ c _ k _ d _ _ _ u <<< "$line"
                    censused=$((censused + 1)); nodes=$((nodes + n)); conditions=$((conditions + c)); kept=$((kept + k)); decided=$((decided + d)); unsound=$((unsound + u))
                    echo "$name	$file	$line" >> census.tsv
                fi
            fi
        done
        echo "$name $mode: units $units same $same differ $differ rejected-by-both $failed" >> summary.txt
        units=0; same=0; differ=0; failed=0
    done
    echo "$name census: units $censused nodes $nodes conditions $conditions kept $kept decided $decided unsound $unsound" >> summary.txt
}
none=()
run_set sqlite sqlite_flags "$corpus/sqlite/sqlite3.c"
run_set lua lua_flags "$lua"/src/*.c
run_set c-testsuite none "$cts"/tests/single-exec/*.c
run_set musl musl_flags "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c
echo done >> summary.txt
