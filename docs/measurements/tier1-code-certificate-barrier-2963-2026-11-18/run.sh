#!/bin/bash
# #2963 on the 9700X: base (main 8d4025fa with #2913's fix 38a848237 cherry-picked) against head (base + #2963's fix),
# both Release. Each compiles the pinned corpus's sqlite3.c, Lua 5.4.8 and musl's units (#2924's C7 gate's lists, one
# lane) by --tier1 -c, --tier1 -g -c and --tier1 --verify -c, each compile's standard error kept, under the lock per
# run; then musl's pthread_barrier_wait.c alone by each; then the objects compared, base against head, mode by mode
# (where both compiled); then user-mode instructions retired by -g and --verify of sqlite3.c and Lua on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2963 EXCLUSIVE_TITLE="Tier 1 code certificate: musl's full barrier (#2963)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2963
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$HOME/buster-fast-bench/claude-linker-80/inputs/lua-5.4.8/src
export LC_ALL=C
mkdir -p logs
status=logs/status.txt
: > "$status"
for tree in base head; do
    (cd "$tree" && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$tree.log" 2>&1) || { echo "build $tree failed" >> "$status"; exit 1; }
    cp "$tree/build/compiler" "compiler-$tree"
done
sha256sum compiler-base compiler-head > logs/compilers.sha256
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
muslflags=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
objects=/dev/shm/claude-2963
rm -rf "$objects"
for tree in base head; do
    for mode in plain g verify; do
        case $mode in plain) extra=();; g) extra=(-g);; verify) extra=(--verify);; esac
        out=$objects/$tree-$mode
        err=$D/logs/stderr-$tree-$mode.txt
        mkdir -p "$out/sqlite" "$out/lua" "$out/musl"
        : > "$err"
        $L timeout -k 5 1500 bash -c '
            exe=$1; out=$2; err=$3; sqlite=$4; lua=$5; shift 5
            n=$1; shift; extra=("${@:1:$n}"); shift "$n"
            (cd "$out/sqlite" && "$exe" -c --tier1 "${extra[@]}" --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o > /dev/null 2>>"$err"); echo "sqlite $?"
            (cd "$out/lua" && "$exe" -c --tier1 "${extra[@]}" --lanes 1 "$lua"/*.c > /dev/null 2>>"$err"); echo "lua $?"
            (cd "$out/musl" && "$exe" -c --tier1 "${extra[@]}" --lanes 1 "$@" > /dev/null 2>>"$err"); echo "musl $?"
        ' run "$D/compiler-$tree" "$out" "$err" "$sqlite" "$lua" "${#extra[@]}" "${extra[@]}" "${muslflags[@]}" "${files[@]}" > "logs/objects-$tree-$mode.log" 2>&1
        echo "$tree $mode: $(tr '\n' ' ' < logs/objects-$tree-$mode.log) $(grep -c 'error:' "$err") error lines, $(find "$out" -name '*.o' | wc -l) objects" >> "$status"
    done
    for mode in g verify; do
        case $mode in g) extra=-g;; verify) extra=--verify;; esac
        $L timeout -k 5 300 bash -c 'exe=$1; extra=$2; source=$3; shift 3; cd /dev/shm && "$exe" -c --tier1 "$extra" "$@" "$source" -o /dev/shm/claude-2963-barrier.o; echo "exit $?"; rm -f /dev/shm/claude-2963-barrier.o' run "$D/compiler-$tree" "$extra" "$musl/src/thread/pthread_barrier_wait.c" "${muslflags[@]}" > "logs/barrier-$tree-$mode.log" 2>&1
    done
done
for tree in base head; do
    for mode in g verify; do
        echo "pthread_barrier_wait.c $tree $mode: $(head -c 300 logs/barrier-$tree-$mode.log | tr '\n' ' ')" >> "$status"
    done
done
for mode in plain g verify; do
    n=0; d=0; missing=0
    while read -r f; do
        n=$((n+1))
        if [[ ! -f $objects/head-$mode/$f ]]; then missing=$((missing+1)); echo "$mode missing in head: $f" >> logs/objects-compare.txt; continue; fi
        cmp -s "$objects/base-$mode/$f" "$objects/head-$mode/$f" || { d=$((d+1)); echo "$mode differs: $f" >> logs/objects-compare.txt; }
    done < <(cd "$objects/base-$mode" && find . -name '*.o' | sort)
    echo "objects $mode: $n of base's compared, $d differ, $missing missing in head; head has $(cd "$objects/head-$mode" && find . -name '*.o' | wc -l)" >> "$status"
done
rm -rf "$objects"
for round in 1 2 3; do
    for tree in base head; do
        for mode in g verify; do
            case $mode in g) extra=-g;; verify) extra=--verify;; esac
            $L timeout -k 5 600 taskset -c 2 perf stat -x, -e instructions:u -o "$D/logs/instructions-$tree-$mode-$round.txt" bash -c '
                exe=$1; extra=$2; sqlite=$3; lua=$4; mkdir -p /dev/shm/claude-2963-i && cd /dev/shm/claude-2963-i
                "$exe" -c --tier1 "$extra" --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o > /dev/null 2>&1; echo "sqlite $?"
                "$exe" -c --tier1 "$extra" --lanes 1 "$lua"/*.c > /dev/null 2>&1; echo "lua $?"
                cd / && rm -rf /dev/shm/claude-2963-i
            ' run "$D/compiler-$tree" "$extra" "$sqlite" "$lua" > "logs/instructions-$tree-$mode-$round.log" 2>&1
            echo "instructions $tree $mode $round: $(tr '\n' ' ' < logs/instructions-$tree-$mode-$round.log) $(grep instructions logs/instructions-$tree-$mode-$round.txt | cut -d, -f1)" >> "$status"
        done
    done
done
date -u +%FT%TZ > logs/.done
