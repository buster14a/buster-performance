#!/bin/bash
# Campaign SO5 (#764): source order's reader without a reading on more than one lane in its processes, A2's 43 units
# with --lanes 1 (every reading on one lane: no tree reads anything in base pages), the head and main, five rounds,
# 22 jobs a lock hold, 30 s apart, into logs/SO5.txt; then the driver's -fsyntax-only of the frozen sqlite3.c, perf
# stat -r 11 of each tree in turn, three rounds, a round a lock hold (logs/driver.txt). Arguments: HEAD MAIN.
. ~/buster-fast-bench/claude-764/scripts/env.sh
"$D/scripts/make-jobs.sh" "$D/scripts/so5.jobs" "$1:1" "$2:1"
"$D/scripts/queue.sh" scripts/so5.jobs logs/SO5.txt 1 0 5 22 30
cat > "$D/scripts/driver-round.sh" <<'INNER'
#!/bin/bash
. ~/buster-fast-bench/claude-764/scripts/env.sh
round="$1"; shift
for tree in "$@"; do
    echo "== round $round $tree driver sqlite3.c" >> "$D/logs/driver.txt"
    perf stat -r 11 -x, -e task-clock,cycles:u,instructions:u -o "$D/logs/driver-$round-$tree.csv" "$D/trees/$tree/build/compiler" -fsyntax-only \
        --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" \
        -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" >> "$D/logs/driver.txt" 2>&1
    echo "exit=$? $(date -Is)" >> "$D/logs/driver.txt"
    cat "$D/logs/driver-$round-$tree.csv" >> "$D/logs/driver.txt"
done
INNER
chmod +x "$D/scripts/driver-round.sh"
for round in 1 2 3; do
    if [ $((round % 2)) = 1 ]; then
        ~/buster-fast-bench/exclusive.sh "$D/scripts/driver-round.sh" "$round" "$1" "$2" > /dev/null 2>> "$D/logs/queue.lock.txt"
    else
        ~/buster-fast-bench/exclusive.sh "$D/scripts/driver-round.sh" "$round" "$2" "$1" > /dev/null 2>> "$D/logs/queue.lock.txt"
    fi
    sleep 30
done
echo "so5 done $(date -Is)" >> "$D/logs/chain.txt"
