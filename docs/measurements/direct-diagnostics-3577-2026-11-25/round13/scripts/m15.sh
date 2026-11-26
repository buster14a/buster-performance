#!/bin/bash
# #3577 round 14: what each family of checks costs on the merge (c6f3d8122) with main's answers, by switching it off
# (abl-*.patch, measurement only; each compiles sqlite3.c to the answers build's object), and what the checks' wider
# FastVal and FastExprOp cost main's code (abl-layout.patch on the queue's tip). Each variant built as the 9700X job
# builds in mid (or base, for the layout), under the lock; then one locked run of the job's baseline step on each.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: round 14, the checks' families" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
mkdir -p "$D/abl"
build() { # TREE NAME PATCH...
  local t=$1 n=$2; shift 2
  cd "$D/$t" || exit 1
  git checkout -q -- . && git checkout -q --detach "$( [ "$t" = base ] && echo 8e4d32879 || echo c6f3d8122 )" || exit 1
  for p in "$@"; do git apply "$D/$p" || { echo "PATCH $p failed"; exit 1; }; done
  BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/abl/build-$n.log" 2>&1
  echo "build $n: $? $(tail -1 "$D/abl/build-$n.log" | cut -c1-80)"
  objcopy --strip-debug build/compiler "$D/abl/$n" && "$D/abl/$n" --version > /dev/null || { echo "NO COMPILER $n"; exit 1; }
}
build base base
build base layout abl-layout.patch
build mid answers answers-merge.patch
for v in seq push ops binops binops_all conv cond unary allexpr; do build mid "$v" answers-merge.patch "abl-$v.patch"; done
# The trees back to round 13's states: base the queue's tip, mid the merge with the answers.
build base base2
build mid answers2 answers-merge.patch
cd "$D/work" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1; A=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for n in base layout answers seq push ops binops binops_all conv cond unary allexpr; do
    echo "== $n $(taskset -c 2 "$A/$n" measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | grep -o "median is [0-9]* user instructions")"
    taskset -c 2 "$A/$n" "${flags[@]}" -o "$A/$n.o" && echo "   object $(sha256sum "$A/$n.o" | cut -c1-16) $(readelf -p .comment "$A/$n.o" | grep -o "buster.*" | head -1)"
  done
' m15 "$sqlite" "$D/abl" > ../m15.out 2>&1
echo "status $?"
rm -f "$D"/abl/base "$D"/abl/layout "$D"/abl/answers "$D"/abl/base2 "$D"/abl/answers2 "$D"/abl/seq "$D"/abl/push "$D"/abl/ops "$D"/abl/binops "$D"/abl/binops_all "$D"/abl/conv "$D"/abl/cond "$D"/abl/unary "$D"/abl/allexpr
echo DONE
