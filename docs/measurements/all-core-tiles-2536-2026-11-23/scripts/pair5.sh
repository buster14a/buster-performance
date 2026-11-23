#!/bin/bash
# One hold of the lock: several configurations of one tree's compile, counted by step 0's gauge in turns (two passes of
# three rounds each, the configurations in order within a pass), so that they share the host's state.
# pair5.sh TREE OUT CONFIG...   CONFIG is NAME:SWITCH[:NAME=VALUE[,NAME=VALUE...]]   (run under exclusive.sh)
set -euo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
tree=${1:?tree}
out=$dir/results/${2:?out}
shift 2
knob=/sys/kernel/mm/transparent_hugepage/hugepages-64kB/enabled
restore() { echo never | sudo -n tee "$knob" > /dev/null; echo "$(date -u +%FT%TZ) restored: $(cat $knob)" >> "$out/switch.txt"; }
trap restore EXIT
mkdir -p "$out"
cd "$dir/$tree"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
{ date -u +%FT%TZ; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; } >> "$out/busy.txt"
for pass in a b; do
    for config in "$@"; do
        name=${config%%:*}; rest=${config#*:}; switch=${rest%%:*}; envs=""
        if [ "$rest" != "$switch" ]; then envs=${rest#*:}; fi
        echo "$switch" | sudo -n tee "$knob" > /dev/null
        echo "$(date -u +%FT%TZ) $name.$pass set: $(cat $knob) env: $envs" >> "$out/switch.txt"
        gauge="$out/$name.$pass"
        mkdir -p "$gauge"
        ( IFS=,; for e in $envs; do export "$e"; done
          build/allcore counted --rounds 3 --out "$gauge" -- ./build/compiler --time-stages --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$gauge/%l.w%w.o" ) 2> "$gauge/counted.err"
    done
done
{ date -u +%FT%TZ; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; } >> "$out/busy.txt"
