#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #2841's 9700X record: Tier 0's register homes weighted by loop depth. Base is main before the change, head the PR;
# both Release at znver5 without -g. Phases:
# - kernels: #1398's four intrinsic kernels (kernels.c, driver.c by clang -O2) by base's and head's Tier 0;
# - objects: main.c's -c object (CI's --symbols unit) by base and head, with and without --tier0-inline-shapes;
# - compile: -c of the frozen sqlite3.c and of main.c by time-runs under ab: base, head, head --tier0-inline-shapes,
#   base-again;
# - selfhost: the head's sources self-built at Tier 0 (tools/ci/selfhost.c's bootstrap, without -g) by base and head,
#   each with and without --tier0-inline-shapes, then benchmark-lexer, benchmark-refinement and benchmark-files by each,
#   twice;
# - programs: speedtest1 (#136's flags and options, --memdb) and Lua 5.4.8 (the five scripts of measure-tier1-programs)
#   by base's and head's Tier 0, by time-runs under ab.
# The lock is taken per timed run: a round of time-runs, a self-built compiler's three benchmarks, each self-host's
# unit compiles, one hold each (under about 2 minutes), as about 20 sessions queue for it.
set -u
export EXCLUSIVE_OWNER=claude-2841
export EXCLUSIVE_TITLE="#2841 Tier 0 register homes weighted by loop depth; 9700X record"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2841"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/2841-claude
base_sha=$1
head_sha=$2
phases=${3:-trees,kernels,objects,compile,selfhost,programs}
out=$root/results
mkdir -p "$out"
progress() { echo "$(date -u +%FT%TZ) $*" >> "$out/progress.log"; }
busy() { { echo "== $1"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$out/busy.txt"; }
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
B=$root/base
H=$root/head
CB=$root/compiler-base
CH=$root/compiler-head
I=$root/inputs
if [[ $phases == *trees* ]]; then
    { echo "base $base_sha"; echo "head $head_sha"; echo "host $(uname -n) $(nproc) cpus, $(grep -m1 'model name' /proc/cpuinfo)"; echo "kernel $(uname -r)"; clang --version | head -1; } > "$out/environment.txt"
    for t in base head; do
        d=$B; sha=$base_sha; c=$CB
        [ $t = head ] && { d=$H; sha=$head_sha; c=$CH; }
        test -d "$d" || git clone -q https://github.com/buster14a/buster "$d"
        git -C "$d" fetch -q origin "$sha" && git -C "$d" checkout -q --detach "$sha" || { progress "checkout $t failed"; exit 1; }
        (cd "$d" && "$lock" ./build.sh --config Release > "$out/build-$t.log" 2>&1) || { progress "build $t failed"; exit 1; }
        cp "$d/build/compiler" "$c"
        progress "built $t $(git -C "$d" rev-parse HEAD)"
    done
    test -d "$root/corpus" || { (cd "$H" && bash tools/ci/fetch-corpus.sh "$root/corpus" > "$out/corpus.log" 2>&1) || { progress "corpus failed"; exit 1; }; }
    mkdir -p "$I"
    test -f "$I/speedtest1.c" || curl -sSfL -o "$I/speedtest1.c" https://raw.githubusercontent.com/sqlite/sqlite/ccc132c5be20ab5c755c97a08d06b1b592fef330/test/speedtest1.c
    test -f "$I/lua-5.4.8.tar.gz" || curl -sSfL -o "$I/lua-5.4.8.tar.gz" https://www.lua.org/ftp/lua-5.4.8.tar.gz
    { echo "b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675  $I/speedtest1.c"; echo "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae  $I/lua-5.4.8.tar.gz"; } | sha256sum -c > "$out/inputs.txt" 2>&1 || { progress "inputs' hashes differ"; exit 1; }
    test -d "$I/lua-5.4.8" || tar -xzf "$I/lua-5.4.8.tar.gz" -C "$I"
    test -d "$I/performance" || (cd "$H" && bash tools/ci/fetch-performance.sh 818cfbbc0be238da287c16d8e2a91fd7275cf228 docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua "$I/performance" > "$out/performance.log" 2>&1) || { progress "scripts failed"; exit 1; }
    progress "inputs ready"
fi
for c in "$CB" "$CH"; do test -x "$c" || { progress "missing $c"; exit 1; }; done
flags=()
mapfile -d '' all < <(cd "$H" && ./build.sh print-compile-flags --config Release)
for f in "${all[@]}"; do
    case "$f" in -O3|-Wall|-Werror|-g) ;; *) flags+=("$f") ;; esac
