#!/bin/bash
# #3577 round 15: the push family's cost (abl-push.patch fixed), and IBS op samples of 200 compiles each of the merge
# queue's tip (base, 8e4d32879) and the merge c6f3d8122 with main's answers (mid), which compile main's tokens.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: round 15, IBS against the merge queue's tip" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
mkdir -p "$D/abl"
for t in base mid; do echo "$t $(git -C $D/$t log --oneline -1 | cut -c1-40) $(git -C $D/$t status -s | wc -l) changed"; done
cd "$D/work" || exit 1
git checkout -q -- . && git checkout -q --detach c6f3d8122 && git apply "$D/answers-merge.patch" && git apply "$D/abl-push.patch" || exit 1
BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/abl/build-push2.log" 2>&1
echo "build push: $? $(tail -1 "$D/abl/build-push2.log" | cut -c1-60)"
objcopy --strip-debug build/compiler "$D/abl/push" && "$D/abl/push" --version > /dev/null || { echo "NO COMPILER push"; exit 1; }
git checkout -q -- .
BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/abl/build-work2.log" 2>&1
echo "build work back: $? $(tail -1 "$D/abl/build-work2.log" | cut -c1-60)"
cd "$D" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; D=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  cd "$D/work"
  for n in push; do echo "== $n $(taskset -c 2 "$D/abl/$n" measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | grep -o "median is [0-9]* user instructions")"; done
  for n in answers2 base2; do :; done
  cd "$D"
  for t in base mid; do
    (cd $t && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 250000 -o ../pibs16-$t.data -- bash -c "for i in \$(seq 200); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' m16 "$sqlite" "$D" > m16.out 2>&1
echo "hold status $?"
cat m16.out
rm -f "$D/abl/push"
for t in base mid; do
  perf report -q -i pibs16-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > ibs16-$t.txt
  perf report -q -i pibs16-$t.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > ibs16-lines-$t.txt
done
wc -l ibs16-*.txt
echo DONE
