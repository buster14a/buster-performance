#!/usr/bin/env bash
# exp.sh VARIANT...: each VARIANT names a directory under exp/ that holds a source tree. Compiles its checker unit
# (main_unit_checker.c, which holds the whole compile path), links it with exp/base's other objects, bakes it, and
# counts sqlite3.c's -fsyntax-only and -c on CPU 2. exp/base's objects are compiled first if they are missing.
set -euo pipefail
R=$HOME/buster-fast-bench/claude-880
E=$R/exp
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
cd "$E/base"
mapfile -d '' -t FLAGS < <(BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
mapfile -d '' -t SOURCES < <(./build.sh print-sources)
checker=-1
for i in "${!SOURCES[@]}"; do
    if [ "${SOURCES[$i]}" = src/buster/compiler/main_unit_checker.c ]; then checker=$i; fi
done
compile() { (cd "$1" && clang -c "${SOURCES[$2]}" -o "$3" "${FLAGS[@]}" "${@:4}"); }
if [ ! -f "$E/base/objs/done" ]; then
    mkdir -p "$E/base/objs"
    running=0
    for i in "${!SOURCES[@]}"; do
        if [ "$running" -ge 8 ]; then wait -n; running=$((running - 1)); fi
        compile "$E/base" "$i" "$E/base/objs/$i.o" &
        running=$((running + 1))
    done
    wait
    touch "$E/base/objs/done"
fi
link() {
    local v=$1 linked=()
    for i in "${!SOURCES[@]}"; do
        if [ "$i" -eq "$checker" ]; then linked+=("$E/$v/checker.o"); else linked+=("$E/base/objs/$i.o"); fi
    done
    clang -no-pie --ld-path="$(command -v wild)" "${linked[@]}" -lm -ldl -o "$E/$v/compiler"
    "$E/$v/compiler" bake-tables "$E/$v/compiler.baked" && mv -f "$E/$v/compiler.baked" "$E/$v/compiler"
}
pids=()
for v in "$@"; do
    if [ "$v" = base ]; then
        cp "$E/base/objs/$checker.o" "$E/base/checker.o"
    elif [ -f "$E/$v/profile.profdata" ]; then
        # A profile variant: base's source with the variant's profile.
        extra=()
        if [ -f "$E/$v/cflags" ]; then mapfile -t extra < "$E/$v/cflags"; fi
        compile "$E/base" "$checker" "$E/$v/checker.o" "-fprofile-instr-use=$E/$v/profile.profdata" "${extra[@]}" & pids+=($!)
    else
        extra=()
        if [ -f "$E/$v/cflags" ]; then mapfile -t extra < "$E/$v/cflags"; fi
        compile "$E/$v" "$checker" "$E/$v/checker.o" "${extra[@]}" & pids+=($!)
    fi
done
for p in "${pids[@]}"; do wait "$p"; done
for v in "$@"; do link "$v"; done
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
for v in "$@"; do
    for mode in -fsyntax-only -c; do
        a=("$mode"); [ "$mode" = -c ] && a=(-c -o "$E/$v/sqlite.o")
        for run in 1 2 3; do
            taskset -c 2 perf stat -x, -e instructions:u,cycles:u,ex_ret_near_ret:u,ex_ret_brn_tkn:u,ls_dispatch.store_dispatch:u "$E/$v/compiler" "${a[@]}" "${BASE[@]}" "$C/sqlite/sqlite3.c" 2>&1 > /dev/null | awk -F, -v v="$v" -v m="$mode" -v r=$run '{printf "%s %s %s %s %s\n", v, m, r, $3, $1}'
        done
    done
    cmp "$E/$v/sqlite.o" "$E/base/sqlite.o" 2> /dev/null && echo "$v: object identical to base's" || echo "$v: object differs from base's (or no base yet)"
    size -A "$E/$v/compiler" | awk -v v="$v" '$1 == ".text" {print v, ".text", $2}'
done
