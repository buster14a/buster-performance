#!/bin/bash
# pads.sh "LABELS" "PADS" CORPUS TAG options...: measure-node-machine on one corpus, CPU 2, each LABEL's compiler once a
# pad in turn, with an environment variable of PAD bytes (the stack's place moves by it): each run its own hold of the
# lock. Files results/LABEL/TAG-<corpus>-pad<PAD>.txt.
set -u
cd "$(dirname "$0")"
labels=$1; pads=$2; c=$3; tag=$4
shift 4
options="$*"
. ./corpora.sh
case $c in
    sqlite3) arguments=$sqlite_arguments ;;
    lua) arguments=$lua_arguments ;;
    musl) arguments=$musl_arguments ;;
    *) echo "unknown corpus $c"; exit 1 ;;
esac
for pad in $pads; do
    filler=$(head -c "$pad" /dev/zero | tr '\0' 'x')
    for label in $labels; do
        out=$PWD/results/$label
        f=$out/$tag-$c-pad$pad.txt
        ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; BUSTER_PAD=$filler taskset -c 2 $out/compiler measure-node-machine $options $arguments; echo status \$?; $busy" > "$f" 2>&1
    done
done
echo "pads done"
