#!/bin/bash
# bp-ls.sh: load-store counters (forwarding, interlocks, misaligned loads) of main (base) and the head (work), one hold.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: load-store counters, main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-l.o)
  for t in base work base work; do
    echo "== $t"
    for ev in ls_bad_status2.stli_other:u,ls_stlf:u,ls_misal_loads.ma64:u,ls_misal_loads.ma4k:u \
              ls_dispatch.ld_dispatch:u,ls_dispatch.store_dispatch:u,ls_dispatch.ld_st_dispatch:u,ls_alloc_mab_count:u; do
      (cd $t && taskset -c 2 perf stat -r 10 -e $ev ./build/compiler "${flags[@]}" 2>&1 | grep -E "^ +[0-9,]+ +[a-z]" | sed "s/  */ /g")
    done
  done
' x "$sqlite"
echo DONE
