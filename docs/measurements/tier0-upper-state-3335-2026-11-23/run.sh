#!/bin/bash
# #3335 on the 9700X: the Zen 5 rows the VEX twins lack, the issue's kernel base against mine, and -c of the frozen
# sqlite3.c by Tier 0 at -march=znver5, base against mine. Each step its own hold of the lock.
D=/tmp/3335-claude
cd $D
export EXCLUSIVE_OWNER=claude-3335 EXCLUSIVE_TITLE="buster #3335 Tier 0 vzeroupper" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3335
snap() { echo "== $1 $(date -u +%FT%TZ) loadavg $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; }
export -f snap
mkdir -p results
# 1. Zen 5 rows.
~/buster-fast-bench/exclusive.sh bash -c 'snap before; cd mine && taskset -c 2 timeout -k 5 1200 ./build/compiler measure-x86-zen5 --missing --table > ../results/zen5-missing.txt 2> ../results/zen5-missing.err; echo exit $?; cd ..; snap after' > results/zen5.log 2>&1
# 2. The kernel.
for t in base mine; do
  for contract in on off; do
    ./$t/build/compiler -c -march=znver5 -ffp-contract=$contract -o results/k-$t-$contract.o kernel.c
    ./$t/build/compiler -S -march=znver5 -ffp-contract=$contract -o results/k-$t-$contract.s kernel.c
    clang -O2 -march=znver5 -o results/run-$t-$contract driver.c results/k-$t-$contract.o
  done
done
~/buster-fast-bench/exclusive.sh bash -c 'snap before; for i in 1 2 3; do for contract in on off; do for t in base mine; do for m in dirty clean; do echo -n "$t contract=$contract round $i: "; taskset -c 2 timeout -k 5 60 ./results/run-$t-$contract $m 1024; done; done; done; done; snap after' > results/kernel.log 2>&1
# 3. sqlite3.c -c.
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for t in base mine; do ./$t/build/compiler -c "${sqlite[@]}" -o results/sqlite-$t.o; echo "$t -c exit $?"; done > results/sqlite-objects.log 2>&1
cmp results/sqlite-base.o results/sqlite-mine.o >> results/sqlite-objects.log 2>&1
~/buster-fast-bench/exclusive.sh bash -c 'snap before; taskset -c 2 ./mine/build/compiler time-runs --runs 21 --warmups 2 --build base ./base/build/compiler --build mine ./mine/build/compiler --list -c "$@" -o results/sqlite-time.o; snap after' _ "${sqlite[@]}" > results/sqlite-time.log 2>&1
echo RUN DONE
