#!/usr/bin/env bash
# main (e04462c1) against the PR's head without the experiment: the build, and the C driver's default paths on the pinned
# SQLite. Every build and run under the lock; ab takes it per run itself.
set -u
base=~/buster-fast-bench/claude-fragments-106-107
cd "$base"
export EXCLUSIVE_OWNER=claude-fragments-107
export EXCLUSIVE_TITLE="Salter fragments #107: main vs head without the experiment"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/107
lock=~/buster-fast-bench/exclusive.sh
results="$base/results-ab-${HEAD_TREE:-29b23335}"
mkdir -p "$results"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options="--predefines $C/provenance/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
echo "$(date -Is) start" >> "$results/progress"
for round in 1 2; do
    for t in main head; do
        (cd "ab-$t" && "$lock" bash -c './build.sh && sha256sum build/compiler') > "$results/build-$t-$round.log" 2>&1
        echo "$(date -Is) build $t $round status $?" >> "$results/progress"
    done
done
for t in main head; do
    (cd "ab-$t" && "$lock" bash -c "taskset -c 2 ./build/compiler -fsyntax-only $options $C/sqlite/sqlite3.c; echo syntax status \$?; taskset -c 2 ./build/compiler -c -o $results/$t.o $options $C/sqlite/sqlite3.c; echo object status \$?; sha256sum $results/$t.o") > "$results/drive-$t.log" 2>&1
done
echo "$(date -Is) drive done" >> "$results/progress"
./ab-head/build/compiler ab --rounds 5 --cpu 2 --lock "$lock" ab-main ab-head -- time-runs --runs 21 --list -fsyntax-only $options $C/sqlite/sqlite3.c \
    -- time-runs --runs 11 --list -c -o "$results/ab.o" $options $C/sqlite/sqlite3.c > "$results/ab.log" 2>&1
echo "$(date -Is) ab status $?" >> "$results/progress"
echo "$(date -Is) done" >> "$results/progress"
