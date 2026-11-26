#!/bin/bash
# bp-v3.sh: the head 5b292b1da (a conditional on a spliced line leaves a skipped group) as the 9700X job builds it: the
# functions' sizes against b753417b4's binary, CI's instruction check and the object.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q "$D/v7.bundle" splice-exp2 || exit 1
cd "$D/work" || exit 1
git checkout -q -- . 2>/dev/null; git checkout -q --detach 5b292b1da || exit 1
EXCLUSIVE_TITLE="#3577 direct path: build the head 5b292b1da" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-v7.log" 2>&1
st=$?; echo "build head status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
cp build/compiler "$D/bins/compiler-v7-head"; chmod +x "$D/bins/compiler-v7-head"
for fn in fast_lex_one fast_pp_skip_rest_of_line fast_pp_skip_inactive; do echo "$fn: v2 $(objdump -d --no-show-raw-insn --disassemble=$fn $D/bins/compiler-v2-head | grep -c '^ '), head $(objdump -d --no-show-raw-insn --disassemble=$fn $D/bins/compiler-v7-head | grep -c '^ ')"; done
EXCLUSIVE_TITLE="#3577 direct path: the head's instruction check" ~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1; D=$2
  printf "%s  %s\n" 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
  taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" 2>&1 | grep -E "^instructions|failures"
  for t in compiler-v2-head compiler-v7-head; do echo "$t: $(taskset -c 2 perf stat -r 5 -e instructions:u,cycles:u $D/bins/$t -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-v7.o 2>&1 | grep -E "instructions|cycles" | awk "{print \$1}" | tr "\n" " ")"; done
  echo "head object $(sha256sum /tmp/3577-claude-v7.o | cut -c1-16)"
' x "$sqlite" "$D"
echo DONE
