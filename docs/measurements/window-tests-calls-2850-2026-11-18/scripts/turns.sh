#!/bin/bash
# turns.sh SUFFIX RUNS "CORPORA" SPEC...: measure-node-machine on the corpora named (sqlite3, lua, musl), CPU 2, RUNS
# readings, each SPEC "LABEL TAG [options]" in turn inside a reading, each run its own hold of the lock, with what else
# ran. Files results/LABEL/TAG-<corpus>SUFFIX-N.txt, each ending in its exit status. A SPEC's options start with
# --shadow for the shadow, or are the plain census's.
# Each reading runs each build from a fresh copy of its compiler, read once before the reading's runs and removed after
# them: a file's pages in the page cache can make one function read a third more ticks (buster#2967), and a copy a
# reading makes such a file one outlier and not a build's result.
set -u
cd "$(dirname "$0")"
suffix=$1; runs=$2; corpora=$3
shift 3
specs=("$@")
. ./corpora.sh
for n in $(seq 1 "$runs"); do
    copies=()
    for spec in "${specs[@]}"; do
        read -r label tag options <<< "$spec"
        out=$PWD/results/$label
        test -x "$out/compiler" || { echo "no compiler for $label"; exit 1; }
        if ! test -e "$out/compiler-turn"; then
            cp "$out/compiler" "$out/compiler-turn" && cat "$out/compiler-turn" > /dev/null || { echo "no copy for $label"; exit 1; }
            copies+=("$out/compiler-turn")
        fi
    done
    for c in $corpora; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
            musl) arguments=$musl_arguments ;;
            *) echo "unknown corpus $c"; rm -f "${copies[@]}"; exit 1 ;;
        esac
        for spec in "${specs[@]}"; do
            read -r label tag options <<< "$spec"
            out=$PWD/results/$label
            f=$out/$tag-$c$suffix-$n.txt
            ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler-turn measure-node-machine $options $arguments; echo status \$?; $busy" > "$f" 2>&1
        done
    done
    rm -f "${copies[@]}"
done
echo "turns$suffix done"
