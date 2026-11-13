#!/bin/bash
# objects.sh (inside one hold): every object and diagnostic of the three workloads by base, head and head --scalar,
# each workload's run from the same directory name so that DWARF's directory is the same; then compares them.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$here/results/objects
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
status=0
for v in base head scalar; do
    c=$base; s=""
    if [[ $v != base ]]; then c=$head; fi
    if [[ $v == scalar ]]; then s=--scalar; fi
    rm -rf $t/w && mkdir -p $t/w
    (cd $t/w && taskset -c 2 $c $s -c -g -Wall -Wextra $ct $sqlite/sqlite3.c -o sqlite3.o > ../s-$v.err 2>&1; echo "sqlite $v $?" >> $out/status.txt
     taskset -c 2 $c $s $mo --lanes 1 -c -Wall @$t/lists/musl.txt > ../m-$v.err 2>&1; echo "musl $v $?" >> $out/status.txt
     mkdir cts && cd cts && taskset -c 2 $c $s --lanes 1 -c -g -Wall -Wextra @$t/lists/cts.txt > ../../c-$v.err 2>&1; echo "cts $v $?" >> $out/status.txt)
    rm -rf $t/obj-$v && mv $t/w $t/obj-$v
done
for v in head scalar; do
    if diff -r $t/obj-base $t/obj-$v > $out/diff-$v.txt && cmp $t/s-base.err $t/s-$v.err && cmp $t/m-base.err $t/m-$v.err && cmp $t/c-base.err $t/c-$v.err; then
        echo "$v: objects and diagnostics identical to base" >> $out/compare.txt
    else
        echo "$v: DIFFERENT" >> $out/compare.txt; status=1
    fi
done
(cd $t/obj-base && find . -name '*.o' | sort | xargs sha256sum) > $out/objects.sha256
wc -l $t/s-base.err $t/m-base.err $t/c-base.err > $out/diagnostic-lines.txt
cat $out/compare.txt
exit $status
