#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #1398's 9700X record (step 3 and the measurements #1770 left), on main and the PR's final head, each built Release at
# znver5 without -g: the issue's four kernels by Tier 0 (inlined, --tier0-no-inline), --tier1, clang -O0 and -O2; main.c
# with -DBUSTER_COMPLETE_DRIVER=1 (CI's --symbols unit), its -c object by each tree and by clang -O0; -c of main.c and of
# the frozen sqlite3.c timed by time-runs under ab (base, head, base-again); and the compiler self-built by the head at
# Tier 0 with and without inlining (tools/ci/selfhost.c's bootstrap, without -g) against clang's Release build:
# benchmark-lexer, benchmark-refinement and benchmark-files. The lock is taken per timed run; the kernels' builds take one
# short hold together, and each self-host's unit compiles one, about a minute, as about 30 sessions queue for it.
set -u
export EXCLUSIVE_OWNER=claude-1398
export EXCLUSIVE_TITLE="#1398 Tier 0: leave out spliced always_inline callees; 9700X record"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/2793"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/1398-claude
base_sha=$1
head_sha=$2
phases=${3:-trees,kernels,objects,compile,selfhost}
out=$root/results
mkdir -p "$out"
progress() { echo "$(date -u +%FT%TZ) $*" >> "$out/progress.log"; }
busy() { { echo "== $1"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$out/busy.txt"; }
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
H=$root/head
CB=$root/compiler-base
CH=$root/compiler-head
if [[ $phases == *trees* ]]; then
    { echo "base $base_sha"; echo "head $head_sha"; echo "host $(uname -n) $(nproc) cpus, $(grep -m1 'model name' /proc/cpuinfo)"; echo "kernel $(uname -r)"; clang --version | head -1; } > "$out/environment.txt"
    test -x "$CB" || { progress "missing base compiler"; exit 1; }
    git -C "$H" fetch -q origin "$head_sha" && git -C "$H" checkout -q --detach "$head_sha"
    (cd "$H" && "$lock" ./build.sh --config Release > "$out/build-head.log" 2>&1) || { progress "build head failed"; exit 1; }
    cp "$H/build/compiler" "$CH"
    progress "built head $(git -C "$H" rev-parse HEAD)"
fi
for c in "$CB" "$CH"; do test -x "$c" || { progress "missing $c"; exit 1; }; done
if [[ $phases == *kernels* ]]; then
    K=$out/kernels
    mkdir -p "$K"
    cp "$root/kernels.c" "$root/driver.c" "$K/"
    cd "$K"
    "$lock" bash -c 'set -e; CH=$1; CB=$2
        "$CH" -march=znver5 -c -o k-tier0.o kernels.c
        "$CH" -march=znver5 --tier0-no-inline -c -o k-tier0-no-inline.o kernels.c
        "$CH" -march=znver5 --tier1 -c -o k-tier1.o kernels.c
        "$CB" -march=znver5 -c -o k-base-tier0.o kernels.c
        clang -O0 -march=znver5 -c -o k-clang-O0.o kernels.c
        clang -O2 -march=znver5 -c -o k-clang-O2.o kernels.c
        for v in tier0 tier0-no-inline tier1 base-tier0 clang-O0 clang-O2; do clang -O2 -o "bench-$v" driver.c "k-$v.o"; done' _ "$CH" "$CB" > builds.log 2>&1 || progress "kernel builds failed"
    for v in tier0 tier0-no-inline tier1 base-tier0 clang-O0 clang-O2; do
        objdump -d --no-show-raw-insn "k-$v.o" | awk '/^[0-9a-f]+ <k_/{p=1} /^[0-9a-f]+ <[^k]/{p=0} p' | sed 's/^ *[0-9a-f]*://' > "k-$v.kernels.s"
        nm "k-$v.o" > "k-$v.nm"
    done
    cmp -s k-tier0.kernels.s k-base-tier0.kernels.s && echo "kernels' code: head = base" > same.txt || echo "kernels' code: head != base" > same.txt
    for round in 1 2 3; do
        for v in tier0 tier0-no-inline tier1 clang-O0 clang-O2; do
            test -x "bench-$v" || continue
            busy "kernels $v round $round"
            "$lock" taskset -c 2 "./bench-$v" > "run-$v-$round.txt" 2>&1
            echo "exit=$?" >> "run-$v-$round.txt"
        done
    done
    progress "kernels done"
fi
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
        "$CH" --lanes 1 "$@" -g -DBUSTER_COMPLETE_DRIVER=1 -c -o "$O/main-head-g.o" src/buster/compiler/main.c 2> "$O/main-head-g.err"; echo "head-g exit=$?" >> "$O/status.txt"
        clang -O0 "$@" -DBUSTER_COMPLETE_DRIVER=1 -c -o "$O/main-clang-O0.o" src/buster/compiler/main.c 2> "$O/main-clang.err"; echo "clang-O0 exit=$?" >> "$O/status.txt"' _ "$CB" "$CH" "$O" "${flags[@]}"
    for v in base head head-g clang-O0; do
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
    "$CH" ab --rounds 3 --cpu 2 --lock "$lock" "$CH" -- time-runs --runs 5 --copies 3 "${builds[@]}" --list --lanes 1 -c -o /tmp/claude-1398-sqlite.o "${sqlite[@]}" > "$T/sqlite.log" 2>&1
    echo "exit=$?" >> "$T/sqlite.log"
    "$CH" ab --rounds 3 --cpu 2 --lock "$lock" "$CH" -- time-runs --runs 2 --copies 2 "${builds[@]}" --list --lanes 1 "${flags[@]}" -DBUSTER_COMPLETE_DRIVER=1 -c -o /tmp/claude-1398-main.o src/buster/compiler/main.c > "$T/main.log" 2>&1
    echo "exit=$?" >> "$T/main.log"
    rm -f /tmp/claude-1398-sqlite.o /tmp/claude-1398-main.o
    progress "compile done"
fi
if [[ $phases == *selfhost* ]]; then
    D=$out/selfhost
    mkdir -p "$D"
    cd "$H"
    mapfile -d '' sources < <(./build.sh print-sources)
    for v in tier0 tier0-no-inline; do
        option=()
        [ "$v" = tier0-no-inline ] && option=(--tier0-no-inline)
        rm -rf "$root/self-$v"
        mkdir -p "$root/self-$v"
        objects=()
        for s in "${sources[@]}"; do
            objects+=("$root/self-$v/$(basename "$s" .c).o")
        done
        # Every unit in one hold, each unit's time recorded inside it, and the link.
        "$lock" bash -c 'times=$1; compiler=$2; directory=$3; option=$4; n=$5; shift 5; flags=("${@:1:$n}"); shift $n; objects=(); for s in "$@"; do start=$EPOCHREALTIME; "$compiler" --lanes 1 "${flags[@]}" $option -c -o "$directory/$(basename "$s" .c).o" "$s"; status=$?; echo "$start $EPOCHREALTIME $status $s" >> "$times"; [ $status -eq 0 ] || exit 1; objects+=("$directory/$(basename "$s" .c).o"); done; clang -no-pie -o "$directory/compiler" "${objects[@]}" -lm -ldl -lpthread' _ "$D/$v-unit-times.txt" "$CH" "$root/self-$v" "${option[*]}" "${#flags[@]}" "${flags[@]}" "${sources[@]}" 2>> "$D/$v-units.err" || progress "selfhost $v failed"
        progress "selfhost $v built"
    done
    clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$root/predefines.h"
    for v in clang tier0 tier0-no-inline; do
        c="$root/self-$v/compiler"
        [ "$v" = clang ] && c=$CH
        test -x "$c" || continue
        busy "selfhost $v lexer"
        "$lock" taskset -c 2 "$c" benchmark-lexer src > "$D/$v-benchmark-lexer.log" 2>&1
        echo "exit=$?" >> "$D/$v-benchmark-lexer.log"
        busy "selfhost $v refinement"
        "$lock" taskset -c 2 "$c" benchmark-refinement --only refine_tokens_fused src > "$D/$v-benchmark-refinement.log" 2>&1
        echo "exit=$?" >> "$D/$v-benchmark-refinement.log"
        busy "selfhost $v files"
        "$lock" taskset -c 2 "$c" benchmark-files --lanes 1 --cpus 2 --runs 7 -march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/predefines.h" src/buster/compiler/main.c > "$D/$v-benchmark-files.log" 2>&1
        echo "exit=$?" >> "$D/$v-benchmark-files.log"
    done
    progress "selfhost done"
fi
progress "all done"
echo done > "$out/DONE"
