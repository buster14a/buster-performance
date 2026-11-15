#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #1398 step 5's 9700X record: Tier 0's splice of callees with several returns and results in memory, on step 3's head
# (base) and step 5's (head), each built Release at znver5 without -g. main.c with -DBUSTER_COMPLETE_DRIVER=1 (CI's
# --symbols unit), its -c object by each tree and by clang -O0; -c of main.c and of the frozen sqlite3.c timed by
# time-runs under ab (base, head, base-again); and the head's sources self-built at Tier 0 by each compiler
# (tools/ci/selfhost.c's bootstrap, without -g) against clang's Release build: benchmark-lexer, benchmark-refinement and
# benchmark-files. The lock is taken per timed run; each self-host's unit compiles take one hold, about a minute.
set -u
export EXCLUSIVE_OWNER=claude-1398
export EXCLUSIVE_TITLE="#1398 step 5 Tier 0: splice several returns and memory results; 9700X record"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/1398"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/1398-claude-s5
base_sha=$1
head_sha=$2
phases=${3:-trees,objects,compile,selfhost}
out=$root/results
mkdir -p "$out"
progress() { echo "$(date -u +%FT%TZ) $*" >> "$out/progress.log"; }
busy() { { echo "== $1"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$out/busy.txt"; }
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
B=$root/base
H=$root/head
CB=$root/compiler-base
CH=$root/compiler-head
if [[ $phases == *trees* ]]; then
    { echo "base $base_sha"; echo "head $head_sha"; echo "host $(uname -n) $(nproc) cpus, $(grep -m1 'model name' /proc/cpuinfo)"; echo "kernel $(uname -r)"; clang --version | head -1; } > "$out/environment.txt"
    test -d "$root/corpus" || { (cd "$H" && bash tools/ci/fetch-corpus.sh "$root/corpus" > "$out/corpus.log" 2>&1) || { progress "corpus failed"; exit 1; }; }
    progress "corpus ready"
    for t in base head; do
        d=$B; sha=$base_sha; c=$CB
        [ $t = head ] && { d=$H; sha=$head_sha; c=$CH; }
        git -C "$d" checkout -q --detach "$sha" || { progress "checkout $t failed"; exit 1; }
        (cd "$d" && "$lock" ./build.sh --config Release > "$out/build-$t.log" 2>&1) || { progress "build $t failed"; exit 1; }
        cp "$d/build/compiler" "$c"
        progress "built $t $(git -C "$d" rev-parse HEAD)"
    done
fi
for c in "$CB" "$CH"; do test -x "$c" || { progress "missing $c"; exit 1; }; done
flags=()
mapfile -d '' all < <(cd "$H" && ./build.sh print-compile-flags --config Release)
for f in "${all[@]}"; do
    case "$f" in -O3|-Wall|-Werror) ;; *) flags+=("$f") ;; esac
