#!/bin/sh
# #1444 item 3: one run of build NAME placement 0 with a kprobe on vma_alloc_anon_folio_pmd (each huge page a fault allocates, its address),
# vmf->flags at +40: bit 0 a write, which allocates a huge page; a read maps the huge zero page) and the user stack of
# each, randomization off, pinned to CPU 2, one hold of the 9700X's lock.
#   thp-who.sh NAME TAG ARGUMENT...
set -e
d=~/buster-fast-bench/1444-claude-thp
. $d/env.sh
name=$1
tag=$2
shift 2
C=$d/shifts-$name/compiler-0
out=$d/results/who-$name
mkdir -p $out
cd $d/inputs
~/buster-fast-bench/exclusive.sh sh -c "
    sudo perf probe -q -d probe:thp1444 2>/dev/null || true
    sudo perf probe -q -a 'thp1444=vma_alloc_anon_folio_pmd addr=%si:x64'
    sudo taskset -c 2 setarch -R perf record -q -e probe:thp1444 -o $out/$tag.data -- $C $* > /dev/null 2>&1
    sudo perf probe -q -d probe:thp1444
    sudo perf script -i $out/$tag.data -F trace,ip,sym 2>/dev/null > $out/$tag.txt
    sudo rm -f $out/$tag.data"
