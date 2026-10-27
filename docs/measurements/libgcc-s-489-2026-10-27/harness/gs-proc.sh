#!/bin/bash
# On the 9700X: the C driver compiling and linking hello.c by the direct path, whole processes (time-runs), #511's
# merge base's build and its head's in turn (A B, B A, A B), each under its own hold of the lock, each with its own
# snapshot cache.
export EXCLUSIVE_OWNER=claude-libgcc-s-489 EXCLUSIVE_TITLE="Solve 489" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/511"
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
printf '#include <stdio.h>\nint main(void) { puts("hello"); return 0; }\n' > $B/libgcc-s-489-hello.c
for round in 1 2 3; do
    if [ $round = 2 ]; then order="libgcc-s-489-claude libgcc-s-489-main"; else order="libgcc-s-489-main libgcc-s-489-claude"; fi
    for d in $order; do
        cd $B/$d || exit 1
        mkdir -p proc-cache
        XDG_CACHE_HOME=$B/$d/proc-cache $X taskset -c 2 ./build/compiler time-runs --runs 41 --warmups 5 --list $B/libgcc-s-489-hello.c -o $B/$d/proc-hello > proc-$round.log 2>&1
        echo "== $d $round: $?"; grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:" proc-$round.log | tail -8
    done
done
