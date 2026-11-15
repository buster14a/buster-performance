#!/bin/bash
# final.sh HEAD MAIN: #2718's 9700X runs of the final head against main, each step its own hold of the lock.
D=~/buster-fast-bench/2718-claude; HEAD=$1; MAIN=$2
export EXCLUSIVE_OWNER=claude-2718 EXCLUSIVE_TITLE="#2718 memory value numbering" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2718
X=~/buster-fast-bench/exclusive.sh; C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
R=$D/results/final; mkdir -p $R /tmp/2718-final
for t in head main; do [ -d $D/$t ] || git clone -q $D/buster $D/$t; done
(cd $D/head && git fetch -q https://github.com/buster14a/buster claude/loving-goodall-lj1n26 && git checkout -q -f $HEAD && git log -1 --format='%H %T %s' > $R/head-commit.txt)
(cd $D/main && git fetch -q https://github.com/buster14a/buster main && git checkout -q -f $MAIN && git log -1 --format='%H %T %s' > $R/main-commit.txt)
for t in head main; do (cd $D/$t && $X timeout -k 5 1500 env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $R/build-$t.log 2>&1); done
H=$D/head/build/compiler; M=$D/main/build/compiler
{ sha256sum $H $M; uname -a; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null; } > $R/host.txt
$X $D/held.sh $R/identity.txt $D/identity.sh $M $H
unset CPATH C_INCLUDE_PATH
O="--predefines $C/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c"
for p in tier1 tier1-memory memory; do
  $X $D/held.sh $R/passes-$p.txt timeout -k 5 900 taskset -c 2 $H benchmark-ir-source --passes --only $p $O
done
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
$X $D/held.sh $R/compile.txt timeout -k 5 1200 taskset -c 2 $H time-runs --runs 11 --build main $M --build head $H --build main-again $M \
  --list --tier1 --lanes 1 $SQ -c $C/sqlite/sqlite3.c -o /tmp/2718-compile.o \
  --list --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $D/inputs/lua-5.4.8/src/lvm.c -o /tmp/2718-lvm.o
$X $D/held.sh $R/programs.txt timeout -k 5 1500 taskset -c 2 $H measure-tier1-programs --runs 11 --clang clang --sqlite $C/sqlite --speedtest $D/inputs \
  --lua $D/inputs/lua-5.4.8/src --scripts $D/inputs/scripts --directory /tmp/2718-final --variant --tier1-passes=-memory
$X $D/held.sh $R/loads.txt timeout -k 5 1500 $D/loads.sh $H
echo done > $R/done.txt
