#!/bin/bash
# usage: one-run.sh OUT LABEL COMPILER N ROUND -- one run, under the lock held by its caller (exclusive.sh): the lock's
# owner file as its receipt, then N independent -c compiles of the frozen sqlite3.c pinned to CPUs 0..N-1, each one's
# exit status, the batch's wall time and the objects' hashes, as one line of OUT/runs.txt.
out=$1; label=$2; C=$3; n=$4; round=$5
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
d=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" --lanes 1)
receipt=$(head -1 /var/lib/buster-9700x/owner | tr '\t' ' ')
held=${BUSTER_9700X_HELD:-0}
dir=$out/objects/$label-$n-$round; mkdir -p $dir
pids=()
s=$(date +%s%N)
for ((c = 0; c < n; c++)); do taskset -c $c $C "${d[@]}" -o $dir/w$c.o 2> $dir/w$c.err & pids+=($!); done
statuses=()
for p in "${pids[@]}"; do wait $p; statuses+=($?); done
e=$(date +%s%N)
hashes=$(sha256sum $dir/w*.o | awk '{print $1}' | sort | uniq -c | awk '{printf "%s×%s ", $1, substr($2, 1, 16)}')
printf 'round %s build %s workers %s wall_ns %s statuses %s held %s objects %s receipt %s\n' "$round" "$label" "$n" "$((e-s))" "$(IFS=,; echo "${statuses[*]}")" "$held" "$hashes" "$receipt" >> $out/runs.txt
rm -f $dir/w*.o
