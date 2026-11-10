#!/bin/bash
# Times a clean ASan build of this worktree as a hosted runner would run it: 2 physical cores, 4 threads (the caller's
# cores grant), with build.sh's default jobs (one per physical core) and then with one per thread.
set -u
export LC_ALL=C
cd /home/david/dev/ai/claude/buster/.claude/worktrees/asan-driver-2030 || exit 2
out=$HOME/.cache/claude-pr2056-review/2030
for jobs in default 4; do
    rm -rf build/cmake/native-address-O3
    TIMEFORMAT='%R %U %S'
    if [ "$jobs" = default ]; then
        { time env -u CPATH BUSTER_SANITIZER=address ./build.sh > "$out/build-$jobs.log" 2>&1; } 2> "$out/build-$jobs.time"
    else
        { time env -u CPATH BUSTER_SANITIZER=address ./build.sh --jobs "$jobs" > "$out/build-$jobs.log" 2>&1; } 2> "$out/build-$jobs.time"
    fi
    echo "jobs=$jobs $(cat "$out/build-$jobs.time") | $(grep 'units compiled' "$out/build-$jobs.log")" >> "$out/build-jobs.txt"
done
