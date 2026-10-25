#!/bin/bash
# run-builds.sh LOG ROUNDS TREE...: ROUNDS rounds of one locked build of each TREE in turn, as the 9700X job builds
# (BUSTER_DEBUG_INFO=0), each under its own hold of the lock, with a pause between holds; every report goes to LOG.
log="$1"
rounds="$2"
shift 2
for round in $(seq "$rounds"); do
    for tree in "$@"; do
        echo "== round $round $tree" >> "$log"
        (cd "$tree" && EXCLUSIVE_OWNER=claude-270 EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)" \
            EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/270 ~/buster-fast-bench/exclusive.sh \
            bash -c 'TIMEFORMAT="time: %R s wall, %U s user, %S s sys"; time BUSTER_DEBUG_INFO=0 ./build.sh') >> "$log" 2>&1
        ls -l "$tree/build/compiler" | awk '{print "size:", $5}' >> "$log"
        sleep 20
    done
done
echo "done" >> "$log"
