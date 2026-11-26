#!/bin/bash
# bp-stli.sh: loads that store-to-load forwarding refused (ls_bad_status2.stli_other) and forwarding hits (ls_stlf):
# the microbenchmark's split-zmm case against its aligned one; sqlite3.c's compile by main (base tree), the ALL arm
# (work tree, 4823da71b), then the head (work tree rebuilt at eeee61ef8, offset 0); and sampled profiles of the event
# for main and the head (every 2,000 events, 100 compiles; per function and per function and line).
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D" || exit 1
EV=cycles:u,instructions:u,ls_bad_status2.stli_other:u,ls_stlf:u
EXCLUSIVE_TITLE="#3577 direct path: store-to-load interlocks, main and ALL" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; EV=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-s.o)
  for c in split aligned; do echo "== stlf $c $(taskset -c 2 perf stat -e $EV ./stlf $c 2>&1 | grep -E "^ *[0-9]|split|aligned" | awk "{print \$1}" | tr "\n" " ")"; done
  for t in base work; do echo "== $t $(cd $t && taskset -c 2 perf stat -r 5 -e $EV ./build/compiler "${flags[@]}" 2>&1 | grep -E "cycles|instructions|stli|stlf" | awk "{print \$1}" | tr "\n" " ")"; done
  (cd base && taskset -c 2 perf record -q -e ls_bad_status2.stli_other:u -c 2000 -o ../ps-main.data -- bash -c "for i in \$(seq 100); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed main"
' x "$sqlite" "$EV"
cd "$D/work" || exit 1
git checkout -q -- . 2>/dev/null; git checkout -q --detach eeee61ef8 || exit 1
EXCLUSIVE_TITLE="#3577 direct path: build the head for interlock profiles" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-stli-head.log" 2>&1
st=$?; echo "build head status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: store-to-load interlocks, head" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; EV=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-s.o)
  for t in base work; do echo "== $t $(cd $t && taskset -c 2 perf stat -r 5 -e $EV ./build/compiler "${flags[@]}" 2>&1 | grep -E "cycles|instructions|stli|stlf" | awk "{print \$1}" | tr "\n" " ")"; done
  (cd work && taskset -c 2 perf record -q -e ls_bad_status2.stli_other:u -c 2000 -o ../ps-head.data -- bash -c "for i in \$(seq 100); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed head"
' x "$sqlite" "$EV"
for t in main head; do
  perf report -q -i ps-$t.data --no-children --comm compiler --sort symbol --stdio -F overhead,sample,symbol 2>/dev/null | grep -v "^$" > ps-$t.txt
  perf report -q -i ps-$t.data --no-children --comm compiler --sort symbol,srcline --stdio -F overhead,sample,symbol,srcline 2>/dev/null | grep -v "^$" > ps-symlines-$t.txt
  perf annotate -i ps-$t.data --stdio -s fast_cc_compile_func --no-source 2>/dev/null > ps-annot-cf-$t.txt
  echo "$t: $(perf report -q -i ps-$t.data --stdio --sort comm -F sample,comm 2>/dev/null | tr -s ' ' | tr '\n' ' ')"
done
rm -f ps-main.data ps-head.data
echo DONE
