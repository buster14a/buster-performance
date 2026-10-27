#!/bin/bash
# abd6's last steps again (the run of abE.sh stopped at 10:54 while ab lower waited for the lock): ab lower and perf stat's
# three rounds, as abE.sh has them.
set -u
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: atomics lowering on #496's head, tests and A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
cd ~/buster-fast-bench/solve-126-claude/abd6
[ -f ab_lower.log ] && mv ab_lower.log ab_lower_interrupted.log
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- time-runs --runs 11 --list -c -o /dev/null "${lower[@]}" > ab_lower.log 2>&1
echo "ab lower status $?"
for round in 1 2 3; do
    for tree in base head; do
        echo "== round $round tree $tree driver" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:" >> perf.log
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:" >> perf.log
    done
done
echo "perf done"
echo done
