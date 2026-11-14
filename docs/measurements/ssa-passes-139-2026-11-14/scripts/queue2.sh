#!/bin/bash
# queue2.sh STEP...: #139's 9700X runs at the PR's head against main (buster#139), each step its own hold of the lock,
# pinned to CPU 2. head/ and main/ are worktrees of repo at the PR's head and at its base.
#   build-head, build-main  Release (znver5, BUSTER_DEBUG_INFO=0), copied to compiler-head-COMMIT and compiler-main-COMMIT
#   identity   head's --tier1 --tier1-passes=-merge against main's --tier1: speedtest1's unit and Lua's 33 units, cmp'd
#   passes     benchmark-ir-source --passes on the frozen sqlite3.c (each pass by both versions)
#   compile    time-runs of --tier1 --lanes 1 -c sqlite3.c with each --tier1-passes= variant, 11 runs
#   compile-ab time-runs of main's and head's --tier1 --lanes 1 -c sqlite3.c, and Tier 0's, 11 runs
#   programsN  measure-tier1-programs with --tier1-passes= variants (N = 1..5)
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-139 EXCLUSIVE_TITLE="Solve 139" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/139
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
lock=$HOME/buster-fast-bench/exclusive.sh
mkdir -p logs scratch
head=$(git -C head rev-parse --short=9 HEAD)
main=$(git -C main rev-parse --short=9 HEAD)
hc=$PWD/compiler-head-$head
mc=$PWD/compiler-main-$main
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
# The driver's options for the frozen sqlite3.c; benchmark-ir-source takes --no-default-config too, which it drops.
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
        -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
receipt='echo "receipt: $(head -1 /var/lib/buster-9700x/owner) at $(date -u +%FT%TZ)"'
q() { printf "'%s' " "$@"; }
for step in "$@"; do
    log=logs/$step-$head.txt
    case $step in
    build-head|build-main)
        tree=${step#build-}
        out=$hc; [ $tree = main ] && out=$mc
        (cd $tree && $lock bash -c "$receipt; env BUSTER_DEBUG_INFO=0 BUSTER_HOST_ARCH=znver5 ./build.sh --config Release") > "$log" 2>&1
        cp $tree/build/compiler "$out" && sha256sum "$out" >> "$log"
        ;;
    identity)
        rm -rf scratch/identity; mkdir -p scratch/identity
        printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > scratch/identity/speedtest1-unity.c
        script="$receipt; cd scratch/identity; status=0"
        for build in main head; do
            c=$mc; extra=""; [ $build = head ] && { c=$hc; extra="--tier1-passes=-merge"; }
            script="$script; mkdir -p $build && taskset -c 2 '$c' --tier1 $extra -fno-asynchronous-unwind-tables -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' -I'$PWD/inputs' -o $build/speedtest1.o speedtest1-unity.c || status=1"
            for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
                script="$script; taskset -c 2 '$c' --tier1 $extra -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $build/$s.o '$PWD/inputs/lua-5.4.8/src/$s.c' || status=1"
            done
        done
        script="$script; for o in main/*.o; do cmp \$o head/\$(basename \$o) || status=1; done; echo identity status \$status; sha256sum main/*.o head/*.o"
        $lock bash -c "$script" > "$log" 2>&1
        ;;
    passes)
        $lock bash -c "$receipt; taskset -c 2 '$hc' benchmark-ir-source --passes $(q "${driver[@]:0:2}") --no-default-config $(q "${driver[@]:2}") '$sqlite/sqlite3.c'" > "$log" 2>&1
        ;;
    compile)
        lists=()
        for v in none -sccp -dce -cfg -merge -inline +gvn +licm +sroa +all -all; do
            option=(); [ "$v" != none ] && option=("--tier1-passes=$v")
            lists+=(--list --tier1 "${option[@]}" --lanes 1 -c -o scratch/sqlite3-compile.o "${driver[@]}" "$sqlite/sqlite3.c")
        done
        $lock bash -c "$receipt; taskset -c 2 '$hc' time-runs --runs 11 --warmups 1 --executable '$hc' $(q "${lists[@]}")" > "$log" 2>&1
        ;;
    compile-ab)
        lists=(--list --tier1 --lanes 1 -c -o scratch/sqlite3-ab.o "${driver[@]}" "$sqlite/sqlite3.c" --list --lanes 1 -c -o scratch/sqlite3-ab.o "${driver[@]}" "$sqlite/sqlite3.c")
        $lock bash -c "$receipt; taskset -c 2 '$hc' time-runs --runs 11 --warmups 1 --build main '$mc' --build head '$hc' $(q "${lists[@]}")" > "$log" 2>&1
        ;;
    programs1|programs2|programs3|programs4|programs5)
        case $step in
        programs1) variants=(--variant --tier1-passes=-merge --variant --tier1-passes=-sccp) ;;
        programs2) variants=(--variant --tier1-passes=-dce --variant --tier1-passes=-cfg) ;;
        programs3) variants=(--variant --tier1-passes=-inline --variant --tier1-passes=+gvn) ;;
        programs4) variants=(--variant --tier1-passes=+licm --variant --tier1-passes=+sroa) ;;
        programs5) variants=(--variant --tier1-passes=+all --variant --tier1-passes=-all) ;;
        esac
        rm -rf "scratch/$step"; mkdir -p "scratch/$step"
        $lock bash -c "$receipt; taskset -c 2 '$hc' measure-tier1-programs --runs 11 --clang clang --tcc \$(command -v tcc) --sqlite '$sqlite' --speedtest '$PWD/inputs' --lua '$PWD/inputs/lua-5.4.8/src' --scripts '$PWD/inputs/scripts' --directory '$PWD/scratch/$step' $(q "${variants[@]}")" > "$log" 2>&1
        ;;
    esac
    echo "$step exit $? $(date -u +%FT%TZ)" >> logs/queue2.txt
done
echo "queue2 done $(date -u +%FT%TZ)" >> logs/queue2.txt
