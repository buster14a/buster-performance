#!/bin/bash
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/after2.pid
while kill -0 $(cat $W/after.pid) 2>/dev/null; do sleep 10; done
$W/ab.sh > $W/ab.log 2>&1
