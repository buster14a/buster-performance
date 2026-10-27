#!/usr/bin/env bash
# Three more rounds of the default path A/B, -fsyntax-only alone (the -c list timed the same refusal on both trees).
set -u
base=~/buster-fast-bench/claude-fragments-106-107
cd "$base"
export EXCLUSIVE_OWNER=claude-fragments-107
export EXCLUSIVE_TITLE="Salter fragments #107: main vs head without the experiment"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/107
lock=~/buster-fast-bench/exclusive.sh
results="$base/results-ab-29b23335"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options="--predefines $C/provenance/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
echo "$(date -Is) start ab2" >> "$results/progress"
./ab-head/build/compiler ab --rounds 3 --cpu 2 --lock "$lock" ab-main ab-head -- time-runs --runs 21 --list -fsyntax-only $options $C/sqlite/sqlite3.c > "$results/ab2.log" 2>&1
echo "$(date -Is) ab2 status $?" >> "$results/progress"
