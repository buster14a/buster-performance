#!/bin/bash
# #1383 measurement: each input compiled with -c by base and new, 5 whole processes each, pinned to CPU 2, one lock hold
# per input and binary. Records wall ms, peak RSS KB (ru_maxrss) and exit; objects compared between binaries.
cd /tmp/1383-claude
export EXCLUSIVE_OWNER=claude-1383 EXCLUSIVE_TITLE="buster #1383: floating record members and short rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1383
mkdir -p inputs objects
inputs="flat rows short short-double struct-int struct-double struct-float struct-float-local"
for s in $inputs; do ./gen $s 1000000 > inputs/$s.c; done
cp sqlite3.c inputs/sqlite3.c
uname -a > env.txt; git -C base log -1 --format='base %H' >> env.txt; git -C new log -1 --format='new %H' >> env.txt
printf 'input\tbinary\trun\tms\trss_kb\texit\n' > results.tsv
for s in $inputs sqlite3; do
    for tree in base new; do
        ~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash -c "
            { echo '== $s $tree before'; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> load.log
            for run in 1 2 3 4 5; do
                taskset -c 2 ./measure $tree/build/compiler -c -o objects/$s.$tree.o inputs/$s.c 2> m.tmp > /dev/null
                printf '%s\t%s\t%s\t%s\n' $s $tree \$run \"\$(tail -1 m.tmp | tr ' ' '\t')\" >> results.tsv
            done
            { echo '== $s $tree after'; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> load.log
        " 2>> lock.log
    done
    cmp -s objects/$s.base.o objects/$s.new.o && echo "$s objects identical" >> compare.txt || echo "$s objects DIFFER" >> compare.txt
    sha256sum objects/$s.base.o objects/$s.new.o >> compare.txt
done
echo done > run.status
