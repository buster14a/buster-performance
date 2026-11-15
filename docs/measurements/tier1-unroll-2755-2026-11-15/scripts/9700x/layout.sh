#!/usr/bin/env bash
# layout.sh build | layout.sh round N: whether speedtest1's and Lua's cycle changes with +unroll follow the pass or the
# code's placement, as buster-performance's tier1-load-addition-2602-2026-11-13 record tested speedtest1 (its README's
# "layout" section). The head compiler's --tier1 objects by the default passes and with --tier1-passes=+unroll, the
# options measure-tier1-programs gives them: speedtest1-unity.c's one object, cc-linked after a pad of 0, 528, 1568 or
# 2608 bytes of .text (each moves the 16-byte-aligned code to another 64-byte phase and page offset); Lua's 33 objects,
# cc-linked in six orders (the canonical one and five shuffled with seeds 1 to 5). `build` compiles, links, checks
# every executable (speedtest1's --verify hash, each Lua script's output against the first build's) and hashes them;
# `round N` runs every executable once (speedtest1 in a fresh /tmp directory, the five scripts), the builds' order
# alternating by round, on CPU 2, with perf's user cycles and instructions. Run each step under the lock.
set -u
cd "$(dirname "$0")"
B=${LAYOUT_BASE:-$HOME/buster-fast-bench/2755-claude}
COMPILER=${COMPILER:-$B/tree-head/build/compiler}
CLANG=${CLANG:-$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)}
SQLITE=${SQLITE:-$B/corpus/sqlite}
SPEEDTEST=${SPEEDTEST:-$B/programs/inputs}
LUA=${LUA:-$B/programs/inputs/lua-5.4.8/src}
SCRIPTS=${SCRIPTS:-$B/programs/evidence/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua}
OPTIONS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
PADS="0 528 1568 2608"
ORDERS="0 1 2 3 4 5"
SOURCES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
RUN=/tmp/claude-2755-layout
head -1 /var/lib/buster-9700x/owner >> holds.txt 2>/dev/null
fresh()
{
    rm -rf $RUN
    mkdir -p $RUN/tmp
}
if [ "$1" = build ]; then
    unset CPATH C_INCLUDE_PATH
    printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > speedtest1-unity.c
    for build in default unroll; do
        X=""
        [ $build = unroll ] && X="--tier1-passes=+unroll"
        $COMPILER --tier1 -fno-asynchronous-unwind-tables $X -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQLITE -I$SPEEDTEST -c -o st-$build.o speedtest1-unity.c || exit 1
        mkdir -p lua-$build
        for s in $SOURCES; do
            $COMPILER --tier1 -fno-asynchronous-unwind-tables $X -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o lua-$build/$s.o $LUA/$s.c || exit 1
        done
    done
    for pad in $PADS; do
        printf '\t.text\n\t.globl buster_layout_pad\nbuster_layout_pad:\n\t.space %d, 0xcc\n\t.section .note.GNU-stack,"",@progbits\n' $pad > pad-$pad.s
        $CLANG -c pad-$pad.s -o pad-$pad.o || exit 1
    done
    for order in $ORDERS; do
        if [ $order = 0 ]; then
            echo $SOURCES | tr ' ' '\n' > order-$order.txt
        else
            echo $SOURCES | tr ' ' '\n' | shuf --random-source=<(yes $order) > order-$order.txt
        fi
    done
    for build in default unroll; do
        for pad in $PADS; do
            $CLANG -o st-$build-p$pad pad-$pad.o st-$build.o -lm || exit 1
            fresh
            SQLITE_TMPDIR=$RUN/tmp ./st-$build-p$pad $OPTIONS --verify $RUN/speedtest1.db > verify-st-$build-p$pad.txt 2>&1
            echo "verify speedtest1 $build pad $pad status $? $(grep -i 'verification' verify-st-$build-p$pad.txt | tail -1)"
        done
        for order in $ORDERS; do
            $CLANG -o lua-$build-o$order $(sed "s|^|lua-$build/|; s|$|.o|" order-$order.txt) -lm -ldl || exit 1
            for script in arithmetic calls closures strings tables; do
                ./lua-$build-o$order $SCRIPTS/$script.lua > out-$build-o$order-$script.txt 2>&1
                status=$?
                cmp -s out-$build-o$order-$script.txt out-default-o0-$script.txt
                echo "verify lua $build order $order $script status $status differs-from-default-o0 $?"
            done
        done
    done
    sha256sum st-*-p* lua-*-o[0-9] > executables.sha256
    echo "built $(date -u +%FT%TZ)"
else
    round=$2
    order_builds="default unroll"
    [ $((round % 2)) = 0 ] && order_builds="unroll default"
    for pad in $PADS; do
        for build in $order_builds; do
            fresh
            SQLITE_TMPDIR=$RUN/tmp taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o perf.txt -- ./st-$build-p$pad $OPTIONS $RUN/speedtest1.db > /dev/null 2>&1
            s=$?
            echo "round $round speedtest1 pad $pad $build cycles $(grep cycles perf.txt | cut -d, -f1) instructions $(grep instructions perf.txt | cut -d, -f1) status $s"
        done
    done
    for order in $ORDERS; do
        for build in $order_builds; do
            for script in arithmetic calls closures strings tables; do
                taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o perf.txt -- ./lua-$build-o$order $SCRIPTS/$script.lua > /dev/null 2>&1
                s=$?
                echo "round $round lua-$script order $order $build cycles $(grep cycles perf.txt | cut -d, -f1) instructions $(grep instructions perf.txt | cut -d, -f1) status $s"
            done
        done
    done
    rm -rf $RUN
fi
