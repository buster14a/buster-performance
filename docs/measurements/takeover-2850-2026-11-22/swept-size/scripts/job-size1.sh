#!/bin/bash
# job-size1.sh REV: the size cut at REV against b0ee1afaa. A Release tree of REV; the stage tables and counters with
# and without --node-bodies (seven rounds, as job-where1); then the pairs: the option against without at REV on the five
# workloads, the option in both arms b0ee1afaa against REV on sqlite and musl, and the option off on the four.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
rev=$1
old=b0ee1afaa
[[ -d trees/4fcadeb45 ]] && git -C src worktree remove --force "$dir/trees/4fcadeb45" && mv trees/4fcadeb45.built trees/4fcadeb45.built.stale
./setup.sh "$rev" || { echo "setup failed"; exit 1; }
cc="$dir/trees/$rev/build/compiler"
[[ -x $cc && -x trees/$old/build/compiler ]] || { echo "no compiler"; exit 1; }
until awk '{exit !($1 < 2.0)}' /proc/loadavg; do sleep 10; done
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/where-$rev"
mkdir -p "$out/scratch"
cp results/where-$old/one.sh "$out/one.sh"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: stages of sqlite3.c with and without --node-bodies, $rev" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
for i in 1 2 3 4 5 6 7; do
    if (( i % 2 )); then order="plain bodies"; else order="bodies plain"; fi
    for arm in $order; do
        extra=""; [[ $arm == bodies ]] && extra="--node-bodies"
        "$HOME/buster-fast-bench/exclusive.sh" "$out/one.sh" "$cc" "$arm-$i" "$sq" $extra 2>> "$out/lock.log"
    done
done
( cd "$out" && for f in *.data; do perf report -i "$f" --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > "${f%.data}.report"; done; sort -u ./*.sha | wc -l > distinct-objects.txt; rm -f ./*.data )
echo "stages done $(date -u +%H:%M:%S)"
pair()
{
    local parent=$1 candidate=$2 workload=$3 rounds=$4 extra=${5:-}
    local name="pair2-$workload-$parent-$candidate${extra:+-$(printf '%s' "$extra" | tr -c 'a-zA-Z0-9' '_')}"
    ./pair2.sh "$parent" "$candidate" "$workload" "$rounds" $extra && python3 reduce2.py "results/$name" > "results/$name/summary.txt"
    echo "pair $name ${PARENT_EXTRA:+(parent $PARENT_EXTRA) }done $(date -u +%H:%M:%S)"; sed -n 2,5p "results/$name/summary.txt"
}
pair "$rev" "$rev" sqlite 7 --node-bodies
PARENT_EXTRA=--node-bodies pair "$old" "$rev" sqlite 7 --node-bodies
mv "results/pair2-sqlite-$old-$rev-__node_bodies" "results/pair2-sqlite-$old-$rev-both-node_bodies"
pair "$rev" "$rev" musl 5 --node-bodies
PARENT_EXTRA=--node-bodies pair "$old" "$rev" musl 5 --node-bodies
mv "results/pair2-musl-$old-$rev-__node_bodies" "results/pair2-musl-$old-$rev-both-node_bodies"
pair "$rev" "$rev" lua 5 --node-bodies
pair "$rev" "$rev" main 5 --node-bodies
pair "$rev" "$rev" sqlitewall 5 --node-bodies
pair "$old" "$rev" sqlite 7
pair "$old" "$rev" main 5
pair "$old" "$rev" lua 5
pair "$old" "$rev" musl 5
echo job-complete
