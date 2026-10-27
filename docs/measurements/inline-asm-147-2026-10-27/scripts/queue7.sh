#!/usr/bin/env bash
# After queue6.sh (PID $1): test-checker as the 9700X job runs it (the parallel runner, one command, CPUs 0 to 7),
# base and head, each run in a hold of its own (about a minute each).
cd ~/buster-fast-bench/asm-147-claude || exit 1
while kill -0 "$1" 2> /dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly lowering (#147, #126)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for t in base head head base; do
    printf '== test-checker %s\n%s/build/compiler test-checker --seed 133\n' "$t" "$t" > list-$t.txt
    ~/buster-fast-bench/exclusive.sh taskset -c 0-7 $t/build/compiler parallel --jobs 1 --timeout 300 list-$t.txt > checker-$t.log 2>&1
    echo "$t $? $(grep -E '^== test-checker|passed|failed' checker-$t.log | head -2 | tr '\n' ' ')"
done
echo done
