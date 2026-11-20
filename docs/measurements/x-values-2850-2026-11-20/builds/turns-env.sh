#!/bin/bash
# turns-env.sh SUFFIX RUNS "CORPORA" SPEC...: as turns.sh, each SPEC "LABEL TAG SKIP [options]" run with
# BUSTER_TESTS_SKIP=SKIP in its environment (an experiment build's switch): the same executable, one setting a turn.
set -u
cd "$(dirname "$0")"
suffix=$1; runs=$2; corpora=$3
shift 3
specs=("$@")
. ./corpora.sh
for n in $(seq 1 "$runs"); do
    for c in $corpora; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
            musl) arguments=$musl_arguments ;;
            *) echo "unknown corpus $c"; exit 1 ;;
        esac
        for spec in "${specs[@]}"; do
            read -r label tag skip options <<< "$spec"
            out=$PWD/results/$label
            test -x "$out/compiler" || { echo "no compiler for $label"; exit 1; }
            f=$out/$tag-$c$suffix-$n.txt
            ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; BUSTER_TESTS_SKIP=$skip taskset -c 2 $out/compiler measure-node-machine $options $arguments; echo status \$?; $busy" > "$f" 2>&1
        done
    done
done
echo "turns$suffix done"
