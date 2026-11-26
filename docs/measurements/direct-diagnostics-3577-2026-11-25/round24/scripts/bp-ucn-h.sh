#!/bin/bash
# bp-ucn-h.sh: variant h 498c67a31 (the UCN letters with the test of the block's other events), against the merge,
# 9700X job builds, against the merge 3be61f2a6 and the head f8c4f8e1e built by bp-ucn.sh: perf stat rotation (3 rounds
# of 7) and the objects; the skip loop's instructions in each binary.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q "$D/ucn-g.bundle" ucn-g || exit 1
cd "$D/work" || exit 1
git checkout -q -- . 2>/dev/null; git checkout -q --detach 498c67a31 || exit 1
EXCLUSIVE_TITLE="#3577 direct path: build the UCN variant h" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-u-h.log" 2>&1
st=$?; echo "build h status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
cp build/compiler "$D/bins/compiler-u-h"; chmod +x "$D/bins/compiler-u-h"
"$D/bins/compiler-u-h" --version > /dev/null || { echo "binary h does not run"; exit 1; }
for t in merge head g h; do echo "$t skip loop: $(objdump -d --no-show-raw-insn --disassemble=fast_pp_skip_inactive $D/bins/compiler-u-$t | grep -c '^ ') instructions"; done
objdump -d --no-show-raw-insn --disassemble=fast_pp_skip_inactive $D/bins/compiler-u-h | grep '^ ' > $D/skip-h.s
EXCLUSIVE_TITLE="#3577 direct path: measure the UCN variant h" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; D=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for r in 1 2 3; do
    for t in merge head g h; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u $D/bins/compiler-u-$t "${flags[@]}" -o /tmp/3577-claude-u.o 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  taskset -c 2 $D/bins/compiler-u-h "${flags[@]}" -o /tmp/3577-claude-u-h.o && echo "h object $(sha256sum /tmp/3577-claude-u-h.o | cut -c1-16) $(readelf -p .comment /tmp/3577-claude-u-h.o | grep -o "buster[a-z -]*")"
' x "$sqlite" "$D"
EXCLUSIVE_TITLE="#3577 direct path: profile the UCN variant h" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; D=$2
  for t in merge h; do
    taskset -c 2 perf record -q -e cycles:u -c 100000 -o /tmp/3577-claude-prof-$t.data -- bash -c "for i in \$(seq 100); do $D/bins/compiler-u-$t -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /tmp/3577-claude-prof.o; done" 2>&1 | tail -2
  done
' x "$sqlite" "$D"
for t in merge h; do
  perf report -q -i /tmp/3577-claude-prof-$t.data --stdio --sort sym 2>/dev/null | awk -v T=$t 'NF >= 3 {gsub("%","",$1); print T"\t"$1"\t"$NF}' > $D/prof-h-$t.tsv
  echo "$t: $(perf report -i /tmp/3577-claude-prof-$t.data --stdio --sort comm 2>/dev/null | grep -m1 Samples) skip $(grep -P '\tfast_pp_skip_inactive$' $D/prof-h-$t.tsv | cut -f2)%"
done
rm -f /tmp/3577-claude-prof-*.data
echo DONE
