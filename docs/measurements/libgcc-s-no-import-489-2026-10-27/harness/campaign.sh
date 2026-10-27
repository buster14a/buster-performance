#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-489 EXCLUSIVE_TITLE='Buster #489 paired measurement' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/489
B=$HOME/buster-fast-bench
X=$B/exclusive.sh
run()
{
    local label=$1
    shift
    if "$X" "$@" > "campaign/logs/$label-$round.log" 2> "campaign/logs/$label-$round.stderr"; then
        echo "$variant $label $round PASS"
    else
        echo "$variant $label $round FAIL"
        exit 1
    fi
}
# benchmark-link reports runtime_open, bind_begin, bind_end plus dynamic_inputs, the write and their total together.
# Repeat that complete producer/consumer path and the fresh-process driver in balanced order. Separate microbenchmarks
# are supplementary 21-sample medians, once per binary, for the snapshot size/probe phases and binding instructions.
for round in 1 2 3; do
    order='libgcc-s-489-main codex-489-base codex-489-head'
    [ "$round" != 2 ] || order='codex-489-head codex-489-base libgcc-s-489-main'
    for variant in $order; do
        cd "$B/$variant"
        mkdir -p campaign/tmp campaign/cache campaign/proc-cache campaign/logs
        export TMPDIR=$PWD/campaign/tmp
        run link ./build/compiler benchmark-link --only direct --kinds dynamic,shared --directory "$PWD/campaign/tmp" --cache "$PWD/campaign/cache"
        XDG_CACHE_HOME=$PWD/campaign/proc-cache run hello taskset -c 2 ./build/compiler time-runs --runs 41 --warmups 5 --list "$B/libgcc-s-489-hello.c" -o "$PWD/campaign/hello"
    done
done
round=extra
for variant in libgcc-s-489-main codex-489-base codex-489-head; do
    cd "$B/$variant"
    export TMPDIR=$PWD/campaign/tmp
    run snapshot taskset -c 2 ./build/compiler benchmark-snapshot --directory "$PWD/campaign/tmp"
    run bind taskset -c 2 ./build/compiler benchmark-bind --functions 1,2000
done
echo 'campaign done'
