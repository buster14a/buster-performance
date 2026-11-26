set -euo pipefail
phase=$1
out="$(realpath -m followup-9700x/3630)"
work="$(realpath -m followup-3630-programs)"
inputs="$PWD/program-inputs"
scripts="$inputs/scripts/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p "$out" "$work"
if [[ "$phase" == build ]]; then
    printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
    common=(--tier1 -fno-asynchronous-unwind-tables -march=znver5 -c)
    lua_names=(lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua)
    for side in base pr3630; do
        mkdir -p "$work/$side"
        "$side/build/compiler" "${common[@]}" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$inputs" "$work/speedtest1-unity.c" -o "$work/$side/speedtest1.o"
        lua_objects=()
        for name in "${lua_names[@]}"; do
            object="$work/$side/$name.o"
            "$side/build/compiler" "${common[@]}" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "$inputs/lua-5.4.8/src/$name.c" -o "$object"
            lua_objects+=("$object")
        done
        sha256sum "$side/build/compiler" "$work/$side"/*.o >> "$out/identity.txt"
        for pad in 0 16 32 48; do
            printf '.text\n.balign 64\n.space %s, 0x90\n.section .note.GNU-stack,"",@progbits\n' "$pad" | clang -x assembler -c - -o "$work/pad.o"
            clang -no-pie -o "$work/$side/speedtest1-$pad" "$work/pad.o" "$work/$side/speedtest1.o" -lm
            clang -no-pie -o "$work/$side/lua-$pad" "$work/pad.o" "${lua_objects[@]}" -lm -ldl
            nm -n "$work/$side/speedtest1-$pad" | awk '$3 == "sqlite3VdbeExec"' >> "$out/$side-placements.txt"
            nm -n "$work/$side/lua-$pad" | awk '$3 == "luaV_execute"' >> "$out/$side-placements.txt"
        done
    done
    exit 0
fi
pad=$phase
printf '%s\n' 'pad workload round side user_cycles user_instructions' > "$out/pad-$pad.txt"
cat /proc/loadavg > "$out/pad-$pad-load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/pad-$pad-load-before.txt"
sqlite_args=(--memdb --shrink-memory --reprepare --size 5 --heap 40000000 64 --testset mix1)
for side in base pr3630; do
    taskset -c 2 "$work/$side/speedtest1-$pad" --verify "${sqlite_args[@]}" > "$out/$side-$pad-verify.txt"
    grep -E 'Verification|[0-9]+ bytes of' "$out/$side-$pad-verify.txt" > "$out/$side-$pad-verify-digest.txt"
done
cmp "$out/base-$pad-verify-digest.txt" "$out/pr3630-$pad-verify-digest.txt"
for round in 0 1 2 3 4 5 6; do
    order=(base pr3630)
    if (( round % 2 )); then order=(pr3630 base); fi
    for workload in speedtest1 calls tables strings arithmetic closures; do
        for side in "${order[@]}"; do
            binary="$work/$side/lua-$pad"
            args=("$scripts/$workload.lua")
            if [[ "$workload" == speedtest1 ]]; then binary="$work/$side/speedtest1-$pad"; args=("${sqlite_args[@]}"); fi
            log="$out/$pad-$workload-$round-$side"
            (cd "$scripts" && taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u -o "$log.csv" -- "$binary" "${args[@]}") > "$log.out"
            counters=$(awk -F, '$3 ~ /^(cycles|instructions):u$/ && $1 ~ /^[0-9]+$/ { v[$3] = $1 }
                END { if (length(v) != 2) exit 1; print v["cycles:u"], v["instructions:u"] }' "$log.csv")
            printf '%s %s %s %s %s\n' "$pad" "$workload" "$round" "$side" "$counters" >> "$out/pad-$pad.txt"
        done
        if [[ "$workload" != speedtest1 ]]; then cmp "$out/$pad-$workload-$round-base.out" "$out/$pad-$workload-$round-pr3630.out"; fi
    done
done
cat /proc/loadavg > "$out/pad-$pad-load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/pad-$pad-load-after.txt"
