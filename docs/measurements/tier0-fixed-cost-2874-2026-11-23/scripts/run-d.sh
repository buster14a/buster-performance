#!/bin/bash
cd ~/buster-fast-bench/2874-claude-volta
C=$PWD/corpus
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-piece-D-AB EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3486 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 420 bash -c "scripts/ab.sh $PWD/bin/ahead $PWD/bin/d1 ab-d 21; scripts/ab.sh $PWD/bin/base2 $PWD/bin/d1 ab-cd 21; for r in 1 2 3; do for b in ahead d1; do echo \"== \$b \$r\"; taskset -c 2 bin/\$b benchmark-backend-source $FLAGS $C/sqlite/sqlite3.c 2>&1 | grep -E '^(vector|scalar) '; done; done > results/ab-d/benchmark.txt 2>&1" > results/ab-d.log 2>&1
echo done > results/d.done
