#!/bin/bash
# #530: is check-declarations' increase the cache warmth base's report scan left? The probe build of d32d593f re-reads
# every node's value at the end of the graph run when BUSTER_PROBE_TOUCH_VALUES is set (the same binary either way);
# main a774acd2 runs beside it. Under the shared lock, pinned to CPU 2, the order rotating by round.
set -u
cd ~/buster-fast-bench/perf-530-claude
export EXCLUSIVE_OWNER=claude-530 EXCLUSIVE_TITLE="#530 checker passes: check-declarations probe" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/573
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
quoted=$(printf '%q ' "${options[@]}")
echo "start $(date -Is)"
if [ ! -x probe-d32d/build/compiler ]; then
    (cd probe-d32d && BUSTER_DEBUG_INFO=0 $lock ./build.sh) > build-probe-d32d.log 2>&1 || { echo "build failed"; tail -5 build-probe-d32d.log; exit 1; }
    tail -1 build-probe-d32d.log
fi
sha256sum probe-d32d/build/compiler main-a774/build/compiler
$lock bash -c "taskset -c 2 probe-d32d/build/compiler $quoted -o probe-plain.o && BUSTER_PROBE_TOUCH_VALUES=1 taskset -c 2 probe-d32d/build/compiler $quoted -o probe-touch.o" && cmp probe-plain.o probe-touch.o && echo "probe objects identical: $(sha256sum probe-plain.o | cut -c1-16)"
: > stages-touch.txt
for hold in 1 2 3; do
    $lock bash -c "
        run() { case \$1 in
            main) taskset -c 2 main-a774/build/compiler --time-stages $quoted -o /dev/null 2>&1 | sed 's/^/main /' ;;
            plain) taskset -c 2 probe-d32d/build/compiler --time-stages $quoted -o /dev/null 2>&1 | sed 's/^/plain /' ;;
            touch) BUSTER_PROBE_TOUCH_VALUES=1 taskset -c 2 probe-d32d/build/compiler --time-stages $quoted -o /dev/null 2>&1 | sed 's/^/touch /' ;;
        esac; }
        variants=(main plain touch)
        for round in 1 2 3 4 5 6 7 8 9 10; do
            r=\$(( ($hold - 1) * 10 + round ))
            for k in 0 1 2; do run \${variants[\$(( (r + k) % 3 ))]}; done
        done" >> stages-touch.txt
done
echo "done $(date -Is)"
