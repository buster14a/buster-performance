#!/bin/bash
# inventory.sh's steps in order, one lock hold each; results/inventory/queue.txt has each step's times and status.
set -u
d=$HOME/buster-fast-bench/2559-claude
echo $$ > "$d/inventory-queue.pid"
mkdir -p "$d/results/inventory"
shards=${1:-8}
step() {
    local start=$(date -u +%FT%TZ)
    "$d/scripts/lock.sh" "$d/scripts/inventory.sh" "$@"
    local rc=$?
    printf '%s\t%s\trc=%s\t%s\n' "$start" "$(date -u +%FT%TZ)" "$rc" "$*" >> "$d/results/inventory/queue.txt"
}
step prepare > "$d/results/inventory/prepare.log" 2>&1
for k in $(seq 1 "$shards"); do
    step shard "$k" "$shards"
done
echo done >> "$d/results/inventory/queue.txt"
