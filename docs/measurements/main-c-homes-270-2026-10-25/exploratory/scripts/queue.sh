#!/bin/bash
# queue.sh LOG TREE VARIANT...: each VARIANT of sched.sh on TREE under its own hold of the 9700X's lock, 20 s apart.
log="$1"
tree="$2"
shift 2
for variant in "$@"; do
    echo "== $variant $(date -Is)" >> "$log"
    EXCLUSIVE_OWNER=claude-270 EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)" \
        EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/270 ~/buster-fast-bench/exclusive.sh \
        bash -c 'TIMEFORMAT="time: %R s wall, %U s user, %S s sys"; time ~/buster-fast-bench/build-270-claude/sched.sh "$0" "$1"' "$variant" "$tree" >> "$log" 2>&1
    sleep 20
done
echo "done $(date -Is)" >> "$log"
