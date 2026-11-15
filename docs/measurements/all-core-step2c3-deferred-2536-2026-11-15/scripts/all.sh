#!/bin/bash
cd /home/user/.cache/claude-2536/step2c3
for w in 1 2048 0; do
    nice -n 10 ./compare.sh "$PWD/compiler-head" "$PWD/deferred.sh" "$PWD/w$w" --emit-window=$w > "w$w.log" 2>&1
done
nice -n 10 ./compare.sh "$PWD/compiler-head" "$PWD/deferred.sh" "$PWD/g2048" -g > g2048.log 2>&1
nice -n 10 ./compare.sh "$PWD/compiler-head" "$PWD/deferred.sh" "$PWD/s2048" --scalar > s2048.log 2>&1
echo done > all.done
