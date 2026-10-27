#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-489 EXCLUSIVE_TITLE='Buster #489 final paired measurement' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/489
B=$HOME/buster-fast-bench
X=$B/exclusive.sh
run()
{
    local label=$1
    shift
    if "$X" "$@" > "final-campaign/logs/$label-$round.log" 2> "final-campaign/logs/$label-$round.stderr"; then
        echo "$variant $label $round PASS"
    else
        echo "$variant $label $round FAIL"
        exit 1
    fi
}
for round in 1 2 3; do
    order='libgcc-s-489-main codex-489-base codex-489-final'
    [ "$round" != 2 ] || order='codex-489-final codex-489-base libgcc-s-489-main'
    for variant in $order; do
        cd "$B/$variant"
        mkdir -p final-campaign/tmp final-campaign/cache final-campaign/proc-cache final-campaign/logs
        export TMPDIR=$PWD/final-campaign/tmp
        run link ./build/compiler benchmark-link --only direct --kinds dynamic,shared --directory "$PWD/final-campaign/tmp" --cache "$PWD/final-campaign/cache"
    done
done
# The complete-link samples above are the repeated acceptance comparison. Supplementary microbenchmarks report the
# snapshot's size and per-load phases, and binding instructions; one 41-process driver sample checks layout/RSS effects.
round=extra
for variant in libgcc-s-489-main codex-489-base codex-489-final; do
    cd "$B/$variant"
    export TMPDIR=$PWD/final-campaign/tmp
    run snapshot taskset -c 2 ./build/compiler benchmark-snapshot --directory "$PWD/final-campaign/tmp"
    run bind taskset -c 2 ./build/compiler benchmark-bind --functions 1,2000
    XDG_CACHE_HOME=$PWD/final-campaign/proc-cache run hello taskset -c 2 ./build/compiler time-runs --runs 41 --warmups 5 --list "$B/libgcc-s-489-hello.c" -o "$PWD/final-campaign/hello"
done
echo 'final campaign done'
