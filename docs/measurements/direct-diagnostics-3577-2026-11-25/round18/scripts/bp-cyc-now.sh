#!/bin/bash
# Cycle-weighted profiles (perf record -e cycles:u) of main (base) and the head (work, checked out at $1), and perf stat
# with at most four events a run, then the pipeline metrics alone.
H=$1
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cd "$D/repo" && git fetch -q "$D/b5.bundle" || exit 1
git -C ../work checkout -q -- . 2>/dev/null; git -C ../work checkout -q --detach $H || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: cycle-weighted profile, main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-cyc.log" 2>&1; echo "build $?"
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-c.o)
  for t in base work; do
    (cd ../$t && taskset -c 2 perf record -q -e cycles:u -c 20000 -o ../pcyc-$t.data -- bash -c "for i in \$(seq 200); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
  for t in base work base work; do
    echo "== stat $t"
    (cd ../$t && taskset -c 2 perf stat -r 15 -e cycles:u,instructions:u,ex_ret_brn_misp:u,ic_tag_hit_miss.instruction_cache_miss:u ./build/compiler "${flags[@]}" 2>&1 | grep -E "cycles|instructions|misp|cache_miss")
    (cd ../$t && taskset -c 2 perf stat -r 15 -M PipelineL1 ./build/compiler "${flags[@]}" 2>&1 | grep -E "%" | sed "s/  */ /g")
  done
' x "$sqlite"
cd "$D" || exit 1
for t in base work; do
  perf report -q -i pcyc-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > cyc-$t.txt
  perf report -q -i pcyc-$t.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > cyc-lines-$t.txt
done
wc -l cyc-*.txt
echo DONE
