#!/bin/bash
# job-ask3.sh: main with the include search's asks as reworked (ask3, files-ask3.patch: a stat at a component's third
# miss), a Release build in one hold of the lock; the three compilers' file system calls (counts.sh); then base against
# ask3, a hold of the lock an A/B (ab.sh: CPU 2, CPU-wide counts), with base against a second copy of itself (same) as
# what two copies of one executable read; and abstat's table of each.
cd "$(dirname "$0")"
main=d1cf1fe82879655f6149f0210e5d7ff5780e4a04
: > job-ask3.done
./build-tree.sh ask3 $main files-ask3.patch > build-ask3.out 2>&1
log=series3.log
: > "$log"
./lock.sh timeout -k 10 600 ./counts.sh results/counts3 "base=$PWD/base/build/compiler" "ask=$PWD/ask/build/compiler" "ask3=$PWD/ask3/build/compiler" > results/counts3.log 2>&1
echo "$? counts" >> "$log"
for spec in hello:21:ask3 hello:21:same sqlite:21:ask3 sqlite:21:same musl:5:ask3 musl:5:same tiny:11:ask3 command:5:ask3 command:5:same musl:5:ask3:again hello:21:ask3:again; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/ab3-$label" "$kind" "$rounds" "base=$PWD/base/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/ab3-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/ab3-$label" base "$other" > "results/abstat3-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-ask3.done
