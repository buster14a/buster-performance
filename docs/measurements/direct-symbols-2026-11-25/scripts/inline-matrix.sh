#!/bin/bash
# inline-matrix.sh COMPILER: each inline/cN.c by COMPILER's default -c (the direct path where it takes the unit) and by
# --no-direct, and clang 23's: what each object says of f (T defined, U undefined, t local, - none), and whether the
# default -c took the direct path. -fgnu89-inline for c8 and c9, -std=gnu11 for c13, -std=gnu99 for the rest.
here=$(cd "$(dirname "$0")/.." && pwd)
P=$1
CL=${CLANG:-clang}
NM=${NM:-llvm-nm}
t=$(mktemp -d)
for i in $(seq 1 21); do
    f=$here/inline/c$i.c
    opt=-std=gnu99; [ $i = 8 ] || [ $i = 9 ] && opt="-std=gnu99 -fgnu89-inline"; [ $i = 13 ] && opt=-std=gnu11
    rm -f "$t"/*.o
    $CL $opt -c "$f" -o "$t/k.o" 2>/dev/null; k=$($NM "$t/k.o" 2>/dev/null | grep -w f | awk '{print $(NF-1)}')
    "$P" $opt -c "$f" -o "$t/d.o" 2>/dev/null; dp=$(grep -ca 'buster direct' "$t/d.o" 2>/dev/null); d=$($NM "$t/d.o" 2>/dev/null | grep -w f | awk '{print $(NF-1)}')
    "$P" $opt --no-direct -c "$f" -o "$t/f.o" 2>/dev/null; fl=$($NM "$t/f.o" 2>/dev/null | grep -w f | awk '{print $(NF-1)}')
    m=" "; [ "${d:--}" != "${fl:--}" ] && m="X"
    printf '%s %2d clang=%-2s full=%-2s direct=%-2s (taken=%s) [%s] %s\n' "$m" $i "${k:--}" "${fl:--}" "${d:--}" "${dp:-0}" "$opt" "$(tr '\n' ' ' < "$f")"
done
rm -rf "$t"
