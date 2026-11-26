#!/bin/bash
# bp-fresh.sh: whether a freshly copied binary runs slower than an older copy of the same bytes: m16 and p8 against fresh
# copies of each (m16b, p8b), perf stat rotation (3 rounds of 7), with iTLB-related counters.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597 EXCLUSIVE_TITLE="#3577 direct path: fresh copies of the same binaries"
cd "$D" || exit 1
cp bins/compiler-m16 bins/compiler-m16b; cp bins/compiler-p8 bins/compiler-p8b
cmp bins/compiler-m16 bins/compiler-m16b && cmp bins/compiler-p8 bins/compiler-p8b && echo "copies identical"
grep -E "AnonHugePages|FileHugePages|FilePmdMapped" /proc/meminfo
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-c.o)
  for r in 1 2 3; do
    for t in main16 m16 m16b p8 p8b; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u,bp_l1_tlb_miss_l2_tlb_miss.all:u,bp_l1_tlb_miss_l2_tlb_hit:u ./bins/compiler-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions|tlb" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
' x "$sqlite"
rm -f bins/compiler-m16b bins/compiler-p8b
echo DONE
