#!/bin/bash
# Waits for e3-build.sh (by its PID), then runs e3-run.sh if every build succeeded.
R=$HOME/buster-fast-bench/1233-claude
echo $$ > $R/e3-chain.pid
p=$(cat $R/e3-build.pid)
while kill -0 $p 2>/dev/null; do sleep 10; done
if [ -f $R/logs/e3-build-done ] && [ $(grep -c "var-.* build status 0" $R/logs/receipts.txt) -eq 8 ]; then
    exec $R/e3-run.sh
else
    echo "e3 builds incomplete; not measuring" >> $R/logs/receipts.txt
fi
