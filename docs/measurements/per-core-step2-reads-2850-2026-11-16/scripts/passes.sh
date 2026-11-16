#!/bin/bash
# passes.sh LABEL SUFFIX RUNS CORPORA [shadow options]: measure-node-machine --shadow --facts [options] on the corpora
# named (a quoted list of sqlite3, lua, musl) by results/LABEL/compiler, CPU 2, each run its own hold of the lock, with
# what else ran. Files results/LABEL/passes-<corpus><SUFFIX>-N.txt. A run that fails stops the script.
set -u
cd "$(dirname "$0")"
label=$1; suffix=$2; runs=$3; corpora=$4
shift 4
options="$*"
. ./corpora.sh
out=$PWD/results/$label
test -x "$out/compiler" || { echo "no compiler for $label"; exit 1; }
for n in $(seq 1 "$runs"); do
    for c in $corpora; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
            musl) arguments=$musl_arguments ;;
            *) echo "unknown corpus $c"; exit 1 ;;
        esac
        f=$out/passes-$c$suffix-$n.txt
        ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options $arguments; echo status \$?; $busy" > "$f" 2>&1
        grep -q '^status 0$' "$f" || { echo "FAILED: $f"; tail -3 "$f"; exit 1; }
    done
done
echo done
