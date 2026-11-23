#!/bin/bash
# #2719 on the 9700X: run.sh programs|compile|kernels, each one run under exclusive.sh by the caller (lock.sh).
D=~/buster-fast-bench/2719-claude
I=~/buster-fast-bench/3309-claude
CLANGDIR=$(ls -d ~/.cache/buster/benchpress-clang/*/bin 2>/dev/null | head -1)
export PATH=$CLANGDIR:$PATH
unset CPATH C_INCLUDE_PATH
B=$D/head/build/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
echo "tree head: 061effd6 plus head.patch $(sha256sum $D/head.patch | cut -c1-16); compiler $(sha256sum $B | cut -c1-16)"; clang --version | head -1
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
mkdir -p $D/tmp
case "$1" in
programs)
  cd $D/head && taskset -c 2 $B measure-tier1-programs --runs 11 --clang clang --sqlite "$sqlite" --speedtest $I/inputs --lua $I/inputs/lua-5.4.8/src --scripts $I/evidence/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua --directory $D/tmp --variant --tier1-passes=-hoist --variant --tier1-passes=+numbering --variant --tier1-passes=+licm
  ;;
compile)
  source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
  cd $D/tmp && taskset -c 2 $B measure-compile --runs 11 --variant --tier1-passes=-hoist --variant --tier1-passes=+numbering -- -c --tier1 --lanes 1 "${source[@]}" $sqlite/sqlite3.c
  ;;
kernels)
  cd $D/kern
  clang -O2 -c -o drive.o drive.c
  clang -O2 -o k-clang-O2 drive.o kernels.c extra.c
  for v in default:"" nohoist:"--tier1-passes=-hoist" numbering:"--tier1-passes=+numbering"; do
    n=${v%%:*}; o=${v#*:}
    $B --tier1 -fno-asynchronous-unwind-tables $o -c -o kernels-$n.o kernels.c && $B --tier1 -fno-asynchronous-unwind-tables $o -c -o extra-$n.o extra.c && clang -o k-$n drive.o kernels-$n.o extra-$n.o
  done
  for b in clang-O2 default nohoist numbering; do echo "$b $(./k-$b)"; done
  taskset -c 2 $B time-runs --runs 11 --warmups 1 --build clang-O2 ./k-clang-O2 --build nohoist ./k-nohoist --build default ./k-default --build numbering ./k-numbering --list 1
  ;;
profile)
  source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
  cd $D/tmp
  for v in hoist:"" nohoist:"--tier1-passes=-hoist"; do
    n=${v%%:*}; o=${v#*:}
    taskset -c 2 perf record -q -e cycles:u -c 200000 -o $D/perf-$n.data $B -c --tier1 --lanes 1 $o "${source[@]}" -o $D/tmp/sq-$n.o $sqlite/sqlite3.c
    perf report -q -i $D/perf-$n.data --sort symbol --stdio 2>/dev/null | head -60 > $D/perf-$n.txt
  done
  ;;
esac
echo "rc=$?"
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
