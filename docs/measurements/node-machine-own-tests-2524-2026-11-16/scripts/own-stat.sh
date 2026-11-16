#!/bin/bash
# own-stat.sh LABEL TAG [shadow options]: perf stat (user) of measure-node-machine --shadow [options] on sqlite3.c by
# results/LABEL/compiler on CPU 2, five processes a group of events, two groups, one hold of the lock:
# results/LABEL/os-TAG.txt (perf's CSV: the mean count, the event).
set -u
cd "$(dirname "$0")"
label=$1; tag=$2
shift 2
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
a="cycles:u,instructions:u,branches:u,branch-misses:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u"
b="cycles:u,de_src_op_disp.x86_decoder:u,de_src_op_disp.op_cache:u,ls_bad_status2.stli_other:u,l2_cache_req_stat.ic_fill_miss:u,bp_redirects.resync:u"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200 > /dev/null; perf stat -x, -r 5 -e $a -o $out/os-$tag-a.txt -- $run > /dev/null 2>&1; perf stat -x, -r 5 -e $b -o $out/os-$tag-b.txt -- $run > /dev/null 2>&1"
cat $out/os-$tag-a.txt $out/os-$tag-b.txt | grep -v '^#' | grep . > $out/os-$tag.txt
rm -f $out/os-$tag-a.txt $out/os-$tag-b.txt
