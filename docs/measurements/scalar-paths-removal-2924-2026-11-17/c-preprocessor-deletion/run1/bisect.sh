#!/bin/bash
# The deletion's stages, built Release (the compiler alone) and counted: instructions and user cycles of -E of musl's
# units, Lua's units and sqlite3.c, perf stat, three runs each, a fresh copy each, under the lock on CPU 2.
set -uo pipefail
D=~/buster-fast-bench/2924-c-df-claude/c12apr
cd $D
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the preprocessor, C12a" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p bisect
git -C src-head fetch -q "$D/bisect.bundle" "+refs/heads/c12a-bisect-*:refs/heads/c12a-bisect-*" || { echo "bundle failed" >> bisect/status.txt; exit 1; }
for s in s1 s2 s3 s4 s5 s6; do
    if [ ! -d bisect/src-$s ]; then git clone -q --shared src-head bisect/src-$s; fi
    git -C bisect/src-$s fetch -q "$D/src-head" "+refs/heads/c12a-bisect-$s:refs/heads/c12a-bisect-$s"
    git -C bisect/src-$s checkout -q --detach c12a-bisect-$s
    (cd bisect/src-$s && $L timeout -k 5 1500 ./build.sh --config Release --target compiler > "$D/bisect/build-$s.log" 2>&1); echo "build $s: $?" >> bisect/status.txt
    cp bisect/src-$s/build/compiler bisect/compiler-$s
done
cp compilers/base bisect/compiler-s0
cp compilers/head bisect/compiler-s7
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$D/../c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
for run in 1 2 3; do
    for s in s0 s1 s2 s3 s4 s5 s6 s7; do
        for list in musl lua sqlite; do
            case $list in
                musl) args=(-E "${M[@]}" "${files[@]}");;
                lua) args=(-E "$lua"/*.c);;
                sqlite) args=(-E "${S[@]}");;
            esac
            cp bisect/compiler-$s bisect/run-exe
            $L timeout -k 5 600 taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o bisect/stat-$s-$list-$run.csv ./bisect/run-exe "${args[@]}" > /dev/null 2>> bisect/stderr.txt
            echo "stat $s $list $run: $?" >> bisect/status.txt
            rm -f bisect/run-exe
        done
    done
done
echo done >> bisect/status.txt
