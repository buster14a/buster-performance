#!/bin/bash
# measure.sh NAME: speedtest1 and Lua by base's and head's --tier1 (Release compilers), outputs checked against clang
# -O0's, then each program timed by time-runs over both builds, one hold of the 9700X's lock per program, pinned to CPU 2.
# Lua is linked in three object orders (the source order, its reverse, and a fixed shuffle), the same for both builds,
# as docs/commands/profiling.md's relinked comparison asks. Then each compiler's compile of speedtest1's unity and of
# Lua's sources, timed the same way. Results in results/NAME.
set -u
cd ~/buster-fast-bench/2823-claude
name=${1:?a name}
out=$PWD/results/$name
work=/tmp/claude-2823-$name
rm -rf "$out" "$work"; mkdir -p "$out" "$work"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
export EXCLUSIVE_OWNER=claude-2823 EXCLUSIVE_TITLE="buster #2823/#2610: Tier 1 allocation around calls" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnd67mUu2isTgj2N7JT
lock=~/buster-fast-bench/exclusive.sh
inputs=~/buster-fast-bench/138-tier1-quality-claude/inputs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
lua="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
orders=("$lua" "$(echo $lua | tr ' ' '\n' | tac | tr '\n' ' ')" "lvm ltable lstring lgc ldo lapi lcode lparser llex lfunc lobject ltm lstate lmem lzio lundump ldump ldebug lctype lopcodes lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua")
printf '%s\n' "${orders[@]}" > "$out/lua-orders.txt"
sqlite_flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -I$inputs"
{ sha256sum base/build/compiler head/build/compiler "$(command -v clang)"; git -C base rev-parse HEAD; git -C head diff | sha256sum; } > "$out/identity.txt"
git -C head diff > "$out/head.patch"
build() {
    # build TAG COMPILER-AND-OPTIONS...: Lua's objects and three links, speedtest1's executable.
    local tag=$1; shift
    mkdir -p "$work/$tag"
    for s in $lua; do "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c "$inputs/lua-5.4.8/src/$s.c" -o "$work/$tag/$s.o" || return 1; done
    for k in 0 1 2; do
        objects=""; for s in ${orders[$k]}; do objects="$objects $work/$tag/$s.o"; done
        clang -o "$work/$tag/lua$k" $objects -lm -ldl || return 1
    done
    "$@" $sqlite_flags -c "$work/speedtest1-unity.c" -o "$work/$tag/speedtest1.o" && clang -o "$work/$tag/speedtest1" "$work/$tag/speedtest1.o" -lm
}
builds() {
    build base "$PWD/base/build/compiler" --tier1 -fno-asynchronous-unwind-tables &&
    build head "$PWD/head/build/compiler" --tier1 -fno-asynchronous-unwind-tables &&
    build clang clang -O0
}
$lock bash -c "$(declare -f build builds); $(declare -p lua orders sqlite_flags inputs work); builds" > "$out/build.log" 2>&1 || { echo "builds failed" >> "$out/status.txt"; exit 1; }
(cd "$work" && sha256sum */*.o */lua? */speedtest1) > "$out/builds.sha256"
# The checks: each script's output by every Lua against clang -O0's, speedtest1's --verify hash by each build.
st="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
check() {
    for script in arithmetic calls closures strings tables; do
        (cd "$inputs/scripts" && timeout 120 "$work/clang/lua0" $script.lua) > "$work/$script.clang" 2>&1
        for tag in base head; do for k in 0 1 2; do
            (cd "$inputs/scripts" && timeout 120 "$work/$tag/lua$k" $script.lua) > "$work/$script.$tag$k" 2>&1
            cmp -s "$work/$script.clang" "$work/$script.$tag$k" && echo "same $script $tag$k" || echo "DIFFERS $script $tag$k"
        done; done
    done
    for tag in clang base head; do
        (cd "$work" && timeout 300 "$work/$tag/speedtest1" $st --verify "$work/verify.db" | grep "Verification Hash") | sed "s/^/$tag /"
    done
}
$lock bash -c "$(declare -f check); $(declare -p inputs work st); check" > "$out/check.txt" 2>&1
if grep -q DIFFERS "$out/check.txt" || [ "$(grep -c 'Verification Hash' "$out/check.txt")" != 3 ] || [ "$(grep 'Verification Hash' "$out/check.txt" | awk '{print $NF}' | sort -u | wc -l)" != 1 ]; then echo "checks failed" >> "$out/status.txt"; exit 1; fi
busy() { { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } >> "$out/busy.txt"; }
# The timings: one hold per program.
for script in arithmetic calls closures strings tables; do
    (cd "$inputs/scripts" && $lock bash -c "$(declare -f busy); $(declare -p out); busy; taskset -c 2 $PWD/head/build/compiler time-runs --runs 11 --warmups 1 --build base $work/base/lua0 --build head $work/head/lua0 --build base $work/base/lua1 --build head $work/head/lua1 --build base $work/base/lua2 --build head $work/head/lua2 --list $script.lua; busy") > "$out/time-$script.txt" 2>&1
done
(cd "$work" && $lock bash -c "$(declare -f busy); $(declare -p out); busy; taskset -c 2 $PWD/head/build/compiler time-runs --runs 11 --warmups 1 --build base $work/base/speedtest1 --build head $work/head/speedtest1 --list $st $work/time.db; busy") > "$out/time-speedtest1.txt" 2>&1
# Compile time: each compiler's --tier1 -c of speedtest1's unity, then of lvm.c and lparser.c, Lua's largest.
(cd "$work" && $lock bash -c "$(declare -f busy); $(declare -p out); busy; taskset -c 2 $PWD/head/build/compiler time-runs --runs 11 --warmups 1 --build base $PWD/base/build/compiler --build head $PWD/head/build/compiler --list --tier1 -fno-asynchronous-unwind-tables $sqlite_flags -c $work/speedtest1-unity.c -o $work/compile.o; busy") > "$out/compile-speedtest1.txt" 2>&1
(cd "$work" && $lock bash -c "$(declare -f busy); $(declare -p out); busy; taskset -c 2 $PWD/head/build/compiler time-runs --runs 21 --warmups 1 --build base $PWD/base/build/compiler --build head $PWD/head/build/compiler --list --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $inputs/lua-5.4.8/src/lvm.c -o $work/compile-lvm.o; busy") > "$out/compile-lvm.txt" 2>&1
echo done >> "$out/status.txt"
