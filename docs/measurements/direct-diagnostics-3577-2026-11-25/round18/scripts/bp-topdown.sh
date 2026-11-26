#!/bin/bash
# Pipeline utilization (perf's PipelineL1/L2 metric groups) of main's and the work tree's compile of sqlite3.c, one hold.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: pipeline utilization, main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
perf list metricgroup 2>/dev/null | grep -i pipeline | head -5
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-td.o)
  for t in base work base work; do
    echo "== $t"
    (cd ../$t && taskset -c 2 perf stat -r 20 -M PipelineL1,PipelineL2 -e cycles:u,instructions:u,ic_tag_hit_miss.instruction_cache_miss:u,ex_ret_brn_misp:u ./build/compiler "${flags[@]}" 2>&1 | grep -vE "^\s*$|Performance counter" | sed "s/  */ /g" | head -40)
  done
' x "$sqlite"
echo DONE
