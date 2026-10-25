#!/bin/bash
# queue2.sh LOG STEP...: each STEP (TREE:VARIANT for sched.sh, or TREE:build for a whole build.sh) under its own hold of
# the 9700X's lock, 20 s apart.
log="$1"
shift
for step in "$@"; do
    tree="${step%%:*}"
    variant="${step#*:}"
    echo "== $step $(date -Is)" >> "$log"
    if [ "$variant" = build ]; then
        (cd "$tree" && EXCLUSIVE_OWNER=claude-270 EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)" \
            EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/270 ~/buster-fast-bench/exclusive.sh \
            bash -c 'TIMEFORMAT="time: %R s wall, %U s user, %S s sys"; time BUSTER_DEBUG_INFO=0 ./build.sh; ls -l build/compiler | awk "{print \"size:\", \$5}"') >> "$log" 2>&1
    else
        EXCLUSIVE_OWNER=claude-270 EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)" \
            EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/270 ~/buster-fast-bench/exclusive.sh \
            bash -c 'TIMEFORMAT="time: %R s wall, %U s user, %S s sys"; time ~/buster-fast-bench/build-270-claude/sched.sh "$0" "$1"' "$variant" "$tree" >> "$log" 2>&1
    fi
    sleep 20
done
echo "done $(date -Is)" >> "$log"
