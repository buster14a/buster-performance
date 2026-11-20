#!/bin/bash
# #2924 C12c-3: the checker's scalar schedule deleted. head = the deletion, base = the digests commit before it (the twins present),
# both on main 198a76539, from the bundle beside this script; Release, every run under the lock, timings on CPU 2.
# stderr.sh: run.sh's objects step again for its stderr alone, kept in logs/stderr/ and compared without exclusive.sh's
# lines (the lock's wait lines, which one run has and another hasn't): run.sh removed them before comparing them so.
# 1. Objects and stderr: -c --lanes 1 of sqlite3.c, Lua, musl's units and buster's main.c (the complete driver) by base
#    and head, with the warnings on (-Wall -Wextra), by default, with --scalar (head's --scalar keeps the other areas'
#    twins over vector warnings) and with --tier1; and with no warning option, by default. Every object and stderr
#    compared with base's of the same mode.
# 2. ab, three rounds, around time-runs (three runs of three copies) of base, head and base again: -c --lanes 1 -Wall
#    -Wextra of sqlite3.c, Lua's units and musl's units, and -c --lanes 1 of sqlite3.c with no warning option.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core, C12c-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs/stderr
: > logs/stderr-status.txt
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
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
objects=/dev/shm/claude-2924-c12c3-stderr
rm -rf "$objects"
for mode in wall scalar tier1 default; do
    case $mode in wall) opt=("${W[@]}");; scalar) opt=(--scalar "${W[@]}");; tier1) opt=(--tier1 "${W[@]}");; default) opt=();; esac
    for tree in base head; do
        exe="$D/compilers/$tree"
        cur=$objects/$mode/$tree
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster"
        (cd "$cur/sqlite" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/sqlite.err"); echo "objects $mode $tree sqlite: $?" >> logs/stderr-status.txt
        (cd "$cur/lua" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "$lua"/*.c > /dev/null 2> "$cur/lua.err"); echo "objects $mode $tree lua: $?" >> logs/stderr-status.txt
        (cd "$cur/musl" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${M[@]}" "${files[@]}" > /dev/null 2> "$cur/musl.err"); echo "objects $mode $tree musl: $?" >> logs/stderr-status.txt
        (cd "$cur/buster" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${B[@]}" -o main.o > /dev/null 2> "$cur/buster.err"); echo "objects $mode $tree buster: $?" >> logs/stderr-status.txt
    done
    for tree in base head; do for t in sqlite lua musl buster; do
        grep -v '^exclusive.sh: ' "$objects/$mode/$tree/$t.err" > "logs/stderr/$mode-$tree-$t.err"
        echo "lock lines $mode $tree $t: $(grep -c '^exclusive.sh: ' "$objects/$mode/$tree/$t.err")" >> logs/stderr-status.txt
    done; done
    for t in sqlite lua musl buster; do
        if cmp -s "logs/stderr/$mode-base-$t.err" "logs/stderr/$mode-head-$t.err"; then v=same; else v=DIFFER; fi
        echo "stderr $mode $t without the lock's lines: $(wc -l < "logs/stderr/$mode-base-$t.err") lines base, $(wc -l < "logs/stderr/$mode-head-$t.err") head, $v" >> logs/stderr-status.txt
    done
done
rm -rf "$objects"
echo done >> logs/stderr-status.txt
