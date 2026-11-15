#!/bin/bash
# programs.sh SPEC...: speedtest1 and Lua by each SPEC's --tier1 (Release), each in several placements, since a change of
# code moves every later function and one layout cannot tell that from the change: speedtest1 (the frozen sqlite3.c and
# speedtest1.c as one unit) as one object linked by cc after a padding object of 0, 528, ..., 3,696 bytes of nops (eight
# shifts); Lua as an object per unit, linked by cc in four orders of its 33 units (the list rotated by 0, 8, 16 and 24).
# A SPEC is NAME=TREE[,VARIABLE=VALUE...][,+FLAG...]: TREE's compiler with those environment variables (#2541 step 2's
# experiment switches) and extra flags. #2541 step 1's programs.sh, by spec. Run inside one hold of the lock.
# scratch/NAME/{speedtest1-SHIFT,lua-ORDER}; results/programs/NAME-*.txt.
set -u
cd "$(dirname "$0")"
out=$PWD/results/programs
mkdir -p "$out"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
inputs=$HOME/buster-fast-bench/138-tier1-quality-claude/inputs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
units=(lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib
       lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua)
for spec in "$@"; do
    tree_name=${spec%%=*}
    IFS=, read -r -a items <<< "${spec#*=}"
    compiler=$PWD/${items[0]}/build/compiler
    variables=(); flags=()
    for item in "${items[@]:1}"; do case $item in +*) flags+=("${item#+}") ;; *) variables+=("$item") ;; esac; done
    tree=$tree_name
    work=$PWD/scratch/$tree
    rm -rf "$work"; mkdir -p "$work/lua-objects"
    printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
    status=0
    echo "$spec" > "$out/$tree-spec.txt"
    taskset -c 2 env "${variables[@]}" "$compiler" --tier1 "${flags[@]}" -fno-asynchronous-unwind-tables --tier1-report -c \
        -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$inputs" \
        -o "$work/speedtest1.o" "$work/speedtest1-unity.c" > "$out/$tree-speedtest1-report.txt" 2>&1 || status=1
    for shift in 0 528 1056 1584 2112 2640 3168 3696; do
        printf '.text\n.skip %d, 0x90\n' "$shift" > "$work/pad-$shift.s"
        cc -c -o "$work/pad-$shift.o" "$work/pad-$shift.s" || status=1
        cc -o "$work/speedtest1-$shift" "$work/pad-$shift.o" "$work/speedtest1.o" -lm || status=1
    done
    : > "$out/$tree-lua-report.txt"
    for u in "${units[@]}"; do
        echo "$spec" > "$out/$tree-spec.txt"
    taskset -c 2 env "${variables[@]}" "$compiler" --tier1 "${flags[@]}" -fno-asynchronous-unwind-tables --tier1-report -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX \
            -o "$work/lua-objects/$u.o" "$inputs/lua-5.4.8/src/$u.c" >> "$out/$tree-lua-report.txt" 2>&1 || status=1
    done
    count=${#units[@]}
    for order in 0 8 16 24; do
        objects=()
        for i in $(seq 0 $((count - 1))); do objects+=("$work/lua-objects/${units[$(((i + order) % count))]}.o"); done
        cc -o "$work/lua-$order" "${objects[@]}" -lm -ldl || status=1
    done
    (cd "$work" && sha256sum speedtest1.o speedtest1-* lua-[0-9]*) > "$out/$tree-builds.sha256"
    size -A "$work/speedtest1.o" | awk '$1 == ".text" { print "speedtest1.o .text " $2 }' >> "$out/$tree-builds.sha256"
    size -t "$work"/lua-objects/*.o | awk '$NF == "(TOTALS)" { print "lua objects text " $1 }' >> "$out/$tree-builds.sha256"
    echo "status $status" >> "$out/$tree-builds.sha256"
done
