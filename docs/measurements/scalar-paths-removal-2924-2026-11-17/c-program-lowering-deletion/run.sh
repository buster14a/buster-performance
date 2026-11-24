#!/bin/bash
# #2924 C12c-4 (a): the lowering's twins deleted (c_check_program_lower.c). head = the deletion, base = the tests commit
# before it (the twins present), from branch claude/2924-program-lowering; Release, every run under the lock, timings on
# CPU 2 (the deferred list on CPUs 2 to 9).
# (Trimmed for the shared lock's queue: the modes and timed lists in the loops below.)
# 1. Objects and stderr: -c --lanes 1 of sqlite3.c, Lua's units, musl's units and buster's main.c (the complete driver)
#    by base and head, in five modes: -Wall -Wextra, none, --scalar, --tier1 and -g; and -c --lanes 4 --deferred-bodies
#    of sqlite3.c in each. Every object and stderr compared with base's of the same mode.
# 2. ab, three rounds, around time-runs (three runs of three copies) of base, head and base again: -c --lanes 1 of
#    sqlite3.c, Lua's units and musl's units; -c --lanes 1 -g of sqlite3.c; -c --lanes 4 --deferred-bodies of sqlite3.c.
# Usage: run.sh BASE HEAD [objects|time|all]; compilers already built (compilers/head) are reused.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
BASE=$1
HEAD=$2
WHAT=${3:-all}
export EXCLUSIVE_OWNER=claude-2924-c12c4 EXCLUSIVE_TITLE="buster #2924: checker program and lowering twins (C12c-4)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
G=~/buster-fast-bench/2924-c-df-claude
mkdir -p logs compilers
for tree in base head; do
    if [ ! -d src-$tree ]; then git clone -q --shared $G/c7gate/src src-$tree || exit 1; fi
    git -C src-$tree fetch -q https://github.com/buster14a/buster claude/2924-program-lowering || { echo "fetch failed" >> logs/status.txt; exit 1; }
done
if [ "$WHAT" != time ] && [ ! -x compilers/head ]; then
    : > logs/status.txt
    git -C src-base checkout -q --detach "$BASE" && git -C src-base reset -q --hard
    git -C src-head checkout -q --detach "$HEAD" && git -C src-head reset -q --hard
    for tree in base head; do
        (cd src-$tree && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$tree.log" 2>&1) || { echo "build $tree failed" >> logs/status.txt; exit 1; }
        cp src-$tree/build/compiler compilers/$tree
    done
    echo "built base $(git -C src-base rev-parse --short HEAD) head $(git -C src-head rev-parse --short HEAD)" >> logs/status.txt
fi
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$G/c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(-march=znver5 -I"$D/src-base/src" -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_COMPLETE_DRIVER=1 "$D/src-base/src/buster/compiler/main.c")
W=(-Wall -Wextra)
if [ "$WHAT" != time ]; then
objects=/dev/shm/claude-2924-c12c4a-objects
rm -rf "$objects"
for mode in wall scalar tier1 g; do
    case $mode in wall) opt=("${W[@]}");; scalar) opt=(--scalar "${W[@]}");; tier1) opt=(--tier1 "${W[@]}");; default) opt=();; g) opt=(-g);; esac
    for tree in base head; do
        exe="$D/compilers/$tree"
        cur=$objects/$mode/$tree
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster" "$cur/dsqlite"
        (cd "$cur/sqlite" && $L timeout -k 5 600 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/sqlite.err"); echo "objects $mode $tree sqlite: $?" >> logs/status.txt
        (cd "$cur/lua" && $L timeout -k 5 600 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "$lua"/*.c > /dev/null 2> "$cur/lua.err"); echo "objects $mode $tree lua: $?" >> logs/status.txt
        (cd "$cur/musl" && $L timeout -k 5 600 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${M[@]}" "${files[@]}" > /dev/null 2> "$cur/musl.err"); echo "objects $mode $tree musl: $?" >> logs/status.txt
        (cd "$cur/buster" && $L timeout -k 5 600 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${B[@]}" -o main.o > /dev/null 2> "$cur/buster.err"); echo "objects $mode $tree buster: $?" >> logs/status.txt
        (cd "$cur/dsqlite" && $L timeout -k 5 600 taskset -c 2-9 "$exe" -c --lanes 4 --deferred-bodies "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/dsqlite.err"); echo "objects $mode $tree dsqlite: $?" >> logs/status.txt
    done
    n=0; d=0
    while read -r f; do
        n=$((n+1)); cmp -s "$objects/$mode/base/$f" "$objects/$mode/head/$f" || { d=$((d+1)); echo "differs $mode: $f" >> logs/objects-compare.txt; }
    done < <(cd "$objects/$mode/base" && find . -name '*.o' | sort)
    echo "objects $mode: $n compared, $d differ" >> logs/status.txt
    mkdir -p logs/stderr
    for t in sqlite lua musl buster dsqlite; do
        for tree in base head; do grep -vE '^exclusive.sh: |^  (title|link): ' "$objects/$mode/$tree/$t.err" > "logs/stderr/$mode-$tree-$t.err"; done
        if cmp -s "logs/stderr/$mode-base-$t.err" "logs/stderr/$mode-head-$t.err"; then v=same; else v=DIFFER; fi
        echo "stderr $mode $t without the lock's message: $(wc -l < "logs/stderr/$mode-base-$t.err") lines base, $(wc -l < "logs/stderr/$mode-head-$t.err") head, $v" >> logs/status.txt
    done
done
rm -rf "$objects"
fi
if [ "$WHAT" != objects ]; then
out=/dev/shm/claude-2924-c12c4a
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
for list in sqlite lua musl; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
        sqlite-g) args=(-c --lanes 1 -g "${S[@]}" -o "$out/sqlite3.o");;
        dsqlite) args=(-c --lanes 4 --deferred-bodies "${S[@]}" -o "$out/sqlite3.o");;
    esac
    if [ "$list" = dsqlite ]; then
        (cd "$out" && taskset -c 2-9 "$D/compilers/base" ab --rounds 3 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
            -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    else
        (cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
            -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    fi
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$out"
for tree in base head; do
    idx=$(readelf -SW compilers/$tree | sed -n 's/^ *\[ *\([0-9]*\)\] \.text\.buster_start .*/\1/p')
    readelf -sW compilers/$tree | awk -v i="$idx" '$4 == "FUNC" && $7 == i {print $8}' | sort -u > logs/start-$tree.txt
done
fi
echo "done $WHAT" >> logs/status.txt