done
printf '%s\n' "${flags[@]}" > "$out/flags.txt"
if [[ $phases == *kernels* ]]; then
    K=$out/kernels
    mkdir -p "$K"
    cp "$root/kernels.c" "$root/driver.c" "$K/"
    cd "$K" || exit 1
    "$lock" bash -c 'set -e; CH=$1; CB=$2
        "$CB" -march=znver5 -c -o k-base.o kernels.c
        "$CH" -march=znver5 -c -o k-head.o kernels.c
        clang -O0 -march=znver5 -c -o k-clang-O0.o kernels.c
        for v in base head clang-O0; do clang -O2 -o "bench-$v" driver.c "k-$v.o"; done' _ "$CH" "$CB" > builds.log 2>&1 || progress "kernel builds failed"
    for v in base head clang-O0; do
        objdump -d --no-show-raw-insn "k-$v.o" | awk '/^[0-9a-f]+ <k_/{p=1} /^[0-9a-f]+ <[^k]/{p=0} p' | sed 's/^ *[0-9a-f]*://' > "k-$v.kernels.s"
    done
    cmp -s k-base.kernels.s k-head.kernels.s && echo "kernels' code: head = base" > same.txt || echo "kernels' code: head != base" > same.txt
    for round in 1 2 3; do
        for v in base head clang-O0; do
            busy "kernels $v round $round"
            "$lock" taskset -c 2 "./bench-$v" > "run-$v-$round.txt" 2>&1
            echo "exit=$?" >> "run-$v-$round.txt"
        done
    done
    rm -f "${K:?}"/bench-* "${K:?}"/*.o
    progress "kernels done"
fi
if [[ $phases == *objects* ]]; then
    O=$out/objects
    mkdir -p "$O"
    cd "$H" || exit 1
    "$lock" bash -c 'CB=$1; CH=$2; O=$3; shift 3
        for v in base head base-shapes head-shapes; do c=$CB; case $v in head*) c=$CH;; esac; x=(); case $v in *shapes) x=(--tier0-inline-shapes);; esac
            "$c" --lanes 1 "${x[@]}" "$@" -DBUSTER_COMPLETE_DRIVER=1 -c -o "$O/main-$v.o" src/buster/compiler/main.c 2> "$O/main-$v.err"; echo "$v exit=$?" >> "$O/status.txt"; done' _ "$CB" "$CH" "$O" "${flags[@]}"
    for v in base head base-shapes head-shapes; do
        echo "$v bytes=$(stat -c %s "$O/main-$v.o") local_functions=$(nm "$O/main-$v.o" | grep -c ' t ') text=$(size -A "$O/main-$v.o" | awk '$1==".text"{print $2}')" >> "$O/sizes.txt"
    done
    rm -f "${O:?}"/*.o
    progress "objects done"
fi
if [[ $phases == *compile* ]]; then
    T=$out/compile
    mkdir -p "$T"
    cd "$H" || exit 1
    S=$root/corpus
    printf '#!/bin/sh\nexec %s --tier0-inline-shapes "$@"\n' "$CH" > "$root/compiler-head-shapes"
    chmod +x "$root/compiler-head-shapes"
    sqlite=(--target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$S/headers/usr/lib/clang/23/include" -isystem "$S/headers/usr/local/include" -isystem "$S/headers/usr/include" "$S/sqlite/sqlite3.c")
    builds=(--build base "$CB" --build head "$CH" --build head-shapes "$root/compiler-head-shapes" --build base-again "$CB")
    # One hold a round (about 30 s each), as about 20 sessions queue for the lock: a hold per run took hours.
    for round in 1 2 3; do
        busy "compile sqlite round $round"
        "$lock" taskset -c 2 "$CH" time-runs --runs 5 --copies 3 "${builds[@]}" --list --lanes 1 -c -o /dev/shm/claude-2841-sqlite.o "${sqlite[@]}" > "$T/sqlite-$round.log" 2>&1
        echo "exit=$?" >> "$T/sqlite-$round.log"
        busy "compile main round $round"
        "$lock" taskset -c 2 "$CH" time-runs --runs 2 --copies 2 "${builds[@]}" --list --lanes 1 "${flags[@]}" -DBUSTER_COMPLETE_DRIVER=1 -c -o /dev/shm/claude-2841-main.o src/buster/compiler/main.c > "$T/main-$round.log" 2>&1
        echo "exit=$?" >> "$T/main-$round.log"
    done
    rm -f /dev/shm/claude-2841-sqlite.o /dev/shm/claude-2841-main.o
    progress "compile done"
fi
if [[ $phases == *selfhost* ]]; then
    D=$out/selfhost
    mkdir -p "$D"
    cd "$H" || exit 1
    mapfile -d '' sources < <(./build.sh print-sources)
    variants=(base head base-shapes head-shapes)
    for v in "${variants[@]}"; do
        c=$CB
        case $v in head*) c=$CH;; esac
        x=""
        case $v in *shapes) x=--tier0-inline-shapes;; esac
        rm -rf "${root:?}/self-$v"
        mkdir -p "$root/self-$v"
        "$lock" bash -c 'times=$1; compiler=$2; directory=$3; extra=$4; n=$5; shift 5; flags=("${@:1:$n}"); shift $n; objects=(); for s in "$@"; do start=$EPOCHREALTIME; "$compiler" --lanes 1 $extra "${flags[@]}" -c -o "$directory/$(basename "$s" .c).o" "$s"; status=$?; echo "$start $EPOCHREALTIME $status $s" >> "$times"; [ $status -eq 0 ] || exit 1; objects+=("$directory/$(basename "$s" .c).o"); done; clang -no-pie -o "$directory/compiler" "${objects[@]}" -lm -ldl -lpthread' _ "$D/$v-unit-times.txt" "$c" "$root/self-$v" "$x" "${#flags[@]}" "${flags[@]}" "${sources[@]}" 2>> "$D/$v-units.err" || progress "selfhost $v failed"
        nm -S --size-sort "$root/self-$v/c_lexer_benchmark.o" | grep -E ' (tokenize_|scan_lines|write_chunk)' > "$D/$v-lexer-symbols.txt"
        progress "selfhost $v built"
    done
    clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$root/predefines.h"
    for round in 1 2; do
        for v in "${variants[@]}"; do
            c="$root/self-$v/compiler"
            test -x "$c" || continue
            busy "selfhost $v round $round"
            # The three benchmarks of one build in one hold.
            "$lock" bash -c 'c=$1; D=$2; v=$3; round=$4; predefines=$5
                taskset -c 2 "$c" benchmark-lexer src > "$D/$v-benchmark-lexer-$round.log" 2>&1; echo "exit=$?" >> "$D/$v-benchmark-lexer-$round.log"
                taskset -c 2 "$c" benchmark-refinement --only refine_tokens_fused src > "$D/$v-benchmark-refinement-$round.log" 2>&1; echo "exit=$?" >> "$D/$v-benchmark-refinement-$round.log"
                taskset -c 2 "$c" benchmark-files --lanes 1 --cpus 2 --runs 7 -march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$predefines" src/buster/compiler/main.c > "$D/$v-benchmark-files-$round.log" 2>&1; echo "exit=$?" >> "$D/$v-benchmark-files-$round.log"' _ "$c" "$D" "$v" "$round" "$root/predefines.h" 2> "$D/$v-hold-$round.err"
        done
    done
    progress "selfhost done"
fi
if [[ $phases == *programs* ]]; then
    P=$out/programs
    W=$root/programs
    mkdir -p "$P" "$W"
    S=$root/corpus/sqlite
    printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$W/speedtest1-unity.c"
    lua=()
    for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do lua+=("$I/lua-5.4.8/src/$s.c"); done
    "$lock" bash -c 'set -e; CB=$1; CH=$2; W=$3; S=$4; I=$5; shift 5
        for v in base head; do c=$CB; [ $v = head ] && c=$CH
            "$c" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$S" -I"$I" -o "$W/speedtest1-$v" "$W/speedtest1-unity.c" -lm
            "$c" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o "$W/lua-$v" "$@" -lm -ldl
        done' _ "$CB" "$CH" "$W" "$S" "$I" "${lua[@]}" > "$P/builds.log" 2>&1 || { progress "program builds failed"; exit 1; }
    sha256sum "$W"/speedtest1-base "$W"/speedtest1-head "$W"/lua-base "$W"/lua-head > "$P/hashes.txt"
    scripts=$I/performance/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
    cd "$W" || exit 1
    for v in base head; do
        "$lock" taskset -c 2 "./speedtest1-$v" --verify --memdb --shrink-memory --reprepare --size 5 --heap 40000000 64 --testset mix1 2>&1 | tail -3 > "$P/verify-$v.txt"
        for s in calls tables strings arithmetic closures; do (cd "$scripts" && "$lock" taskset -c 2 "$W/lua-$v" "$s.lua") > "$P/lua-$v-$s.out" 2>&1; done
    done
    for s in calls tables strings arithmetic closures; do cmp -s "$P/lua-base-$s.out" "$P/lua-head-$s.out" && echo "$s same" >> "$P/outputs.txt" || echo "$s DIFFERENT" >> "$P/outputs.txt"; done
    for round in 1 2; do
        busy "speedtest1 round $round"
        "$lock" taskset -c 2 "$CH" time-runs --runs 5 --build base "$W/speedtest1-base" --build head "$W/speedtest1-head" --list --memdb --shrink-memory --reprepare --size 5 --heap 40000000 64 --testset mix1 > "$P/speedtest1-$round.log" 2>&1
        echo "exit=$?" >> "$P/speedtest1-$round.log"
        busy "lua round $round"
        "$lock" bash -c 'CH=$1; W=$2; P=$3; scripts=$4; round=$5
            for s in calls tables strings arithmetic closures; do
                taskset -c 2 "$CH" time-runs --runs 5 --build base "$W/lua-base" --build head "$W/lua-head" --list "$scripts/$s.lua" > "$P/lua-$s-$round.log" 2>&1; echo "exit=$?" >> "$P/lua-$s-$round.log"
            done' _ "$CH" "$W" "$P" "$scripts" "$round" 2> "$P/lua-hold-$round.err"
    done
    progress "programs done"
fi
progress "all done"
echo done > "$out/DONE"
