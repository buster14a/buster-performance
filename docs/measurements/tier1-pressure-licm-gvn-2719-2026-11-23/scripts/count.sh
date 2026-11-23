#!/bin/bash
# count.sh COMPILER LABEL [OPTIONS...]: build Lua (fixed hash seed) and speedtest1 by COMPILER --tier1 OPTIONS,
# then print each run's callgrind instruction count, tab-separated: LABEL program count.
set -u
compiler=$1
label=$2
shift 2
inputs=/home/user/inputs
out=/tmp/claude-0/-home-user/98d46d8d-c801-5eaa-b4aa-aa7221f6e075/scratchpad/runs/$label
rm -rf "$out"
mkdir -p "$out/db"
lua=$inputs/lua/lua-5.4.8/src
sources=$(ls $lua/*.c | grep -v -e luac.c -e lstate.c)
"$compiler" --tier1 -fno-asynchronous-unwind-tables "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX '-Dluai_makeseed(L)=0x2602u' -c -o "$out/lstate.o" $lua/lstate.c || exit 1
"$compiler" --tier1 -fno-asynchronous-unwind-tables "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o "$out/lua" $sources "$out/lstate.o" -lm -ldl > "$out/lua-build.txt" 2>&1 || { cat "$out/lua-build.txt"; exit 1; }
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$out/unity.c"
"$compiler" --tier1 -fno-asynchronous-unwind-tables "$@" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$inputs/sqlite -I$inputs -o "$out/st" "$out/unity.c" -lm > "$out/st-build.txt" 2>&1 || { cat "$out/st-build.txt"; exit 1; }
jobs=""
for s in arithmetic calls closures strings tables; do
    echo "lua $s"
done > "$out/list"
echo "st mix1" >> "$out/list"
run() {
    local kind=$1 name=$2
    if [ "$kind" = lua ]; then
        (cd $inputs/scripts && valgrind --tool=callgrind --callgrind-out-file=/dev/null "$out/lua" $name.lua 2>&1 >"$out/$name.stdout" | grep -o "Collected : [0-9]*" | sed "s/Collected : /$label\t$name\t/")
    else
        mkdir -p "$out/db/$name"
        (cd "$out/db/$name" && valgrind --tool=callgrind --callgrind-out-file=/dev/null "$out/st" --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 t.db 2>&1 >"$out/st.stdout" | grep -o "Collected : [0-9]*" | sed "s/Collected : /$label\tspeedtest1\t/")
    fi
}
export -f run
export out label inputs
xargs -P ${JOBS:-4} -L 1 bash -c 'run $0 $1' < "$out/list" | sort -k2,2
