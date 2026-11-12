#!/bin/bash
# text.sh OUT REV:COMPILER...: whether each tagged COMPILER (callgrind's, cg9700.sh) builds the same code as the 9700X's
# compiler of REV: each of the 34 objects (Lua's 33, speedtest1's one) built by COMPILER with the 9700X's flags, its .text
# section's hash against that of the 9700X's object (in /home/user/w2553/r9/obj-REV). A line per object in OUT/text.txt.
set -u
out=$(readlink -f "$1"); shift
R=/home/user/w2553/r9; I=/home/user/w2553/inputs
files="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
text() { objcopy -O binary --only-section=.text "$1" /dev/stdout | sha256sum | cut -d' ' -f1; }
mkdir -p "$out"; : > "$out/text.txt"
for pair in "$@"; do
    r=${pair%%:*}; c=${pair#*:}
    d=$(mktemp -d "$out/obj.XXXXXX")
    for f in $files; do
        "$c" --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $d/$f.o $I/lua-5.4.8/src/$f.c
    done
    (cd $I && "$c" --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$I -c -o $d/speedtest1.o $R/st-unity.c)
    for f in speedtest1 $files; do
        a=$(text $d/$f.o); b=$(text $R/obj-$r/$f.o)
        echo "$r $f $([ "$a" = "$b" ] && echo same || echo DIFFERS) $a" >> "$out/text.txt"
    done
    rm -rf "$d"
done
