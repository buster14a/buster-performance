#!/bin/bash
# job-order-base.sh: the start order made again from main's own build (base), with the inputs the committed list was
# made with (piece 2's): how far main's list is from what its compiles run now. Each call of order.sh in one hold of
# the lock; musl's units in four parts.
cd "$(dirname "$0")"
p2=~/buster-fast-bench/2873-p2-claude/w
mkdir -p order-inputs
cp "$p2/inputs/empty.c" "$p2/inputs/tiny.c" "$p2/inputs/hello.c" order-inputs/
sed 's|inputs/|order-inputs/|g' "$p2/order.sh" > order.sh
chmod +x order.sh
: > job-order-base.done
out=results/order-base
log=order-base.log
: > "$log"
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    start=$(date +%s)
    ./lock.sh timeout -k 10 600 ./order.sh base "$out" $step >> "$log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $step" >> "$log"
done
cat "$out/counts.txt" >> "$log"
grep -v '^#' base/cmake/BusterStartOrder.txt > "$out/committed-body.txt"
grep -v '^#' "$out/body.txt" > "$out/new-body.txt"
{
    echo "committed: $(grep -c . "$out/committed-body.txt") functions; made again: $(grep -c . "$out/new-body.txt")"
    echo "in the committed list alone: $(comm -23 <(sort "$out/committed-body.txt") <(sort "$out/new-body.txt") | wc -l)"
    echo "in the new list alone: $(comm -13 <(sort "$out/committed-body.txt") <(sort "$out/new-body.txt") | wc -l)"
    echo "lines whose place differs (diff): $(diff "$out/committed-body.txt" "$out/new-body.txt" | grep -c '^[<>]')"
    comm -23 <(sort "$out/committed-body.txt") <(sort "$out/new-body.txt") | head -20 | sed 's/^/  gone: /'
    comm -13 <(sort "$out/committed-body.txt") <(sort "$out/new-body.txt") | head -20 | sed 's/^/  new: /'
} > "$out/compare.txt" 2>&1
cat "$out/compare.txt" >> "$log"
echo finished > job-order-base.done
