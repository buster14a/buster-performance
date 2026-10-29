#!/bin/bash
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/after.pid
while kill -0 $(cat $W/final.pid) 2>/dev/null; do sleep 10; done
$W/receipts.sh > $W/receipts.log 2>&1
$W/stages.sh > $W/stages.log 2>&1
echo after-finished >> $W/stages.log
