#!/bin/bash
# reads.sh LABEL: the census of what reads T's record (measure-node-machine --shadow --facts-reads --passes 0) on
# sqlite3.c, Lua and musl by results/LABEL/compiler, CPU 2, each corpus its own hold of the lock, with what else ran and
# the run's wall time; --list 400 lists the records C or X decide on an identity of, and only the census's own lines and
# the fact words' are kept. Counts: nothing is timed. Files results/LABEL/reads-<corpus>.txt. A run that fails stops the script.
set -u
cd "$(dirname "$0")"
label=$1
. ./corpora.sh
out=$PWD/results/$label
test -x "$out/compiler" || { echo "no compiler for $label"; exit 1; }
for c in sqlite3 lua musl; do
    case $c in
        sqlite3) arguments=$sqlite_arguments ;;
        lua) arguments=$lua_arguments ;;
        musl) arguments=$musl_arguments ;;
    esac
    f=$out/reads-$c.txt
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; start=\$(date +%s%N); taskset -c 2 $out/compiler measure-node-machine --shadow --facts-reads --passes 0 --list 400 $arguments | grep -E '^node-(reads|facts): |^node-shadow: (census|machine)-taken'; echo status \${PIPESTATUS[0]}; echo wall \$(( (\$(date +%s%N) - start) / 1000000 )) ms; $busy" > "$f" 2>&1
    grep -q '^status 0$' "$f" || { echo "FAILED: $f"; tail -3 "$f"; exit 1; }
done
echo done
