#!/bin/bash
# job-where1.sh: where --node-bodies' cost on sqlite3.c is. The same binary (b0ee1afaa) with and without the option,
# in turn; each position takes the lock once: a warm-up, a --time-stages run, a perf record run and a counters run.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
rev=b0ee1afaa
cc="$dir/trees/$rev/build/compiler"
[[ -x $cc ]] || { echo "no compiler"; exit 1; }
for stale in 06681bbdb 89362fd0f; do [[ -d trees/$stale ]] || { [[ -e trees/$stale.built ]] && mv trees/$stale.built trees/$stale.built.stale; }; done
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/where-$rev"
mkdir -p "$out/scratch"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: where --node-bodies' cost is on sqlite3.c, $rev" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
cat > "$out/one.sh" <<'ONE'
#!/bin/bash
# one.sh COMPILER KEY SQLITE [OPTION]: a warm-up, a stage table, a profile and a counters run of one compile.
set -uo pipefail
cc=$1; key=$2; sq=$3; extra=${4:-}
out=$(dirname "$0")
cd "$out/scratch"
args=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c" -o unit.o)
cat /proc/loadavg > "$out/$key.load"
taskset -c 2 "$cc" $extra "${args[@]}" > /dev/null 2> "$out/$key.warm.stderr"
taskset -c 2 "$cc" $extra "${args[@]}" --time-stages > /dev/null 2> "$out/$key.stages"
sha256sum unit.o | cut -d' ' -f1 > "$out/$key.sha"
taskset -c 2 perf record -q -e cycles -c 100003 -o "$out/$key.data" -- "$cc" $extra "${args[@]}" > /dev/null 2>&1
taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,branch-misses:u,L1-dcache-load-misses:u,dTLB-load-misses:u,cache-misses:u -o "$out/$key.stat" -- "$cc" $extra "${args[@]}" > /dev/null 2>&1
rm -f unit.o
ONE
chmod +x "$out/one.sh"
for i in 1 2 3 4 5 6 7; do
    if (( i % 2 )); then order="plain bodies"; else order="bodies plain"; fi
    for arm in $order; do
        extra=""; [[ $arm == bodies ]] && extra="--node-bodies"
        "$HOME/buster-fast-bench/exclusive.sh" "$out/one.sh" "$cc" "$arm-$i" "$sq" $extra 2>> "$out/lock.log"
        echo "round $i $arm done $(date -u +%H:%M:%S)"
    done
done
cd "$out"
for f in *.data; do perf report -i "$f" --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > "${f%.data}.report"; done
sort -u ./*.sha | wc -l > distinct-objects.txt
echo job-complete
