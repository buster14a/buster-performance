#!/bin/bash
# #3577 after the warning families: where the check cost goes. head = fdadcc225 with main 86427a9f5's __has_* answers
# (answers-fdadcc225.patch, measurement only), so that it compiles main's tokens; base = main 86427a9f5. Build head
# as the 9700X job builds (BUSTER_HOST_ARCH=znver5, Release) under the lock; then in one locked run: both objects,
# measure-compile 21 interleaved, IBS op samples of 200 compiles each.
D=$HOME/buster-fast-bench/3577-claude
cd "$D/head" || exit 1
git checkout -q -- . && git checkout -q --detach fdadcc225739f22a5267ec89bd52f1d229554d1f || exit 1
git apply "$D/answers-fdadcc225.patch" || exit 1
git diff --stat
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: IBS attribution of the check cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
echo "== build $(date -u +%H:%M:%S)"
BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-ans.log" 2>&1
echo "build status $? $(date -u +%H:%M:%S)"; tail -1 "$D/build-ans.log"
./build/compiler --version > /dev/null || { echo NO COMPILER; exit 1; }
cd "$D" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for t in base head; do (cd $t && taskset -c 2 ./build/compiler "${flags[@]}" -o ../ans-$t.o); done
  echo "== measure"
  (cd head && taskset -c 2 ./build/compiler measure-compile --runs 21 --reference ../base/build/compiler -- "${flags[@]}")
  for t in base head; do
    (cd $t && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 250000 -o ../pibs9-$t.data -- bash -c "for i in \$(seq 200); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' > ans.out 2>&1
echo "hold status $? $(date -u +%H:%M:%S)"
cat ans.out
for t in base head; do echo "$t $(sha256sum ans-$t.o | cut -c1-16) $(readelf -p .comment ans-$t.o | grep -o "buster.*" | head -1)"; done
for sec in .text .data .rodata .bss .strtab .symtab; do
  a=$(objcopy -O binary --only-section=$sec ans-base.o /dev/stdout 2>/dev/null | sha256sum | cut -c1-16)
  b=$(objcopy -O binary --only-section=$sec ans-head.o /dev/stdout 2>/dev/null | sha256sum | cut -c1-16)
  echo "$sec base $a head $b $([ "$a" = "$b" ] && echo same || echo DIFFERS)"
done
for t in base head; do
  perf report -q -i pibs9-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > ibs9-$t.txt
  perf report -q -i pibs9-$t.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > ibs9-lines-$t.txt
done
wc -l ibs9-*.txt
echo DONE
