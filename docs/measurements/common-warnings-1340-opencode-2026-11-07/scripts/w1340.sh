#!/usr/bin/env bash
# #1340: main and head on sqlite3.c's -c, with warnings on (the default) and off (-w), 11 rotated rounds of
# --time-stages, in one hold of the 9700X's lock (about 6 s), on CPU 2. Writes wlogs/ and wlogs/holds.txt.
set -u
cd ~/buster-fast-bench/1340-opencode || exit 2
rm -rf wlogs && mkdir -p wlogs
EXCLUSIVE_OWNER=opencode-1340 EXCLUSIVE_TITLE="opencode #1340 -w baseline" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
~/buster-fast-bench/exclusive.sh bash -c '
head -1 /var/lib/buster-9700x/owner >> wlogs/holds.txt
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
args=(-c --lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" -o /tmp/opencode1340w.o --time-stages)
for r in 0 1 2 3 4 5 6 7 8 9 10; do
  for v in main head; do for w in on off; do
    bin=root2/bin/compiler-main-znver5; [ $v = head ] && bin=root2/bin/compiler-znver5
    extra=(); [ $w = off ] && extra=(-w)
    taskset -c 2 $bin "${args[@]}" "${extra[@]}" > wlogs/$v-$w.r$r.log 2>&1
    echo "$v $w r$r status=$?" >> wlogs/status.txt
  done; done
done
'
