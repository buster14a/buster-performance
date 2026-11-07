#!/bin/bash
# #1629: cycles profiles with DWARF call graphs of the harness, one run per lock hold, main418 and c6: 300 copies of
# c-testsuite's 00001.c and 10 of the synthetic statics-2000.c, for the publication's and the object's inclusive costs.
cd ~/buster-fast-bench/1629-claude
export EXCLUSIVE_OWNER=claude-1629 EXCLUSIVE_TITLE="Take the remaining work of 442 (#1629)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1629
mkdir -p perf
tiny=$(for i in $(seq 300); do echo -n "cts/tests/single-exec/00001.c "; done)
big=$(for i in $(seq 10); do echo -n "synthetic/statics-2000.c "; done)
for kind in tiny big; do
    [ $kind = tiny ] && files=$tiny || files=$big
    for t in main418 c6; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf record -q -e cycles:u -c 50000 --call-graph dwarf,8192 -o perf/g-$kind-$t.data trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > perf/g-$kind-$t.txt 2>&1
        perf report -i perf/g-$kind-$t.data --children --stdio -q --sort sym -F children,self,sym --percent-limit 0.02 -g none 2>/dev/null > perf/g-$kind-$t.children
        echo "$kind $t $(tail -1 perf/g-$kind-$t.txt | cut -c1-160)"
    done
done
echo perfb-done