done
printf '%s\n' "${flags[@]}" > "$out/flags.txt"
if [[ $phases == *objects* ]]; then
    O=$out/objects
    mkdir -p "$O"
    cd "$H"
    "$lock" bash -c 'CB=$1; CH=$2; O=$3; shift 3
        for v in base head; do c=$CB; [ $v = head ] && c=$CH; "$c" --lanes 1 "$@" -DBUSTER_COMPLETE_DRIVER=1 -c -o "$O/main-$v.o" src/buster/compiler/main.c 2> "$O/main-$v.err"; echo "$v exit=$?" >> "$O/status.txt"; done
        clang -O0 "$@" -DBUSTER_COMPLETE_DRIVER=1 -c -o "$O/main-clang-O0.o" src/buster/compiler/main.c 2> "$O/main-clang.err"; echo "clang-O0 exit=$?" >> "$O/status.txt"' _ "$CB" "$CH" "$O" "${flags[@]}"
    for v in base head clang-O0; do
        echo "$v bytes=$(stat -c %s "$O/main-$v.o") local_functions=$(nm "$O/main-$v.o" | grep -c ' t ') text=$(size -A "$O/main-$v.o" | awk '$1==".text"{print $2}')" >> "$O/sizes.txt"
        nm "$O/main-$v.o" | awk '$2=="t"{print $3}' | sort > "$O/main-$v.local"
    done
    rm -f "$O"/*.o
    progress "objects done"
fi
if [[ $phases == *compile* ]]; then
    T=$out/compile
    mkdir -p "$T"
    cd "$H"
    S=$root/corpus
    sqlite=(--target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$S/headers/usr/lib/clang/23/include" -isystem "$S/headers/usr/local/include" -isystem "$S/headers/usr/include" "$S/sqlite/sqlite3.c")
    builds=(--build base "$CB" --build head "$CH" --build base-again "$CB")
    "$CH" ab --rounds 3 --cpu 2 --lock "$lock" "$CH" -- time-runs --runs 5 --copies 3 "${builds[@]}" --list --lanes 1 -c -o /dev/shm/claude-1398-sqlite.o "${sqlite[@]}" > "$T/sqlite.log" 2>&1
    echo "exit=$?" >> "$T/sqlite.log"
    "$CH" ab --rounds 3 --cpu 2 --lock "$lock" "$CH" -- time-runs --runs 2 --copies 2 "${builds[@]}" --list --lanes 1 "${flags[@]}" -DBUSTER_COMPLETE_DRIVER=1 -c -o /dev/shm/claude-1398-main.o src/buster/compiler/main.c > "$T/main.log" 2>&1
    echo "exit=$?" >> "$T/main.log"
    rm -f /dev/shm/claude-1398-sqlite.o /dev/shm/claude-1398-main.o
    progress "compile done"
fi
if [[ $phases == *selfhost* ]]; then
    D=$out/selfhost
    mkdir -p "$D"
    cd "$H"
    mapfile -d '' sources < <(./build.sh print-sources)
    for v in base head; do
        c=$CB
        [ $v = head ] && c=$CH
        rm -rf "$root/self-$v"
        mkdir -p "$root/self-$v"
        # Every unit in one hold, each unit's time recorded inside it, and the link.
        "$lock" bash -c 'times=$1; compiler=$2; directory=$3; n=$4; shift 4; flags=("${@:1:$n}"); shift $n; objects=(); for s in "$@"; do start=$EPOCHREALTIME; "$compiler" --lanes 1 "${flags[@]}" -c -o "$directory/$(basename "$s" .c).o" "$s"; status=$?; echo "$start $EPOCHREALTIME $status $s" >> "$times"; [ $status -eq 0 ] || exit 1; objects+=("$directory/$(basename "$s" .c).o"); done; clang -no-pie -o "$directory/compiler" "${objects[@]}" -lm -ldl -lpthread' _ "$D/$v-unit-times.txt" "$c" "$root/self-$v" "${#flags[@]}" "${flags[@]}" "${sources[@]}" 2>> "$D/$v-units.err" || progress "selfhost $v failed"
        progress "selfhost $v built"
    done
    clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$root/predefines.h"
    for round in 1 2; do
        for v in clang base head; do
            c="$root/self-$v/compiler"
            [ "$v" = clang ] && c=$CH
            test -x "$c" || continue
            [ "$v" = clang ] && [ $round = 2 ] && continue
            busy "selfhost $v lexer $round"
            "$lock" taskset -c 2 "$c" benchmark-lexer src > "$D/$v-benchmark-lexer-$round.log" 2>&1
            echo "exit=$?" >> "$D/$v-benchmark-lexer-$round.log"
            busy "selfhost $v refinement $round"
            "$lock" taskset -c 2 "$c" benchmark-refinement --only refine_tokens_fused src > "$D/$v-benchmark-refinement-$round.log" 2>&1
            echo "exit=$?" >> "$D/$v-benchmark-refinement-$round.log"
            busy "selfhost $v files $round"
            "$lock" taskset -c 2 "$c" benchmark-files --lanes 1 --cpus 2 --runs 7 -march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/predefines.h" src/buster/compiler/main.c > "$D/$v-benchmark-files-$round.log" 2>&1
            echo "exit=$?" >> "$D/$v-benchmark-files-$round.log"
        done
    done
    progress "selfhost done"
fi
progress "all done"
echo done > "$out/DONE"
