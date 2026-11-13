#!/bin/bash
# explore-icmiss.sh LABEL SET: the shadow on sqlite3.c by results/LABEL's compiler (patches/only.patch), --passes 40 timing
# sweep set SET alone, on CPU 2 in one hold of the lock: a profile of instruction-cache misses and of the front end's empty
# dispatch slots, each by symbol and, for the sweeps' functions, by source line and by 64-byte line of code.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1/icmiss-set$2
mkdir -p "$out"
compiler=$PWD/results/$1/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > $out/holder.txt; BUSTER_NODE_SHADOW_ONLY=$2 taskset -c 2 perf record -q -c 20011 -e ic_tag_hit_miss.instruction_cache_miss:u -o $out/perf.data $compiler measure-node-machine --shadow --passes 40 $options > /dev/null 2>&1"
perf report -i $out/perf.data --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -30 > $out/symbols.txt
perf script -i $out/perf.data -F ip,sym 2>/dev/null | awk "{print \$1, \$2}" > $out/ips.txt
awk "{print \$1}" $out/ips.txt | sort | uniq -c | sort -k1,1 -n -r | head -400 > $out/ip-counts.txt
awk "{print \"0x\" \$2}" $out/ip-counts.txt | addr2line -e $compiler -f -s -a > $out/ip-lines.txt 2>/dev/null
rm -f $out/perf.data
