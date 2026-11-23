#!/bin/bash
# One hold of the lock: several configurations of one tree's compile, counted by step 0's gauge in turns (PASSES passes of
# three rounds each, the configurations in order within a pass), so that they share the host's state.
# pair7.sh TREE OUT PASSES CONFIG...   CONFIG is NAME|SIZES|ENV,ENV|OPTION,OPTION
#   SIZES: the transparent huge page sizes in kB (16,32,64,128...) set to madvise for the configuration; every other
#   size the script touches is never, and all are never again when it ends.   (run under exclusive.sh)
set -euo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
tree=${1:?tree}
out=$dir/results/${2:?out}
passes=${3:?passes}
shift 3
thp=/sys/kernel/mm/transparent_hugepage
sizes="16 32 64 128 256"
knobs() { for s in $sizes; do printf '%s:%s ' "$s" "$(sed 's/.*\[\(.*\)\].*/\1/' $thp/hugepages-${s}kB/enabled)"; done; }
restore() { for s in $sizes; do echo never | sudo -n tee $thp/hugepages-${s}kB/enabled > /dev/null; done; echo "$(date -u +%FT%TZ) restored: $(knobs)" >> "$out/switch.txt"; }
trap restore EXIT
mkdir -p "$out"
cd "$dir/$tree"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
{ date -u +%FT%TZ; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; } >> "$out/busy.txt"
for pass in $(seq 1 "$passes"); do
    for config in "$@"; do
        IFS='|' read -r name on envs options <<< "$config"
        for s in $sizes; do
            case ",$on," in *",$s,"*) v=madvise ;; *) v=never ;; esac
            echo $v | sudo -n tee $thp/hugepages-${s}kB/enabled > /dev/null
        done
        echo "$(date -u +%FT%TZ) $name.$pass set: $(knobs) env: $envs options: $options" >> "$out/switch.txt"
        gauge="$out/$name.$pass"
        mkdir -p "$gauge"
        ( IFS=,; for e in $envs; do export "$e"; done; unset IFS
          # shellcheck disable=SC2086
          build/allcore counted --rounds 3 --out "$gauge" -- ./build/compiler --time-stages --lanes 1 -c $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$gauge/%l.w%w.o" ) 2> "$gauge/counted.err"
    done
done
{ date -u +%FT%TZ; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; } >> "$out/busy.txt"
