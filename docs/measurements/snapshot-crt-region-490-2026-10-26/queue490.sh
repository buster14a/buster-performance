#!/bin/bash
# queue490.sh FIRST LAST: after the builds, rounds FIRST to LAST of round490.sh, each under its own hold of the shared
# lock, 20 s apart.
set -u
B=~/buster-fast-bench/perf-490-claude
export EXCLUSIVE_OWNER=claude-490 EXCLUSIVE_TITLE="Performance issues #490 #446 #445" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/490
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
printf '#include <stdio.h>\nint main(void) { puts("hello"); return 0; }\n' > "$B/hello.c"
for r in $(seq "$1" "$2"); do
    ~/buster-fast-bench/exclusive.sh "$B/round490.sh" "$r" >> "$B/progress.log" 2>&1
    echo "round $r status $? $(date -Is)" >> "$B/progress.log"
    sleep 20
done
echo "done $(date -Is)" >> "$B/progress.log"
