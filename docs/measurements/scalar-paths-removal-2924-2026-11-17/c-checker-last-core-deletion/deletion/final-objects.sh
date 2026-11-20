#!/bin/bash
# #2924 C12c-3 core-3, the PR's own commits: objects and stderr of head eb180c560 (the deletion, rebased onto main
# bdba7f0ea, with the append's dead varargs term removed) against base e4b4f2a61 (its tests commit), as run.sh compares
# them, without the timings; from core3-final.bundle. Release, every run under the lock.
# The lists and modes are run.sh's (sqlite3.c, Lua, musl, main.c, sqlite3.c with --deferred-bodies on CPUs 2 to 9, and gate3's
# fixture of 256 groups; -Wall -Wextra, --scalar, --tier1 and no warning option).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs-final compilers-final
: > logs-final/status.txt
for tree in base head; do
    if [ ! -d src-f$tree ]; then git clone -q --shared $D/../c7gate/src src-f$tree || exit 1; fi
    git -C src-f$tree fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs-final/status.txt; exit 1; }
    git -C src-f$tree fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7 || { echo "fetch branch failed" >> logs-final/status.txt; exit 1; }
    git -C src-f$tree fetch -q "$D/core3-final.bundle" 'refs/heads/*:refs/remotes/bundle/*' || { echo "bundle failed" >> logs-final/status.txt; exit 1; }
done
git -C src-fbase checkout -q --detach e4b4f2a61 && git -C src-fbase reset -q --hard
git -C src-fhead checkout -q --detach eb180c560 && git -C src-fhead reset -q --hard
for tree in base head; do
    (cd src-f$tree && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs-final/build-$tree.log" 2>&1) || { echo "build $tree failed" >> logs-final/status.txt; exit 1; }
    cp src-f$tree/build/compiler compilers-final/$tree
done
echo "built base $(git -C src-fbase rev-parse --short HEAD) head $(git -C src-fhead rev-parse --short HEAD)" >> logs-final/status.txt
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
B=(-march=znver5 -I"$D/src-fbase/src" -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_COMPLETE_DRIVER=1 "$D/src-fbase/src/buster/compiler/main.c")
W=(-Wall -Wextra)
objects=/dev/shm/claude-2924-c12c33f-objects
F=$D/../c12k-gate3/fixtures/overloadable-256.c
rm -rf "$objects"
for mode in wall scalar tier1 default; do
    case $mode in wall) opt=("${W[@]}");; scalar) opt=(--scalar "${W[@]}");; tier1) opt=(--tier1 "${W[@]}");; default) opt=();; esac
    for tree in base head; do
        exe="$D/compilers-final/$tree"
        cur=$objects/$mode/$tree
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster"
        (cd "$cur/sqlite" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/sqlite.err"); echo "objects $mode $tree sqlite: $?" >> logs-final/status.txt
        (cd "$cur/lua" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "$lua"/*.c > /dev/null 2> "$cur/lua.err"); echo "objects $mode $tree lua: $?" >> logs-final/status.txt
        (cd "$cur/musl" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${M[@]}" "${files[@]}" > /dev/null 2> "$cur/musl.err"); echo "objects $mode $tree musl: $?" >> logs-final/status.txt
        (cd "$cur/buster" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${B[@]}" -o main.o > /dev/null 2> "$cur/buster.err"); echo "objects $mode $tree buster: $?" >> logs-final/status.txt
        mkdir -p "$cur/dsqlite" "$cur/fixture"
        (cd "$cur/dsqlite" && $L timeout -k 5 1500 taskset -c 2-9 "$exe" -c --lanes 4 --deferred-bodies "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/dsqlite.err"); echo "objects $mode $tree dsqlite: $?" >> logs-final/status.txt
        (cd "$cur/fixture" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "$F" -o fixture.o > /dev/null 2> "$cur/fixture.err"); echo "objects $mode $tree fixture: $?" >> logs-final/status.txt
    done
    n=0; d=0
    while read -r f; do
        n=$((n+1)); cmp -s "$objects/$mode/base/$f" "$objects/$mode/head/$f" || { d=$((d+1)); echo "differs $mode: $f" >> logs-final/objects-compare.txt; }
    done < <(cd "$objects/$mode/base" && find . -name '*.o' | sort)
    echo "objects $mode: $n compared, $d differ" >> logs-final/status.txt
    mkdir -p logs-final/stderr
    for t in sqlite lua musl buster dsqlite fixture; do
        for tree in base head; do grep -vE '^exclusive.sh: |^  (title|link): ' "$objects/$mode/$tree/$t.err" > "logs-final/stderr/$mode-$tree-$t.err"; done
        if cmp -s "logs-final/stderr/$mode-base-$t.err" "logs-final/stderr/$mode-head-$t.err"; then v=same; else v=DIFFER; fi
        echo "stderr $mode $t without the lock's message: $(wc -l < "logs-final/stderr/$mode-base-$t.err") lines base, $(wc -l < "logs-final/stderr/$mode-head-$t.err") head, $v" >> logs-final/status.txt
    done
done
# Each mode's objects against the warnings-on default's (base): one set of bytes whatever the path; tier1 the control.
for mode in scalar tier1 default; do
    n=0; d=0
    while read -r f; do
        n=$((n+1)); cmp -s "$objects/wall/base/$f" "$objects/$mode/head/$f" || d=$((d+1))
    done < <(cd "$objects/wall/base" && find . -name '*.o' | sort)
    echo "objects $mode head against wall base: $n compared, $d differ" >> logs-final/status.txt
done
rm -rf "$objects"
echo done >> logs-final/status.txt
