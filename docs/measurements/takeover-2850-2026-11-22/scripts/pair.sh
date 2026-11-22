#!/bin/bash
# pair.sh PARENT CANDIDATE [ROUNDS] [EXTRA_CANDIDATE_OPTIONS]: paired fresh-process readings of -c of the frozen
# sqlite3.c, one lane on CPU 2. Each round runs parent and candidate in ABBA or BAAB order; each position takes the
# lock once and runs a warm-up, a wall-clock run and a counters run (perf stat). The objects must be identical.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
parent=$1
candidate=$2
rounds=${3:-7}
extra=${4:-}
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/pair-$parent-$candidate${extra:+-$(echo "$extra" | tr -c 'a-zA-Z0-9' '_')}"
rm -rf "$out"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: paired -c sqlite3.c, $parent against $candidate $extra" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
flags="--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c"
one()
{
    local arm=$1 key=$2 rev options
    if [[ $arm = parent ]]; then rev=$parent; options=""; else rev=$candidate; options=$extra; fi
    local cc="$dir/trees/$rev/build/compiler"
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "
        cd '$out'
        cat /proc/loadavg > '$key.load'
        taskset -c 2 '$cc' $options $flags -o '$key.o' 2> '$key.warm.stderr'
        start=\$(date +%s%N)
        taskset -c 2 '$cc' $options $flags -o '$key.o' > '$key.stdout' 2> '$key.stderr'
        end=\$(date +%s%N)
        echo \$((end - start)) > '$key.wall'
        taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults -o '$key.perf' -- '$cc' $options $flags -o '$key.pmu.o' 2> /dev/null
        sha256sum < '$key.o' | cut -d' ' -f1 > '$key.sha'
        sha256sum < '$key.pmu.o' | cut -d' ' -f1 >> '$key.sha'
        cat '$key.stdout' '$key.stderr' | sha256sum | cut -d' ' -f1 > '$key.diag'
        rm -f '$key.o' '$key.pmu.o'
    " 2>> "$out/lock.log"
}
for i in $(seq 1 "$rounds"); do
    if (( i % 2 )); then order="parent candidate candidate parent"; else order="candidate parent parent candidate"; fi
    pos=0
    for arm in $order; do
        one "$arm" "r$i.p$pos.$arm"
        pos=$((pos + 1))
    done
done
echo done > "$out/complete"
