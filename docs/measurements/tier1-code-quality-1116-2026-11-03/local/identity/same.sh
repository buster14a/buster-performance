#!/bin/bash
# same.sh OLD NEW OUT: --tier1 -c of Lua 5.4.8's 34 sources, sqlite3.c and speedtest1-unity.c by both compilers; cmp each object.
set -u
old=$1; new=$2; out=$3
mkdir -p "$out/old" "$out/new"
lua=/home/david/buster-lab/inputs/lua-5.4.8/src
sq=/home/david/buster-lab/inputs/sqlite-amalgamation-3530400
st=/home/david/.cache/claude-speedtest1-136/dry/src
lflags=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
sflags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -fno-asynchronous-unwind-tables)
same=0; differ=0
check() { if cmp -s "$out/old/$1.o" "$out/new/$1.o"; then same=$((same + 1)); else differ=$((differ + 1)); echo "differ $1"; fi; }
for f in "$lua"/*.c; do
    b=$(basename "$f" .c)
    for t in old new; do c=$old; [ $t = new ] && c=$new; "$c" --tier1 "${lflags[@]}" -c "$f" -o "$out/$t/$b.o" 2> "$out/$t/$b.err" || echo "FAIL $t $b"; done
    check "$b"
done
for t in old new; do c=$old; [ $t = new ] && c=$new
    "$c" --tier1 "${sflags[@]}" -I"$sq" -c "$sq/sqlite3.c" -o "$out/$t/sqlite3.o" 2> "$out/$t/sqlite3.err" || echo "FAIL $t sqlite3"
    "$c" --tier1 "${sflags[@]}" -I"$sq" -I"$st" -c "$st/speedtest1-unity.c" -o "$out/$t/speedtest1.o" 2> "$out/$t/speedtest1.err" || echo "FAIL $t speedtest1"
done
check sqlite3; check speedtest1
echo "objects: $same identical, $differ differ"
ls "$out/new" | grep -c '\.o$'
