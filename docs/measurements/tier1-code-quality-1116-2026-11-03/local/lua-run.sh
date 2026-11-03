#!/bin/bash
# lua-run.sh COMPILER OUTDIR [flags]: build Lua 5.4.8 with COMPILER --tier1 -c (each object), link with clang, run the
# scripts, and compare each output with clang -O0's build.
set -u
compiler=$1; out=$2; shift 2
src=/home/david/buster-lab/inputs/lua-5.4.8/src
scripts=/home/david/.cache/claude-1116/lua-scripts
mkdir -p "$out/obj" "$out/ref"
flags=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
for f in "$src"/*.c; do
    b=$(basename "$f" .c); [ "$b" = luac ] && continue
    "$compiler" --tier1 "$@" "${flags[@]}" -c "$f" -o "$out/obj/$b.o" 2> "$out/obj/$b.err" || { echo "compile FAIL $b"; cat "$out/obj/$b.err" | head -3; }
    [ -f "$out/ref/$b.o" ] || clang -O0 "${flags[@]}" -c "$f" -o "$out/ref/$b.o"
done
clang "$out"/obj/*.o -o "$out/lua" -lm -ldl || exit 1
clang "$out"/ref/*.o -o "$out/lua-ref" -lm -ldl || exit 1
status=0
for s in "$scripts"/*.lua; do
    n=$(basename "$s")
    "$out/lua" "$s" > "$out/$n.out" 2>&1; a=$?
    "$out/lua-ref" "$s" > "$out/$n.ref" 2>&1; r=$?
    if [ $a -eq $r ] && cmp -s "$out/$n.out" "$out/$n.ref"; then echo "ok $n"; else echo "DIFF $n ($a vs $r)"; diff "$out/$n.out" "$out/$n.ref" | head -5; status=1; fi
done
exit $status
