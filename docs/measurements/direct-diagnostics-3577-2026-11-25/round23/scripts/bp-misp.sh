#!/bin/bash
# bp-misp.sh: mispredicted branches (ex_ret_brn_misp, every 2,000, 300 compiles of sqlite3.c) of main (base tree) and
# the head (work tree rebuilt at eeee61ef8, offset 0), one hold; reports by function, by function and line, and
# fast_cc_compile_func's instructions; plus perf stat of both (cycles, instructions, mispredicts, branches).
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
git checkout -q -- . 2>/dev/null; git checkout -q --detach eeee61ef8 || exit 1
EXCLUSIVE_TITLE="#3577 direct path: build the head for mispredict profiles" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-misp-head.log" 2>&1
st=$?; echo "build head status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: mispredict profiles, main and head" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-m.o)
  for t in base work; do
    echo "== $t $(cd $t && taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u,ex_ret_brn_misp:u,ex_ret_brn:u ./build/compiler "${flags[@]}" 2>&1 | grep -E "cycles|instructions|ex_ret" | awk "{print \$1}" | tr "\n" " ")"
    (cd $t && taskset -c 2 perf record -q -e ex_ret_brn_misp:u -c 2000 -o ../pm-$t.data -- bash -c "for i in \$(seq 300); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' x "$sqlite" > misp.txt
cat misp.txt
for t in base work; do
  perf report -q -i pm-$t.data --no-children --comm compiler --sort symbol --stdio -F overhead,sample,symbol 2>/dev/null | grep -v "^$" > pm-$t.txt
  perf report -q -i pm-$t.data --no-children --comm compiler --sort symbol,srcline --stdio -F overhead,sample,symbol,srcline 2>/dev/null | grep -v "^$" > pm-symlines-$t.txt
  perf annotate -i pm-$t.data --stdio -s fast_cc_compile_func --no-source 2>/dev/null > pm-annot-cf-$t.txt
done
rm -f pm-base.data pm-work.data
echo DONE
