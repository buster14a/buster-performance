#!/bin/bash
D=~/buster-fast-bench/653-claude
many_args()
{
    local m="$D/many-$1-$2"; local args=(-fsyntax-only)
    for ((d = 0; d < $1; d++)); do args+=(-I "$m/d$d"); done
    args+=(-I "$m/hdr" "$m/unit.c"); echo "${args[@]}"
}
cd "$D/inputs"
for t in base pr; do
    for f in tiny.c one.c uncompr.c deflate.c sqlite3.c; do
        strace -f -c -o "$D/out/strace-$t-$f.txt" taskset -c 2 "$D/$t/build/compiler" -c "$f" -o "$D/out/$t-$f.o" > /dev/null 2>&1
        printf '%s %s: ' "$t" "$f"; awk '$NF == "openat" || $NF == "getdents64" || $NF == "fstatfs" || $NF == "newfstatat" { printf "%s %s calls %s errors; ", $NF, $4, (NF == 6 ? $5 : 0) }' "$D/out/strace-$t-$f.txt"; echo
    done
    for spec in "10 2000" "100 2000" "200 4000"; do
        set -- $spec
        strace -f -c -o "$D/out/strace-$t-many-$1-$2.txt" taskset -c 2 "$D/$t/build/compiler" $(many_args $1 $2) > /dev/null 2>&1
        printf '%s many %s dirs %s headers: ' "$t" "$1" "$2"; awk '$NF == "openat" || $NF == "getdents64" || $NF == "fstatfs" || $NF == "newfstatat" { printf "%s %s calls %s errors; ", $NF, $4, (NF == 6 ? $5 : 0) }' "$D/out/strace-$t-many-$1-$2.txt"; echo
    done
done
for f in tiny.c one.c uncompr.c deflate.c sqlite3.c; do cmp "$D/out/base-$f.o" "$D/out/pr-$f.o" && echo "$f: base and pr objects identical"; done
