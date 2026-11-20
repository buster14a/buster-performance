#!/bin/bash
# s4 makes check_sparse_next return a token before the one asked for, so its callers loop: every test it reaches runs to
# its timeout. While s4 is the mutant under test, stop each test process that has run 300 s (none of the unmutated
# tree's tests here took 200 s in the round), so that its verdict is the same non-zero exit without the timeouts' hours.
R=/root/.cache/claude-c7/c12k/mut3/results.txt
log=/root/.cache/claude-c7/c12k/mut3/hang-s4.log
while ! grep -q '^s4 ' $R; do
    for pid in $(pgrep -f '^\./build/compiler test-check'); do
        cwd=$(readlink /proc/$pid/cwd 2>/dev/null)
        age=$(ps -o etimes= -p $pid 2>/dev/null | tr -d ' ')
        if [ "$cwd" = /root/.cache/claude-c7/c12k/mut3/tree ] && [ -n "$age" ] && [ "$age" -ge 300 ]; then
            echo "$(date +%T) stopped $pid after ${age}s: $(tr '\0' ' ' < /proc/$pid/cmdline)" >> $log
            kill -9 $pid
        fi
    done
    sleep 10
done
echo "$(date +%T) s4 done" >> $log
