#!/bin/bash
# job-xse2.sh LABEL PATCH REVISION RUNS SUFFIX "SETTINGS" "CORPORA": an experiment build of the side facts' sweep on the
# 9700X (LABEL: PATCH on REVISION, with a switch read from the environment, not for a commit): in each reading the same
# executable with each of SETTINGS in turn (a number, the switch's value; a `b` after it is the same value again), RUNS
# readings on CORPORA, CPU 2, each run its own hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3; runs=$4; suffix=$5; settings=$6; corpora=$7
test -x "results/$label/compiler" || ./build-label.sh "$label" "$revision" "$patch" || exit 1
set -u
. ./corpora.sh
out=$PWD/results/$label
for n in $(seq 1 "$runs"); do
    cp "$out/compiler" "$out/compiler-turn" && cat "$out/compiler-turn" > /dev/null || exit 1
    for c in $corpora; do
        case $c in sqlite3) arguments=$sqlite_arguments ;; lua) arguments=$lua_arguments ;; musl) arguments=$musl_arguments ;; esac
        for setting in $settings; do
            value=${setting%b}
            f=$out/e$setting-$c$suffix-$n.txt
            ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; BUSTER_SUMMARY_EXPERIMENT=$value taskset -c 2 $out/compiler-turn measure-node-machine --shadow --passes 0 --window-rows $arguments; echo status \$?; $busy" > "$f" 2>&1
        done
    done
    rm -f "$out/compiler-turn"
done
echo job finished
