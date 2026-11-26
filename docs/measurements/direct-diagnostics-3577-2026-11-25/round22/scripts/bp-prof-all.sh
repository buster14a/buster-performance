#!/bin/bash
# bp-prof-all.sh: unthrottled profiles of the ALL arm (abl22-all 4823da71b: every #3577 check condition behind an opaque
# test), built at offset 0 in the work tree: IBS ops (every 262,144) and cycles (every 100,000), 300 compiles each, one
# hold; then per-function and per-function-and-line reports (pu-*-all.txt), as bp-prof-u.sh wrote round 21's.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
git checkout -q -- . 2>/dev/null; git checkout -q --detach 4823da71b || exit 1
EXCLUSIVE_TITLE="#3577 direct path: build the ALL arm for profiles" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-prof-all.log" 2>&1
st=$?; echo "build all status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
./build/compiler --version > /dev/null || { echo "binary does not run"; exit 1; }
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: unthrottled profiles of the ALL ablation arm" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-u.o)
  (cd work && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 262144 -o ../pu-op-all.data -- bash -c "for i in \$(seq 300); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed op"
  (cd work && taskset -c 2 perf record -q -e cycles:u -c 100000 -o ../pu-cyc-all.data -- bash -c "for i in \$(seq 300); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed cyc"
' x "$sqlite"
for k in op cyc; do
  perf report -q -i pu-$k-all.data --no-children --comm compiler --sort symbol --stdio -F overhead,sample,symbol 2>/dev/null | grep -v "^$" > pu-$k-all.txt
  perf report -q -i pu-$k-all.data --no-children --comm compiler --sort symbol,srcline --stdio -F overhead,sample,symbol,srcline 2>/dev/null | grep -v "^$" > pu-$k-symlines-all.txt
  echo "all $k: $(perf report -q -i pu-$k-all.data --stdio --sort comm -F sample,comm 2>/dev/null | tr -s ' ' | tr '\n' ' ')"
done
rm -f pu-op-all.data pu-cyc-all.data
echo DONE
