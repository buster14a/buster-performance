#!/bin/bash
# bp-ucn-g.sh: the gated variant b83a9671b (the UCN letters only in a block with a byte after a backslash), built as the
# 9700X job builds, against the merge 3be61f2a6 and the head f8c4f8e1e built by bp-ucn.sh: perf stat rotation (3 rounds
# of 7) and the objects; the skip loop's instructions in each binary.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q "$D/ucn-g.bundle" ucn-g || exit 1
cd "$D/work" || exit 1
git checkout -q -- . 2>/dev/null; git checkout -q --detach b83a9671b || exit 1
EXCLUSIVE_TITLE="#3577 direct path: build the gated UCN variant" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-u-g.log" 2>&1
st=$?; echo "build g status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
cp build/compiler "$D/bins/compiler-u-g"; chmod +x "$D/bins/compiler-u-g"
"$D/bins/compiler-u-g" --version > /dev/null || { echo "binary g does not run"; exit 1; }
for t in merge head g; do echo "$t skip loop: $(objdump -d --no-show-raw-insn --disassemble=fast_pp_skip_inactive $D/bins/compiler-u-$t | grep -c '^ ') instructions"; done
objdump -d --no-show-raw-insn --disassemble=fast_pp_skip_inactive $D/bins/compiler-u-g | grep '^ ' > $D/skip-g.s
EXCLUSIVE_TITLE="#3577 direct path: measure the gated UCN variant" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; D=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for r in 1 2 3; do
    for t in merge head g; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u $D/bins/compiler-u-$t "${flags[@]}" -o /tmp/3577-claude-u.o 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  taskset -c 2 $D/bins/compiler-u-g "${flags[@]}" -o /tmp/3577-claude-u-g.o && echo "g object $(sha256sum /tmp/3577-claude-u-g.o | cut -c1-16) $(readelf -p .comment /tmp/3577-claude-u-g.o | grep -o "buster[a-z -]*")"
' x "$sqlite" "$D"
echo DONE
