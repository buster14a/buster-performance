#!/bin/bash
# job-knobs.sh LABEL PATCH BASE RUNS "KNOBS": the experiment build LABEL (PATCH on BASE's main revision) run with each of
# BUSTER_CALLS_KNOB's values KNOBS in turn inside a reading, RUNS readings, on the three corpora, CPU 2, each run its own
# hold of the lock. Files results/LABEL/knob<K>-<corpus>-<n>.txt.
cd "$(dirname "$0")"
label=$1; patch=$2; base=$3; runs=$4; knobs=$5
revision=$(head -1 results/$base/revision.txt)
./build-label.sh "$label" "$revision" "$patch" || exit 1
. ./corpora.sh
out=$PWD/results/$label
for n in $(seq 1 "$runs"); do
    for c in sqlite3 lua musl; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
            musl) arguments=$musl_arguments ;;
        esac
        for k in $knobs; do
            f=$out/knob$k-$c-$n.txt
            ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; BUSTER_CALLS_KNOB=$k taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-tests $arguments; echo status \$?" > "$f" 2>&1
        done
    done
done
echo job finished
