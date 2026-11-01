#!/usr/bin/env bash
# micro.sh BASE HEAD: micro.c built by head's Tier 0 and --tier1, base's --tier1 and clang -O2, each run 11 times in a
# rotating order on CPU 2, each run one hold of the shared lock; outputs in micro-HEAD/.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
base=$1
head=$2
out=$PWD/micro-$head
rm -rf $out && mkdir -p $out
cp micro.c $out/
"$lock" bash -c "cd $out && taskset -c 2 $PWD/$head/build/compiler -o micro-t0 micro.c > build-t0.txt 2>&1; taskset -c 2 $PWD/$head/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -o micro-t1 micro.c > build-t1.txt 2>&1; taskset -c 2 $PWD/$base/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -o micro-t1base micro.c > build-t1base.txt 2>&1; clang -O2 -o micro-clang2 micro.c > build-clang2.txt 2>&1"
builds=(t0 t1 t1base clang2)
for r in $(seq 0 10); do
    for i in $(seq 0 3); do
        c=${builds[$(( (r + i) % 4 ))]}
        [ -x $out/micro-$c ] || continue
        "$lock" bash -c "taskset -c 2 $out/micro-$c > $out/r$r-$c.txt 2>&1"
    done
done
for c in ${builds[@]}; do
    objdump -d --no-show-raw-insn $out/micro-$c | awk '/^[0-9a-f]+ <(chain|stream)_[a-z0-9]+>:$/ { name = $2 } /^$/ { name = "" } name != "" && /\t(i?div|i?mul) / { n[name] += 1 } END { for (k in n) print k, n[k] }' | sort > $out/divisions-$c.txt
done
echo done > $out/done
