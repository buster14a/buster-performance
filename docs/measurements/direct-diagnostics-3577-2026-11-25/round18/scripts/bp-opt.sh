#!/bin/bash
# bp-opt.sh TAG SHA: build SHA in the work tree as the 9700X job builds and measure it against main (base tree) in one hold.
TAG=$1; H=$2
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cd "$D/repo" || exit 1
git fetch -q origin main claude/adoring-goodall-mr1480 || exit 1
git fetch -q "$D/$TAG.bundle" || exit 1
git -C ../work checkout -q -- . 2>/dev/null
git -C ../work checkout -q --detach $H || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: the checks' rewrite ($TAG)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
echo "== build work $(git log --oneline -1 | cut -c1-60) $(date -u +%H:%M:%S)"
BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$TAG.log" 2>&1
echo "status $? $(date -u +%H:%M:%S)"; tail -1 "$D/build-$TAG.log"
./build/compiler --version > /dev/null || { echo "NO COMPILER"; exit 1; }
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | grep -iE "^instructions:"
  taskset -c 2 ./build/compiler measure-compile --runs 21 --reference ../base/build/compiler -- "${flags[@]}" 2>&1 | grep -E "^(default|compiler): median"
  taskset -c 2 ./build/compiler "${flags[@]}" -o ../$2.o && echo "object $(sha256sum ../$2.o | cut -c1-16)"
' x "$sqlite" "$TAG"
echo DONE
