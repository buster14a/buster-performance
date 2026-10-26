#!/bin/bash
# On the 9700X: the driver compiling and linking hello.c by the direct path, whole processes (time-runs), main's build
# and the libgcc branch's in turn, twice, each under its own hold of the lock, each with its own snapshot cache.
export EXCLUSIVE_OWNER=claude-libgcc-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/483"
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
printf '#include <stdio.h>\nint main(void) { puts("hello"); return 0; }\n' > $B/libgcc-hello.c
for round in 1 2; do
    for d in libgcc-136-main libgcc-136-claude; do
        cd $B/$d || exit 1
        mkdir -p proc-cache
        XDG_CACHE_HOME=$B/$d/proc-cache $X taskset -c 2 ./build/compiler time-runs --runs 41 --warmups 5 --list $B/libgcc-hello.c -o $B/$d/proc-hello > proc-$round.log 2>&1
        echo "== $d $round: $?"; grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:" proc-$round.log | tail -8
    done
done
