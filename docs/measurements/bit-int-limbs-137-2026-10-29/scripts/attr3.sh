#!/bin/bash
# Attribution of benchmark-lowering-source's user instructions between #137's trees: perf record of user instructions,
# 10 runs per tree, each with another period from 900,001 to 1,350,011 (under the host's 40,000 samples a second at
# about 11G instructions a second), so that the runs' samples fall at other places in the same instructions; each run
# under the lock alone, on CPU 2, the trees' order rotating by run; then each run's period per function (its
# instructions). Usage: attr3.sh NAME TREE...
set -e
name=$1; shift
cd ~/buster-fast-bench/cc137-claude
export EXCLUSIVE_OWNER=claude-137 EXCLUSIVE_TITLE="solve #137's remaining work (attribution: $name)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/137
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
periods=(900001 950009 1000003 1050011 1100009 1150001 1200007 1250003 1300021 1350011)
trees=("$@")
for r in "${!periods[@]}"; do
    for i in "${!trees[@]}"; do
        t=${trees[$(( (i + r) % ${#trees[@]} ))]}
        status=0
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf record -q -e instructions:u -c ${periods[$r]} -o $name-$t-$r.data ./$t/build/compiler benchmark-lowering-source "${O[@]}" > $name-$t-$r.txt 2>&1 || status=$?
        perf report -i $name-$t-$r.data --no-children --sort symbol -F period,sample,symbol --stdio -q 2>/dev/null > $name-$t-$r.report
        echo "$t $r: period ${periods[$r]}, status $status, $(grep -o 'referenced_ns=[0-9]*' $name-$t-$r.txt | tail -1), $(awk '{ p += $1; s += $2 } END { print s " samples, " p " instructions" }' $name-$t-$r.report)"
        rm -f $name-$t-$r.data
    done
done
echo done
