#!/bin/bash
cd ~/buster-fast-bench/2874-claude-volta
C=$PWD/corpus
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-selection-gather-ahead-AB EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2874 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 300 bash -c "scripts/ab.sh $PWD/bin/base2 $PWD/bin/ahead ab-ahead 21; for r in 1 2 3; do for b in base2 ahead; do echo \"== \$b \$r\"; taskset -c 2 bin/\$b benchmark-backend-source $FLAGS $C/sqlite/sqlite3.c 2>&1 | tail -25; done; done > results/ab-ahead/benchmark.txt 2>&1" > results/ab-ahead.log 2>&1
echo done > results/ahead.done
