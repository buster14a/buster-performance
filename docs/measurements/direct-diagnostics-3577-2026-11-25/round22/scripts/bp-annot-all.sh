#!/bin/bash
# bp-annot-all.sh: per-instruction cycle samples of the ALL arm (the work tree's build, 4823da71b at offset 0) in
# fast_cc_compile_func, 300 compiles of sqlite3.c, cycles:u every 100,000 (below the sample-rate limit); and the same
# with IBS ops' load latency (perf mem). Output: annot-all-cf.txt (perf annotate --stdio), mem-all.txt.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D" || exit 1
[ "$(git -C work rev-parse --short HEAD)" = "4823da71b" ] || { echo "work tree is not the ALL arm"; exit 1; }
EXCLUSIVE_TITLE="#3577 direct path: per-instruction cycles of the ALL arm" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-a.o)
  (cd work && taskset -c 2 perf record -q -e cycles:u -c 100000 -o ../pa-cyc-all.data -- bash -c "for i in \$(seq 300); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed cyc"
  (cd work && taskset -c 2 perf record -q -e ex_ret_brn_misp:u -c 2000 -o ../pa-misp-all.data -- bash -c "for i in \$(seq 300); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed misp"
' x "$sqlite"
perf annotate -i pa-cyc-all.data --stdio -s fast_cc_compile_func --no-source 2>/dev/null > annot-all-cf.txt
perf annotate -i pa-misp-all.data --stdio -s fast_cc_compile_func --no-source 2>/dev/null > annot-misp-all-cf.txt
perf report -q -i pa-misp-all.data --no-children --comm compiler --sort symbol --stdio -F overhead,sample,symbol 2>/dev/null | grep -v "^$" | head -40 > misp-all.txt
wc -l annot-all-cf.txt annot-misp-all-cf.txt misp-all.txt
echo DONE
