#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 corpus build' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1219
for build in base head; do
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/progs.sh "$S/$build/build/compiler" "$S/results/$build"
    test -x "results/$build/st-t1"
    test -x "results/$build/lua-t1"
done
mkdir -p results/clang
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash -s <<'EOF'
set -euo pipefail
cd "$S/results/clang"
flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE)
clang -O2 -c "${flags[@]}" -I"$S/corpus/sqlite" -o sqlite.o "$S/corpus/sqlite/sqlite3.c"
clang -O2 -c "${flags[@]}" -I"$S/corpus/sqlite" -o speedtest.o "$S/inputs/st/speedtest1.c"
clang -o st-t1 speedtest.o sqlite.o -lm
files=()
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do files+=("$S/inputs/lua/lua-5.4.8/src/$f.c"); done
clang -O2 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-t1 "${files[@]}" -lm -ldl
clang -O2 -o "$S/tools/gap" "$S/tools/gap.c"
EOF
sha256sum results/{base,head,clang}/{st-t1,lua-t1} > results/binaries.sha256
touch corpora.done
