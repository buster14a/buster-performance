#!/bin/bash
# Shards K... of 8 again in `ci`, after removing the reports an earlier run of the inventory left in its build/ (each
# opened "wx", exclusively, so that a second run in one tree refuses them): rerun-shards.sh K..., one lock hold each.
set -u
d=$HOME/buster-fast-bench/2559-claude
rm -f "$d"/ci/build/checker-sqlite.tsv "$d"/ci/build/oracle-accounting.tsv "$d"/ci/build/oracle-libc.tsv "$d"/ci/build/oracle-musl.tsv "$d"/ci/build/oracle-sqlite.tsv
mkdir -p "$d/results/inventory/first"
for k in "$@"; do
    mv "$d/results/inventory/shard-$k-of-8.log" "$d/results/inventory/first/" 2> /dev/null
    start=$(date -u +%FT%TZ)
    "$d/scripts/lock.sh" "$d/scripts/inventory.sh" shard "$k" 8
    printf '%s\t%s\trc=%s\tshard %s 8 again\n' "$start" "$(date -u +%FT%TZ)" "$?" "$k" >> "$d/results/inventory/queue.txt"
done
