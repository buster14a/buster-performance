#!/bin/bash
# #877: run.sh once build.sh is done, provided every build succeeded and each tree's offset-0 build is its unpatched one.
set -u
R=$HOME/buster-fast-bench/877-claude; L=$R/logs
echo $$ > $R/chain.pid
while [ ! -e $L/build-done ]; do sleep 30; done
if grep -q 'build status [^0]' $L/receipts.txt || grep -q DIFFERS $L/receipts.txt || [ "$(grep -c 'byte for byte' $L/receipts.txt)" -ne 4 ]; then
    echo "chain: the builds failed their checks; not measuring" >> $L/receipts.txt
    exit 1
fi
exec $R/run.sh
